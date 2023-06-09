# Create Azure AD Group in Active Directory for AKS Admins
resource "azuread_group" "aks_administrators" {
  display_name        = "${azurerm_resource_group.aks_rg.name}-administrators"
  description = "Azure AKS Kubernetes administrators for the ${azurerm_resource_group.aks_rg.name}-administrators cluster."
  security_enabled = true
   members = [
    azuread_user.k8s_user.object_id
    # more users 
   ]
}

# Create an Azure Active Directory user
resource "azuread_user" "k8s_user" {
  display_name = "aksdev2"
  password     = "MyStrongPassword@123"
  user_principal_name = "${azurerm_resource_group.aks_rg.name}-user@rajeshmgcoutlook.onmicrosoft.com"
}

/* resource "azuread_group_member" "admin_group_member" {
  group_object_id = azuread_group.aks_administrators.object_id
  member_object_id = azuread_user.k8s_user.object_id
} */



resource "azurerm_role_assignment" "k8-admins" {
  scope = azurerm_kubernetes_cluster.aks_cluster.id
  role_definition_id  = "/subscriptions/9d9fcbde-f936-44c8-aadf-33737c6f78a4/providers/Microsoft.Authorization/roleDefinitions/b1ff04bb-8a4e-4dc4-8eb5-8693973ce19b"
  principal_id = azuread_group.aks_administrators.id
}


#https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal
/* data "azuread_service_principal" "example" {
  display_name = "my-awesome-application"
} */