# Define S3 bucket
#resource "aws_s3_bucket" "b" {
#  bucket = "wizz-kenny-exercise"
#  acl    = "public-read"
#}

data "aws_canonical_user_id" "current" {}

resource "aws_s3_bucket" "b" {
  bucket = "wiz-kenny-mongodb-backups"
}

resource "aws_s3_bucket_acl" "b" {
  bucket = aws_s3_bucket.b.id
  access_control_policy {
    grant {
      grantee {
        id   = data.aws_canonical_user_id.current.id
        type = "CanonicalUser"
      }
      permission = "READ"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "READ_ACP"
    }
    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/global/AllUsers"
      }
      permission = "READ_ACP"
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}
