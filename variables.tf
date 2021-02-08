variable "disable_aws" {
  type        = bool
  default     = false
  description = "Disable AWS."
}

variable "disable_github" {
  type        = bool
  default     = false
  description = "Disable github."
}

variable "disable_google" {
  type        = bool
  default     = false
  description = "Disable google."
}

variable "disable_cloudflare" {
  type        = bool
  default     = false
  description = "Disable cloudflare."
}

variable "as" {
  type = list(string)
  default = [
    "AS32934", # Facebook
    "AS2906",  # Netflix
    "AS46489", # Twitch
    "AS19679", # Dropbox
    "AS17012"  # Paypal
  ]
  description = "AS numbers."
}

variable "as_path" {
  default     = "as"
  type        = string
  description = "AS template path."
}

variable "use_predefined_blocks" {
  type        = bool
  default     = true
  description = "Use predefined blocks."
}

variable "base_blocks" {
  type        = list(string)
  default     = []
  description = "Default IP blocks."
}


variable "layered_blocks" {
  type = map(list(string))
  default = {
    default = []
  }
  description = "Layerd IP blocks."
}
