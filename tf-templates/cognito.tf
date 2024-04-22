resource "aws_cognito_user_pool" "main" {
  name = "my_user_pool"
  username_attributes = ["email"]

  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = true

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "name"
    required            = true
    mutable             = true

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "phone_number"
    required            = true
    mutable             = true

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  auto_verified_attributes   = ["email"]
  email_verification_message = "Click the link below to verify your email address: {####}"
  email_verification_subject = "Verify Your Email"
}

resource "aws_cognito_user_pool_client" "client" {
  name                     = "app_client"
  user_pool_id             = aws_cognito_user_pool.main.id
  generate_secret          = false
  explicit_auth_flows      = ["ADMIN_NO_SRP_AUTH"]
}

resource "aws_cognito_identity_pool" "main_identity_pool" {
  identity_pool_name               = "my_identity_pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.client.id
    provider_name           = aws_cognito_user_pool.main.endpoint
    server_side_token_check = false
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "main_identity_pool_role_attachment" {
  identity_pool_id = aws_cognito_identity_pool.main_identity_pool.id
  roles = {
    "authenticated" = aws_iam_role.authenticated_role.arn
  }
}
