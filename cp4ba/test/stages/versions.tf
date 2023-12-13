terraform {
  required_version = ">= 0.13"
  required_providers {
    ibm = {
      source  = "ibm-cloud/ibm"
      version = "1.60.1"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}