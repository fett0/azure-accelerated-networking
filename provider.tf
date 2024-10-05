terraform {
  required_version = ">=1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.93.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {

  }
}
