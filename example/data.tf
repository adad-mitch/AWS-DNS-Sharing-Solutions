data "aws_caller_identity" "hub" {
  provider = aws.hub
}

data "aws_caller_identity" "spoke" {
  provider = aws.spoke
}
