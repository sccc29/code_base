provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::944613854055:role/tf-worker"
  }
  region = "us-east-1"
}

variables {
  bucket_name = "my-bucket-632746328242"
  region      = "us-east-1"
  kms_enabled = true
  kms_key_id  = ""
}

run "encryption_enabled" {
  command = apply

  module {
    source = "../../modules/s3"

  }

  assert {
    condition     = aws_s3_bucket.main.server_side_encryption_configuration[0].rule[0].apply_server_side_encryption_by_default[0].sse_algorithm == "AES256" || aws_s3_bucket.main.server_side_encryption_configuration[0].rule[0].apply_server_side_encryption_by_default[0].sse_algorithm == "aws:kms"
    error_message = "S3 bucket encryption is not enabled."
  }
}

run "bucket_private" {
  command = plan

  module {
    source = "../../modules/s3"

  }

  assert {
    condition     = aws_s3_bucket_public_access_block.main.block_public_acls  == true
    error_message = "S3 bucket is not private."
  }

    assert {
        condition     = aws_s3_bucket_public_access_block.main.block_public_policy == true
        error_message = "S3 bucket is not private."
    }

    assert {
        condition     = aws_s3_bucket_public_access_block.main.ignore_public_acls == true
        error_message = "S3 bucket is not private."
    }

    assert {
        condition     = aws_s3_bucket_public_access_block.main.restrict_public_buckets == true
        error_message = "S3 bucket is not private."
    }
}


run "ownership_control" {
  command = plan

  module {
    source = "../../modules/s3"
  }

  assert {
    condition     = aws_s3_bucket_ownership_controls.main.rule[0].object_ownership == "BucketOwnerPreferred"
    error_message = "S3 bucket ownership is not set correctly."
  }
}
