config {
	plugin_dir = "~/.tflint.d/plugins"
	module = false
	force = false
	disabled_by_default = false
	ignore_module = {
	}
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "google" {
  enabled = true
}

rule "terraform_deprecated_interpolation" {
  enabled = false
}
