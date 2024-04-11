# BudgetWise – User Guide

## Prerequisites

The project requires Terraform CLI

## Steps

1. Naviagte to the terrform template folder
```
cd tf-templates
```

2. Replace the `access_key` and `secret_key` values in `provider.tf`.

3. Run the following terraform commands:
```
terraform init
```
```
terraform plan
```
```
terraform apply
```

This provisioning should take about 2-3 minutes.

4. In your terminal you would find the IP address (`instance_public_ip`) for the provisioned instance.

5. Open this IP address on your browser with the prefix: `http://`

6. You should be able to see the application running.

7. For clean-up, run:
```
terraform destroy
```
