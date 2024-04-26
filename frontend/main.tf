provider "aws" {
  region = "us-east-1"
}

data "aws_iam_role" "existing_role" {
  name = "LabRole"
}

data "aws_iam_instance_profile" "existing_instance_profile" {
  name = "LabInstanceProfile"
}


resource "aws_elastic_beanstalk_application" "tf-tic-tac-toe-front" {
  name = "tic-tac-toe-app-front"
  description = "Tic tac toe app front"
  
}




resource "random_id" "bucket2" {
  byte_length = 8
}

resource "aws_s3_bucket" "beanstalk_bucket2" {
  bucket = "tf-eb-demo-${random_id.bucket2.hex}"
  acl    = "private"
}

resource "aws_s3_bucket_object" "app2_zip" {
  bucket = aws_s3_bucket.beanstalk_bucket2.id
  key    = "frontend.zip"
  source = "frontend.zip"
  acl    = "private"

  depends_on = [aws_s3_bucket.beanstalk_bucket2]
}
 
resource "aws_elastic_beanstalk_environment" "tf-tic-tac-toe-env2" {
  name                = "tic-tac-toe-env2"
  application = aws_elastic_beanstalk_application.tf-tic-tac-toe-front.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.3.1 running Docker" #64bit Amazon Linux 2023/4.3.0 running Docker" Docker running on 64bit Amazon Linux 2023/4.3.0
  version_label = aws_elastic_beanstalk_application_version.front.name
  tier = "WebServer"
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = data.aws_iam_instance_profile.existing_instance_profile.name
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCID"
    value = var.vpc_id

  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.subnet)
  }
  setting {
    namespace = "aws:ec2:instances"
    name = "InstanceTypes"
    value = "t2.micro"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "public"
  }

}

resource "aws_elastic_beanstalk_application_version" "front" {
  name = "frontend"
  application = aws_elastic_beanstalk_application.tf-tic-tac-toe-front.name
  bucket      = aws_s3_bucket.beanstalk_bucket2.id
  key         = aws_s3_bucket_object.app2_zip.key
}
output "url" {
  value = aws_elastic_beanstalk_environment.tf-tic-tac-toe-env2.endpoint_url
}


