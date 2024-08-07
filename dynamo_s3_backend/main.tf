resource "aws_s3_bucket" "tfstate_storage_bucket" {
    bucket = "terraform-demo-tfstate-files"
    tags = {
        Name        = "terraform-demo-tfstate-files"
   }
}

resource "aws_s3_account_public_access_block" "tfstate_storage_bucket_access" {
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tfstate_dynamodb" {
    name = "terraform-tfstate-lock"
    hash_key = "LockID"
    read_capacity = 5
    write_capacity = 5
    attribute {
      name = "LockID"
      type = "S"
    }
}