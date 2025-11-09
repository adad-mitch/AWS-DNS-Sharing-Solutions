import json
import logging
import os
import dns.resolver

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    # Get DNS query target from environment variables
    dns_domain = os.environ.get('DNS_DOMAIN', 'example.com')
    dns_subdomain = os.environ.get('DNS_SUBDOMAIN', 'test')
    query_target = f"{dns_subdomain}.{dns_domain}"
    
    logger.info(f"Querying TXT record for: {query_target}")
    
    try:
        # Query TXT record using dnspython
        resolver = dns.resolver.Resolver()
        answers = resolver.resolve(query_target, 'TXT')
        
        txt_records = []
        for rdata in answers:
            # TXT records are returned as quoted strings, so we need to decode them
            txt_value = str(rdata).strip('"')
            txt_records.append(txt_value)
            logger.info(f"Found TXT record: {txt_value}")
        
        logger.info(f"DNS TXT query successful for {query_target}: {txt_records}")
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'DNS TXT query successful',
                'query_target': query_target,
                'txt_records': txt_records,
                'record_count': len(txt_records)
            })
        }
    except dns.resolver.NXDOMAIN:
        logger.error(f"Domain {query_target} does not exist")
        return {
            'statusCode': 404,
            'body': json.dumps({
                'message': 'Domain not found',
                'query_target': query_target,
                'error': 'NXDOMAIN'
            })
        }
    except dns.resolver.NoAnswer:
        logger.error(f"No TXT records found for {query_target}")
        return {
            'statusCode': 404,
            'body': json.dumps({
                'message': 'No TXT records found',
                'query_target': query_target,
                'error': 'No TXT records'
            })
        }
    except Exception as e:
        logger.error(f"DNS query failed for {query_target}: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'DNS query failed',
                'query_target': query_target,
                'error': str(e)
            })
        }
