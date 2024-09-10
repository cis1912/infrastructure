# module "s3_bucket" {
#   source = "terraform-aws-modules/s3-bucket/aws"

#   bucket = "cis1912-test"
#   acl    = "private"

#   control_object_ownership = true
#   object_ownership         = "ObjectWriter"
# }

resource "aws_s3_bucket" "example" {
  bucket = "cis1912-test-bucket"

  tags = {
    Name        = "CIS 1912 Test Bucket"
    Environment = "Dev"
  }
}
