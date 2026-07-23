locals {

  method_response = {
    "method.response.header.Access-Control-Allow-Origin"   = "true"
    "method.response.header.Access-Control-Allow-Headers"  = "true"
    "method.response.header.Access-Control-Allow-Methods"  = "true"
    "method.response.header.Access-Control-Expose-Headers" = "true"
    "method.response.header.Access-Control-Max-Age"        = "true"
  }
  method_response_options = {
    "method.response.header.Access-Control-Allow-Origin"  = "true"
    "method.response.header.Access-Control-Allow-Headers" = "true"
    "method.response.header.Access-Control-Allow-Methods" = "true"
  }
  integration_response = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,OPTIONS,PATCH,POST,PUT'"
  }
}
