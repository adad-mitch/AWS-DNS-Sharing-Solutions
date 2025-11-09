# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "dns-test-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "dns-test-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Resource = "*"
      }
    ]
  })
}

# Security group for Lambda
resource "aws_security_group" "lambda_sg" {
  name_prefix = "dns-test-lambda-"
  description = "Security group for DNS test Lambda function"
  vpc_id      = aws_vpc.spoke.id

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.hub_vpc_cidr]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [var.hub_vpc_cidr]
  }

  tags = {
    Name = "dns-test-lambda-sg"
  }
}

resource "aws_lambda_function" "dns_test" {
  filename         = archive_file.lambda_zip.output_path
  function_name    = "dns-test-function"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.handler"
  runtime         = "python3.13"
  timeout         = 30
  
  # This ensures Lambda function gets updated when the zip changes
  source_code_hash = archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      DNS_DOMAIN    = var.dns_domain
      DNS_SUBDOMAIN = var.dns_subdomain
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.spoke_lambda.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  depends_on = [null_resource.lambda_package]

  tags = {
    Name = "dns-test-function"
  }
}

# Handling Lambda dependencies with Terraform is never particularly pleasant.
# This is retriggered whenever any change is detected to the requirements.txt
# or the Lambda function itself.
resource "null_resource" "lambda_package" {
  triggers = {
    requirements = filemd5("${path.module}/files/lambda/requirements.txt")
    lambda_code  = filemd5("${path.module}/files/lambda/lambda_function.py")
  }

  provisioner "local-exec" {
    command = "python -c \"import os; os.makedirs('${path.module}/files/lambda_package', exist_ok=True); os.makedirs('${path.module}/files/zip', exist_ok=True)\""
  }

  provisioner "local-exec" {
    command = "python -m pip install -r ${path.module}/files/lambda/requirements.txt -t ${path.module}/files/lambda_package --upgrade"
  }

  provisioner "local-exec" {
    command = "python -c \"import shutil; shutil.copy('${path.module}/files/lambda/lambda_function.py', '${path.module}/files/lambda_package/')\""
  }

  # Cleanup on destroy
  provisioner "local-exec" {
    when    = destroy
    command = "python -c \"import shutil, os; [shutil.rmtree(p, ignore_errors=True) for p in ['${path.module}/files/lambda_package', '${path.module}/files/zip']]\""
  }
}

# Create Lambda deployment package
resource "archive_file" "lambda_zip" {
  depends_on = [null_resource.lambda_package]
  
  type        = "zip"
  output_path = "${path.module}/files/zip/dns_test.zip"
  source_dir  = "${path.module}/files/lambda_package"

  # We want to recreate the deployment package on any update to our dependency compilation
  lifecycle {
    replace_triggered_by = [ null_resource.lambda_package ]
  }
}
