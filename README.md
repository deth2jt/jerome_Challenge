# comcast challenge

> see below for info on project

## General Info

This project makes use of terraform to effect changes across aws resources along with setting github secrets values to aid a ci/cds workflow that calls codepeloy. First terraform is used to setup aws allthethings for our infrastructure. Next once a push is done to main git branch it triggers the workflow.
The workflow has test job that will check if action will result in success if so it does a deploy poush to s3 followed by a deploy to ec2 instance [for stake of not going overboard I didnt make green blue deploy with load balancer]

>AWS sache to include:
>iam
>s3
>vpc
>secrets manager
>ec2
>codedeploy

>Github secrets:
>s3 bucket name (concocted through terraform)
>
>AWS_ACCESS_KEY_ID (taken from .aws/credentials)
>
>AWS_SECRET_ACCESS_KEY (taken from .aws/credentials)

## _Terraform commands _

terraform output [also terraform output public_key to confirm key in case of connection issues]

(make use of below to have project entities setup)

terraform fmt 

terraform init 

terraform plan

terraform apply (below is a snippet)
```
[userone@test com_exam]$ terraform apply
module.codedeploy.aws_codedeploy_app.foo_app: Refreshing state... [id=7d8345ec-4f7d-4843-a2ac-2c0d1d4d2cc1:aws-codedeploy-1]
module.s3.random_id.my-random-id: Refreshing state... [id=RHQ]
module.kms.aws_kms_key.my-kms-key: Refreshing state... [id=ab3988a4-e102-4149-a210-71d5ab21d73d]
module.github.github_actions_secret.github-action-terraform-access-key: Refreshing state... [id=jerome_Challenge:AWS_SECRET_ACCESS_KEY]
module.github.github_actions_secret.github-action-terraform-access-id: Refreshing state... [id=jerome_Challenge:AWS_ACCESS_KEY_ID]
module.vpc.aws_vpc.main: Refreshing state... [id=vpc-02584d43730c64419]
module.iam.aws_iam_role.code_deploy_inst_role: Refreshing state... [id=CodeDeployInstanceRole]
module.iam.aws_iam_role.code_deploy_service_role: Refreshing state... [id=CodeDeployServiceRole]
module.ec2.aws_ebs_volume.my-foo-ebs: Refreshing state... [id=vol-082864d32db934289]
module.kms.aws_kms_alias.smc-kms-alias: Refreshing state... [id=alias/terraform_final_foo_encryption_key]
module.sms.aws_secretsmanager_secret.secret: Refreshing state... [id=arn:aws:secretsmanager:us-east-1:716001185887:secret:public_foo_new_key-secret-3Y388d]
module.s3.aws_s3_bucket.my-code-deploy-bucket: Refreshing state... [id=aws-codedeploy-deployments-17524]
module.sms.aws_secretsmanager_secret_version.secret: Refreshing state... [id=arn:aws:secretsmanager:us-east-1:716001185887:secret:public_foo_new_key-secret-3Y388d|073CE1C8-620D-4F1F-8532-F560C89A691B]
module.iam.aws_iam_instance_profile.foo_profile: Refreshing state... [id=foo_profile_codedeploy]
module.iam.aws_iam_role_policy_attachment.test-attach[1]: Refreshing state... [id=CodeDeployInstanceRole-20210315161744199000000002]
module.iam.aws_iam_role_policy_attachment.test-attach[0]: Refreshing state... [id=CodeDeployInstanceRole-20210315161744178500000001]
module.iam.aws_iam_role_policy_attachment.test-attach2[0]: Refreshing state... [id=CodeDeployServiceRole-20210315161744218100000003]
module.codedeploy.aws_codedeploy_deployment_group.foo: Refreshing state... [id=4be6285d-a10d-4c03-9dac-223f87e6d323]
module.ec2.aws_key_pair.myfoo-key: Refreshing state... [id=my_foo_terraform_key]
module.github.github_actions_secret.github-action-s3-buck-name: Refreshing state... [id=jerome_Challenge:bucket_git_name]
module.vpc.aws_internet_gateway.gw: Refreshing state... [id=igw-0501acc1c1b452652]
```

A noteworthy file; is the userdata used for the init conf of our instance:
```
[userone@test com_exam]$ ll ec2/userdata.tpl 
-rw-rw-r--. 1 userone userone 2951 Mar 15 14:29 ec2/userdata.tpl
```
It does a number of things that include: setting apache; codedeploy agent; creating ssl keys and cert and doing initial apache conf.


## _Github necessities_
Done so that we can make use of worflows to have a future code changes push through aws codedeploy (uploaded to s3 as well).
Once is push is done on main it will cause a workflow as seen in below screenshot to occur.
It uses files in html directory for deploy. 
![image](https://user-images.githubusercontent.com/458820/111347400-8d8b7080-8655-11eb-92b7-d462016f0b23.png)


NB: atop of each module maybe a link to website that found useful will working out kinks 
Also python code can be found as shown below:
```
[userone@test com_exam]$ ll python_code/
total 4
-rw-rw-r--. 1 userone userone 1249 Mar 15 18:23 foo.py
```


The idea for how to do this came from two prevoius projects:

https://github.com/deth2jt/-Nodejs_Gitaction_S3
where github action was used to a codedeploy of nodejs app

https://gitlab.com/deth2jt/terrafom-codedeploy
this repo show the infrastructure resources that was needed to accomplish codedeploy 

Through this project I was able to combine both school of thoughts 
