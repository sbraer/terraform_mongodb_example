variable "namespace_name" {
  description = "Name for the namespace"
  type        = string
  default     = "test-blog"
}

variable "mongodb_username" {
  description = "username used for mongodb authentication"
  type        = string
  default     = "myuser"
}

variable "mongodb-express-port" {
  description = "port for mongoexpress web application"
  type        = number
  default     = 30165
}

variable "testdb-port" {
  description = "port for testdb web application"
  type        = number
  default     = 30164
}