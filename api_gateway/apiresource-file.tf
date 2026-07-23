#Resource Creation Parent
resource "aws_api_gateway_resource" "file_resource" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  parent_id   = aws_api_gateway_rest_api.fm_api.root_resource_id
  path_part   = "filesvc"
}

#Child
resource "aws_api_gateway_resource" "file_proxy" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  parent_id   = aws_api_gateway_resource.file_resource.id
  path_part   = "{proxy+}"
}

#-----------------------------------------------
#DELETE
#-----------------------------------------------

#Method Request Creation
resource "aws_api_gateway_method" "file_delete_method" {
  rest_api_id   = aws_api_gateway_rest_api.fm_api.id
  resource_id   = aws_api_gateway_resource.file_proxy.id
  http_method   = "DELETE"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.OPA_Authorizer.id
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

#Integration request creation
resource "aws_api_gateway_integration" "file_delete_integration" {
  rest_api_id             = aws_api_gateway_rest_api.fm_api.id
  resource_id             = aws_api_gateway_resource.file_proxy.id
  http_method             = aws_api_gateway_method.file_delete_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_integration.invoke_arn
  cache_key_parameters    = ["method.request.path.proxy"]
}

#Method Response creation
resource "aws_api_gateway_method_response" "file_delete_method_response" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  resource_id = aws_api_gateway_resource.file_proxy.id
  http_method = aws_api_gateway_method.file_delete_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "true"
  }
}

#-----------------------------------------------
#GET
#-----------------------------------------------

#Method Request Creation
resource "aws_api_gateway_method" "file_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.fm_api.id
  resource_id   = aws_api_gateway_resource.file_proxy.id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.OPA_Authorizer.id
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

#Integration request creation
resource "aws_api_gateway_integration" "file_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.fm_api.id
  resource_id             = aws_api_gateway_resource.file_proxy.id
  http_method             = aws_api_gateway_method.file_get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_integration.invoke_arn
  cache_key_parameters    = ["method.request.path.proxy"]
}

#Method Response creation
resource "aws_api_gateway_method_response" "file_get_method_response" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  resource_id = aws_api_gateway_resource.file_proxy.id
  http_method = aws_api_gateway_method.file_get_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "true"
  }
}


#-----------------------------------------------
#PATCH
#-----------------------------------------------

#Method Request Creation
resource "aws_api_gateway_method" "file_patch_method" {
  rest_api_id   = aws_api_gateway_rest_api.fm_api.id
  resource_id   = aws_api_gateway_resource.file_proxy.id
  http_method   = "PATCH"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.OPA_Authorizer.id
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

#Integration request creation
resource "aws_api_gateway_integration" "file_patch_integration" {
  rest_api_id             = aws_api_gateway_rest_api.fm_api.id
  resource_id             = aws_api_gateway_resource.file_proxy.id
  http_method             = aws_api_gateway_method.file_patch_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_integration.invoke_arn
  cache_key_parameters    = ["method.request.path.proxy"]
}

#Method Response creation
resource "aws_api_gateway_method_response" "file_patch_method_response" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  resource_id = aws_api_gateway_resource.file_proxy.id
  http_method = aws_api_gateway_method.file_patch_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = local.method_response
}


#-----------------------------------------------
#POST
#-----------------------------------------------

#Method Request Creation
resource "aws_api_gateway_method" "file_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.fm_api.id
  resource_id   = aws_api_gateway_resource.file_proxy.id
  http_method   = "POST"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.OPA_Authorizer.id
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

#Integration request creation
resource "aws_api_gateway_integration" "file_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.fm_api.id
  resource_id             = aws_api_gateway_resource.file_proxy.id
  http_method             = aws_api_gateway_method.file_post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_integration.invoke_arn
  cache_key_parameters    = ["method.request.path.proxy"]
}

#Method Response creation
resource "aws_api_gateway_method_response" "file_post_method_response" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  resource_id = aws_api_gateway_resource.file_proxy.id
  http_method = aws_api_gateway_method.file_post_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "true"
  }
}


#-----------------------------------------------
#PUT
#-----------------------------------------------

