provider "aws" {
  region = "eu-west-1"
}

data "aws_caller_identity" "iam" {}

#########################################
# IAM policy
#########################################
module "iam_policy" {
  source = "../modules/iam-policy"

  name        = "prod-${var.env_suffix}"
  path        = "/"
  description = "My prod policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

#####################################################################################
# Custom IAM assumable role
# Note: Anyone from IAM account can assume them.
#####################################################################################
module "iam_assumable_role_custom" {
  source = "../modules/iam-assumable-role"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.iam.account_id}:root",
  ]

  create_role = true

  role_name         = "prod-${var.env_suffix}"
  role_requires_mfa = true

  custom_role_policy_arns = [
    module.iam_policy.arn
  ]
}

###########
# IAM user
###########
module "iam_user" {
  source = "../modules/iam-user"

  name = "user-${var.env_suffix}"

  create_iam_user_login_profile = false
  create_iam_access_key         = false
}

################################################################################################
# IAM group where user is allowed to assume custom role in AWS account
# Note: IAM AWS account is default, so there is no need to specify it here.
################################################################################################
module "iam_group_with_assumable_roles_policy_production_custom" {
  source = "../modules/iam-group-with-assumable-roles-policy"

  name = "prod-${var.env_suffix}"

  assumable_roles = [module.iam_assumable_role_custom.iam_role_arn]

  group_users = [
    module.iam_user.iam_user_name,
  ]
}
