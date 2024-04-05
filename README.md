# Terraform Notes

- Terraform authentication SPN `sp-terraform-deploy` ID/secret are loaded into this repo's secrets
- [example workflow](https://github.com/Azure-Samples/terraform-github-actions/blob/main/.github/workflows/tf-plan-apply.yml)
- [setup-terraform task](https://github.com/hashicorp/setup-terraform)

# Azure Notes

- Only generation 2 images are available on the marketplace, so we have to use Gen2 compatible VMs
- VM sizes: https://learn.microsoft.com/en-us/azure/virtual-machines/generation-2
- Sizes available by region: https://azure.microsoft.com/en-us/explore/global-infrastructure/products-by-region/?cdn=disable
