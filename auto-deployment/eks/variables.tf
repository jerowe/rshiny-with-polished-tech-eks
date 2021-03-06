variable "region" {
  default = "us-east-1"
}

# Grab this from the polished.tech Dashboard -> Apps
# Then make sure to add your user to the app!
variable "POLISHED_APP_NAME" {
  default = "my_first_shiny_app"
}

# Grab this from the polished.tech Dashboard -> Account -> Secret
variable "POLISHED_API_KEY" {
  default = "XXXXXXXXXXXXXXXXXXXXXXXXXX"
}

# FIREBASE CREDENTIALS!
variable "POLISHED_FIREBASE_API_KEY" {
  default = ""
}

variable "POLISHED_FIREBASE_PROJECT_ID" {
  default = ""
}

variable "POLISHED_FIREBASE_AUTH_DOMAIN" {
  default = ""
}
