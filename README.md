# Jane Doe - Terraform, EC2, TicTacToe report, AWS Elastic Beanstalk

- Course: *Cloud programming*
- Group:
- Date:

## Environment architecture

The backend application code as a zip file is uploded to the S3 bucket. After that, Elastic Beanstalk environment for backend is configured, specifying the application name, solution stack, version label, VPC ID, subnets... For this part, I followed instructions that described how to set up an Elastic Beanstalk environment manually through the AWS dashboard. Once the backend part is up and running, I modify the backend address in the frontend source code to point to the deployed backend. Then, I deploy the frontend in a similar way by uploading the frontend code as a zip file to the S3 bucket. Also, I create a separate application version and environment for the frontend. 


## Preview

Screenshots of configured AWS services. Screenshots of your application running.

![Sample image](img/sample-image.png)

## Reflections

- What did you learn?
- What obstacles did you overcome?
- What did you help most in overcoming obstacles?
- Was that something that surprised you?
