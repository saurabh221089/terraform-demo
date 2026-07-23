provider "aws" {
  region = "us-west-2"
}

resource "aws_lambda_function" "hello_world" {
  function_name = "hello_world"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = filebase64sha256("lambda_function.zip")
  filename         = "lambda_function.zip"

}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Sid    = "",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_api_gateway_rest_api" "hello_world_api" {
  name        = "hello_world_api"
  description = "API Gateway for Hello World Lambda function"
}

resource "aws_api_gateway_resource" "hello_world_resource" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  parent_id   = aws_api_gateway_rest_api.hello_world_api.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "hello_world_method" {
  rest_api_id   = aws_api_gateway_rest_api.hello_world_api.id
  resource_id   = aws_api_gateway_resource.hello_world_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hello_world_integration" {
  rest_api_id             = aws_api_gateway_rest_api.hello_world_api.id
  resource_id             = aws_api_gateway_resource.hello_world_resource.id
  http_method             = aws_api_gateway_method.hello_world_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello_world.invoke_arn
}

resource "aws_api_gateway_resource" "hello_world_resource2" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  parent_id   = aws_api_gateway_rest_api.hello_world_api.root_resource_id
  path_part   = "hello2"
}

resource "aws_api_gateway_method" "hello_world_method2" {
  rest_api_id   = aws_api_gateway_rest_api.hello_world_api.id
  resource_id   = aws_api_gateway_resource.hello_world_resource2.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hello_world_integration2" {
  rest_api_id             = aws_api_gateway_rest_api.hello_world_api.id
  resource_id             = aws_api_gateway_resource.hello_world_resource2.id
  http_method             = aws_api_gateway_method.hello_world_method2.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello_world.invoke_arn
}

resource "aws_api_gateway_deployment" "hello_world_deployment" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.hello_world_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.hello_world_integration,
    aws_api_gateway_integration.hello_world_integration2,
    aws_api_gateway_integration.user_get_integration_v1,
    aws_api_gateway_integration.user_options_integration_v1
  ]
}

resource "aws_api_gateway_stage" "dev_stage" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  stage_name  = "dev"
  deployment_id = aws_api_gateway_deployment.hello_world_deployment.id

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
    format          = "$context.requestId $context.identity.sourceIp $context.identity.caller $context.identity.user $context.requestTime $context.httpMethod $context.resourcePath $context.status $context.protocol $context.responseLength $context.path $context.integrationLatency"
  }

}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  stage_name  = aws_api_gateway_stage.dev_stage.stage_name
  method_path = "*/*"
  settings {
    metrics_enabled        = true
    logging_level          = "INFO"
    data_trace_enabled     = true
    throttling_burst_limit = 500
    throttling_rate_limit  = 500
  }
}

resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name              = "/aws/apigateway/hello_world_api"
  retention_in_days = 14
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hello_world_api.execution_arn}/*/*"
}

# Allow API Gateway to push logs to CloudWatch
resource "aws_api_gateway_account" "api_gw_account" {
  cloudwatch_role_arn = aws_iam_role.api_logs_role.arn
}

resource "aws_iam_role" "api_logs_role" {
  name = "api-gateway-logs-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "role_policy_association" {
  role       = aws_iam_role.api_logs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

#Resource Creation Parent
resource "aws_api_gateway_resource" "user_resource" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  parent_id   = aws_api_gateway_rest_api.hello_world_api.root_resource_id
  path_part   = "usersvc"
}

#-----------------------------------------------
#v1
#-----------------------------------------------

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  parent_id   = aws_api_gateway_resource.user_resource.id
  path_part   = "v1"
}

resource "aws_api_gateway_resource" "loggedInUser" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "loggedInUser"
}

resource "aws_api_gateway_resource" "generateQrCode" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  parent_id   = aws_api_gateway_resource.loggedInUser.id
  path_part   = "{generateQrCode+}"
}

#------------------------
#v1 GET
#------------------------
#Method Request Creation
resource "aws_api_gateway_method" "user_get_method_v1" {
  rest_api_id   = aws_api_gateway_rest_api.hello_world_api.id
  resource_id   = aws_api_gateway_resource.generateQrCode.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.generateQrCode" = true
  }
}

#Integration request creation
resource "aws_api_gateway_integration" "user_get_integration_v1" {
  rest_api_id             = aws_api_gateway_rest_api.hello_world_api.id
  resource_id             = aws_api_gateway_resource.generateQrCode.id
  http_method             = aws_api_gateway_method.user_get_method_v1.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello_world.invoke_arn
  cache_key_parameters    = ["method.request.path.generateQrCode"]
}

#Method Response creation
resource "aws_api_gateway_method_response" "user_get_method_v1_response" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  resource_id = aws_api_gateway_resource.generateQrCode.id
  http_method = aws_api_gateway_method.user_get_method_v1.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "true"
  }
}

#------------------------
#v1 OPTION
#------------------------

#Method Request Creation
resource "aws_api_gateway_method" "user_options_method_v1" {
  rest_api_id   = aws_api_gateway_rest_api.hello_world_api.id
  resource_id   = aws_api_gateway_resource.generateQrCode.id
  http_method   = "OPTIONS"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.generateQrCode" = true
  }
}

#Integration request creation
resource "aws_api_gateway_integration" "user_options_integration_v1" {
  rest_api_id          = aws_api_gateway_rest_api.hello_world_api.id
  resource_id          = aws_api_gateway_resource.generateQrCode.id
  http_method          = aws_api_gateway_method.user_options_method_v1.http_method
  type                 = "MOCK"
  cache_key_parameters = ["method.request.path.generateQrCode"]
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
  }
}

#Method Response creation
resource "aws_api_gateway_method_response" "user_options_method_response_v1" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  resource_id = aws_api_gateway_resource.generateQrCode.id
  http_method = aws_api_gateway_method.user_options_method_v1.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = local.method_response_options
}

resource "aws_api_gateway_integration_response" "user_options_integration_response_v1" {
  rest_api_id         = aws_api_gateway_rest_api.hello_world_api.id
  resource_id         = aws_api_gateway_resource.generateQrCode.id
  http_method         = aws_api_gateway_method.user_options_method_v1.http_method
  status_code         = aws_api_gateway_method_response.user_options_method_response_v1.status_code
  response_parameters = local.integration_response
  response_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
  }
  depends_on = [
    aws_api_gateway_integration.user_options_integration_v1
  ]
}

## Start of Output block

output "Endpoint_URL" {
  value = "${aws_api_gateway_stage.dev_stage.invoke_url}/hello"
}

output "deployment_id" {
  value = aws_api_gateway_stage.dev_stage.deployment_id
}