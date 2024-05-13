provider "aws" {
  region = "us-east-1"
}

data "aws_iam_role" "existing_role" {
  name = "LabRole"
}


resource "aws_ecs_cluster" "frontend" {
  name = "frontend_cluster"
  // Add other configurations as needed
}

resource "aws_ecs_service" "tic_tac_toe_service_frontend" {
  name                               = "app_TicTacToe_Service_frontend"
  cluster                            = aws_ecs_cluster.frontend.id
  task_definition                    = aws_ecs_task_definition.frontend.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50  # Example minimum healthy percent
  deployment_maximum_percent         = 200  # Example maximum percent
  launch_type                        = "FARGATE"



  network_configuration {
    security_groups  = [aws_security_group.ecs_container_instance.id]
    subnets          = ["subnet-0f0611332cfd73a53", "subnet-0bee8e09ac0089efc"]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}



## Creates ECS Task Definition
resource "aws_ecs_task_definition" "frontend" {
  family                   = "app_ECS_TaskDefinition_frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::339713018133:role/LabRole"
  task_role_arn            = "arn:aws:iam::339713018133:role/LabRole"
  cpu                      = 512
  memory                   = 1024
  
  container_definitions = jsonencode([
    {
      name           = "frontend"
      image          = "339713018133.dkr.ecr.us-east-1.amazonaws.com/ttt_frontend:v1"
      cpu            = 512
      memory         = 1024
      essential      = true
      portMappings   = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          "awslogs-group"         = aws_cloudwatch_log_group.log_frontend.name,
          "awslogs-region"        = "us-east-1",
          "awslogs-stream-prefix" = "app-log-stream-frontend"
        }
      }

      environment = [
        {
          name  = "PUBLIC_IP"
          value = data.aws_network_interface.eni-ip.association[0].public_ip
        }]
    }
  ])
}

resource "aws_cloudwatch_log_group" "log_frontend" {
  name              = "app-log-stream-frontend" // Replace with your desired name
  retention_in_days = 30 // Specify the retention period for the logs (optional)
}

## Security Group for ECS Task Container Instances (managed by Fargate)
resource "aws_security_group" "ecs_container_instance" {
  name        = "app_ECS_Task_SecurityGroup_frontend"
  description = "Security group for ECS task running on Fargate"
  vpc_id      = "vpc-01dca074ef1c3c80b"

  ingress {
    description     = "Allow ingress traffic on 3000 only"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app_ECS_Task_SecurityGroup_frontend"
  }

  
}