#Method Request Creation
resource "aws_api_gateway_method" "file_put_method" {
  rest_api_id   = aws_api_gateway_rest_api.fm_api.id
  resource_id   = aws_api_gateway_resource.file_proxy.id
  http_method   = "PUT"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.OPA_Authorizer.id
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

#Integration request creation
resource "aws_api_gateway_integration" "file_put_integration" {
  rest_api_id             = aws_api_gateway_rest_api.fm_api.id
  resource_id             = aws_api_gateway_resource.file_proxy.id
  http_method             = aws_api_gateway_method.file_put_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_integration.invoke_arn
  cache_key_parameters    = ["method.request.path.proxy"]
}

#Method Response creation
resource "aws_api_gateway_method_response" "file_put_method_response" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  resource_id = aws_api_gateway_resource.file_proxy.id
  http_method = aws_api_gateway_method.file_put_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "true"
  }
}


#-----------------------------------------------
#OPTIONS
#-----------------------------------------------

#Method Request Creation
resource "aws_api_gateway_method" "file_options_method" {
  rest_api_id   = aws_api_gateway_rest_api.fm_api.id
  resource_id   = aws_api_gateway_resource.file_proxy.id
  http_method   = "OPTIONS"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

#Integration request creation
resource "aws_api_gateway_integration" "file_options_integration" {
  rest_api_id          = aws_api_gateway_rest_api.fm_api.id
  resource_id          = aws_api_gateway_resource.file_proxy.id
  http_method          = aws_api_gateway_method.file_options_method.http_method
  type                 = "MOCK"
  cache_key_parameters = ["method.request.path.proxy"]
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
  }
}

#Method Response creation
resource "aws_api_gateway_method_response" "file_options_method_response" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  resource_id = aws_api_gateway_resource.file_proxy.id
  http_method = aws_api_gateway_method.file_options_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = local.method_response_options
}

resource "aws_api_gateway_integration_response" "file_options_integration_response" {
  rest_api_id         = aws_api_gateway_rest_api.fm_api.id
  resource_id         = aws_api_gateway_resource.file_proxy.id
  http_method         = aws_api_gateway_method.file_options_method.http_method
  status_code         = aws_api_gateway_method_response.file_options_method_response.status_code
  response_parameters = local.integration_response
  response_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
  }
  depends_on = [
    aws_api_gateway_integration.file_options_integration
  ]
}

#-----------------------------------------------
#v1
#-----------------------------------------------

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  parent_id   = aws_api_gateway_resource.file_resource.id
  path_part   = "v1"
}

resource "aws_api_gateway_resource" "readyfix" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "readyfix"
}

resource "aws_api_gateway_resource" "documents" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  parent_id   = aws_api_gateway_resource.readyfix.id
  path_part   = "documents"
}

resource "aws_api_gateway_resource" "documentId1" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  parent_id   = aws_api_gateway_resource.documents.id
  path_part   = "{documentId+}"
}

resource "aws_api_gateway_resource" "homeScreenDocuments" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  parent_id   = aws_api_gateway_resource.readyfix.id
  path_part   = "homeScreenDocuments"
}

resource "aws_api_gateway_resource" "documentId" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  parent_id   = aws_api_gateway_resource.homeScreenDocuments.id
  path_part   = "{documentId+}"
}

#------------------------
#v1 GET for documents
#------------------------
#Method Request Creation
resource "aws_api_gateway_method" "file_get_method_v1_document" {
  rest_api_id   = aws_api_gateway_rest_api.fm_api.id
  resource_id   = aws_api_gateway_resource.documentId1.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.documentId1" = true
  }
}

#Integration request creation
resource "aws_api_gateway_integration" "file_get_integration_v1_document" {
  rest_api_id             = aws_api_gateway_rest_api.fm_api.id
  resource_id             = aws_api_gateway_resource.documentId1.id
  http_method             = aws_api_gateway_method.file_get_method_v1_document.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_integration.invoke_arn
  cache_key_parameters    = ["method.request.path.documentId1"]
}

#Method Response creation
resource "aws_api_gateway_method_response" "file_get_method_v1_document_response" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  resource_id = aws_api_gateway_resource.documentId1.id
  http_method = aws_api_gateway_method.file_get_method_v1_document.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "true"
  }
}

