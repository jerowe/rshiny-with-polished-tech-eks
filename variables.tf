# Grab this from the polished.tech Dashboard -> Apps
# Then make sure to add your user to the app!
variable "POLISHED_APP_NAME" {
  default = "my_first_shiny_app"
}

# Grab this from the polished.tech Dashboard -> Account -> Secret
variable "POLISHED_API_KEY" {
  default = "hK19h8glfnag7Idh4dNjR4LE6v4cHjCyka"
}

# FIREBASE CREDENTIALS!
variable "POLISHED_FIREBASE_API_KEY" {
  default = "AIzaSyCLTnBcFt8j76jzkbVLwTFJEOVem_bIWZA"
  //  default = ""
}

variable "POLISHED_FIREBASE_PROJECT_ID" {
  default = "polished-app-aws"
  //  default = ""
}

variable "POLISHED_FIREBASE_AUTH_DOMAIN" {
  default = "polished-app-aws.firebaseapp.com"
}
