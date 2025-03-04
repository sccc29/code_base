variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string

}

variable "kms_enabled" {
  description = "Enable KMS encryption"
  type        = bool
  default     = false
}