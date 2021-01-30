variable "as" {
  type = list(string)
  default = [
    "AS32934",
    "AS2906",
    "AS46489",
    "AS19679",
    "AS17012"
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
  type = list(string)
  default = [
    "4.0.0.0/8",  # CenturyLink, Inc. 1992-12 1992-12-01  Originally Bolt Beranek and Newman Inc. (then GTE, then Genuity) 1992-12. Updated to Level 3 Communications, Inc. in 2007-04. Updated to CenturyLink in 2017-11.
    "12.0.0.0/8", # AT&T Services 1995-06 1983-08-23  Originally AT&T Bell Laboratories, retained by AT&T when Bell Labs was spun off to Lucent Technologies in 1996.
    "17.0.0.0/8", # Apple Inc.  1992-07 1990-04-16  
    "19.0.0.0/8", # Ford Motor Company  1995-05 1988-06-15  
    "38.0.0.0/8", # PSINet, Inc.  1994-09 1991-04-16  PSINet, then Cogent Communications.
    "48.0.0.0/8", # Prudential Securities Inc.  1995-05 1990-12-07  The Prudential Insurance Company of America.
    "56.0.0.0/8", # US Postal Service 1994-06 1992-11-02  
    "73.0.0.0/8"
  ]
  description = "Default IP blocks."
}


variable "layered_blocks" {
  type = map(list(string))
  default = {
    default = []
  }
  description = "Layerd IP blocks."
}