#------------------------
#v1 GET for homeScreenDocuments
#------------------------
#Method Request Creation
resource "aws_api_gateway_method" "file_get_method_v1" {
  rest_api_id   = aws_api_gateway_rest_api.fm_api.id
  resource_id   = aws_api_gateway_resource.documentId.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.documentId" = true
  }
}

#Integration request creation
resource "aws_api_gateway_integration" "file_get_integration_v1" {
  rest_api_id             = aws_api_gateway_rest_api.fm_api.id
  resource_id             = aws_api_gateway_resource.documentId.id
  http_method             = aws_api_gateway_method.file_get_method_v1.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_integration.invoke_arn
  cache_key_parameters    = ["method.request.path.documentId"]
}

#Method Response creation
resource "aws_api_gateway_method_response" "file_get_method_v1_response" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  resource_id = aws_api_gateway_resource.documentId.id
  http_method = aws_api_gateway_method.file_get_method_v1.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "true"
  }
}

#------------------------
#v1 OPTION for documents
#------------------------

#Method Request Creation
resource "aws_api_gateway_method" "file_options_method_v1_document" {
  rest_api_id   = aws_api_gateway_rest_api.fm_api.id
  resource_id   = aws_api_gateway_resource.documentId1.id
  http_method   = "OPTIONS"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.documentId1" = true
  }
}

#Integration request creation
resource "aws_api_gateway_integration" "file_options_integration_v1_document" {
  rest_api_id          = aws_api_gateway_rest_api.fm_api.id
  resource_id          = aws_api_gateway_resource.documentId1.id
  http_method          = aws_api_gateway_method.file_options_method_v1_document.http_method
  type                 = "MOCK"
  cache_key_parameters = ["method.request.path.documentId1"]
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
  }
}

#Method Response creation
resource "aws_api_gateway_method_response" "file_options_method_response_v1_document" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  resource_id = aws_api_gateway_resource.documentId1.id
  http_method = aws_api_gateway_method.file_options_method_v1_document.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = local.method_response_options
}

resource "aws_api_gateway_integration_response" "file_options_integration_response_v1_document" {
  rest_api_id         = aws_api_gateway_rest_api.fm_api.id
  resource_id         = aws_api_gateway_resource.documentId1.id
  http_method         = aws_api_gateway_method.file_options_method_v1_document.http_method
  status_code         = aws_api_gateway_method_response.file_options_method_response_v1_document.status_code
  response_parameters = local.integration_response
  response_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
  }
  depends_on = [
    aws_api_gateway_integration.file_options_integration_v1_document
  ]
}

#------------------------
#v1 OPTION for homeScreenDocuments
#------------------------

#Method Request Creation
resource "aws_api_gateway_method" "file_options_method_v1" {
  rest_api_id   = aws_api_gateway_rest_api.fm_api.id
  resource_id   = aws_api_gateway_resource.documentId.id
  http_method   = "OPTIONS"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.documentId" = true
  }
}

#Integration request creation
resource "aws_api_gateway_integration" "file_options_integration_v1" {
  rest_api_id          = aws_api_gateway_rest_api.fm_api.id
  resource_id          = aws_api_gateway_resource.documentId.id
  http_method          = aws_api_gateway_method.file_options_method_v1.http_method
  type                 = "MOCK"
  cache_key_parameters = ["method.request.path.documentId"]
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
  }
}

#Method Response creation
resource "aws_api_gateway_method_response" "file_options_method_response_v1" {
  rest_api_id = aws_api_gateway_rest_api.fm_api.id
  resource_id = aws_api_gateway_resource.documentId.id
  http_method = aws_api_gateway_method.file_options_method_v1.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = local.method_response_options
}

resource "aws_api_gateway_integration_response" "file_options_integration_response_v1" {
  rest_api_id         = aws_api_gateway_rest_api.fm_api.id
  resource_id         = aws_api_gateway_resource.documentId.id
  http_method         = aws_api_gateway_method.file_options_method_v1.http_method
  status_code         = aws_api_gateway_method_response.file_options_method_response_v1.status_code
  response_parameters = local.integration_response
  response_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
  }
  depends_on = [
    aws_api_gateway_integration.file_options_integration_v1
  ]
}