# Jane Doe - Terraform, EC2, TicTacToe report, AWS Elastic Beanstalk, Fargate

- Course: *Cloud programming*
- Group:
- Date:

## Environment architecture

### Elastic Beanstalk

The backend application code as a zip file is uploded to the S3 bucket. After that, Elastic Beanstalk environment for backend is configured, specifying the application name, solution stack, version label, VPC ID, subnets... For this part, I followed instructions that described how to set up an Elastic Beanstalk environment manually through the AWS dashboard. Once the backend part is up and running, the frontend is configured in the same way. Ip address of the deployed backend is passed to the frontend as an envirnoment variable (PUBLIC_IP).

### Fargate

This part, I started by manually deploying Docker images to Amazon ECR (Elastic Container Registry) so I can reference them later in a terraform configuration. After that, in the terraform file I to set up two distinct components of the application using AWS ECS Fargate. I defined frontend and backend tasks, each equipped with templates specifying how to set up everything within Fargate.

## Preview

Screenshots of configured AWS services. Screenshots of your application running.

![Sample image](img/sample-image.png)

## Reflections
In this lab, I learned how to deploy applications using AWS services: Elastic Beanstalk and Fargate. The PDF instructions provided were incredibly helpful in guiding me through the process of setting up the infrastructure using Terraform for both Elastic Beanstalk and Fargate because deploying sample applications manually through the AWS dashboard gave me a good understanding of the infrastructure before transitioning to Terraform automation. One significant challenge I faced was figuring out how to pass environment variables to the Dockerfile. At the end I created a separate bash script that is run from Dockerfile, and there I didn't have problems accessing env variables. Retrieving the IP address of the deployed backend in EB was quite easy, but with Fargate at first I couldn't find a solution for it. At the end, the most helpful were comments on this GitHub thread (https://github.com/hashicorp/terraform-provider-aws/issues/3444). I was surprised by how much money I used from my account for this lab as I worked on the lab for a few days, and sometimes forgot to destroy all resources after testing. 

