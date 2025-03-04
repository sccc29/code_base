variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string

}

variable "kms_enabled" {
  description = "Enable KMS encryption"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "The KMS key ID"
  type        = string
  default     = ""

}