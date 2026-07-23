provider "aws" {
  region = "us-west-2"
}

resource "aws_lambda_function" "my_function" {
  function_name = "my_function"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = "path/to/your/function.zip"
  source_code_hash = filebase64sha256("path/to/your/function.zip")

  layers = [
    aws_lambda_layer_version.my_layer.arn
  ]
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

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

resource "aws_iam_role_policy_attachment" "lambda_exec_role_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# Create Custom lambda layer in order to provide that external module.
resource "aws_lambda_layer_version" "my_layer" {
  layer_name = "my_layer"
  description = "My Lambda Layer"
  compatible_runtimes = ["python3.8"]

  filename   = "path/to/your/layer.zip"
  source_code_hash = filebase64sha256("path/to/your/layer.zip")
}