terraform {
  cloud {
    organization = "VolTFE"
    workspaces {
      name = "tf-factory-repo"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "create_test_resources" {
  type    = bool
  default = true
}

module "storage_test" {
  source = "git::https://github.com/shahid6002/TFE.git//modules/storage_account?ref=feature/az-storage-module"

  resource_group_name  = "rg-storage-dev"
  location             = "eastus"

  # Generate a unique storage account name (3–24 chars, lowercase only)
  storage_account_name = "teststorage${substr(md5(timestamp()), 0, 6)}"

  tags = {
    environment = "dev"
  }

  count = var.create_test_resources ? 1 : 0
}
