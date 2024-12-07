Passwordless.configure do |config|
  config.default_from_address = "hola@anima.sgm.codes"
  # after a successful session is set, this will last this amount of time
  config.expires_at = lambda { 2.days.from_now }
  # after successful login, go to this path
  config.success_redirect_path = "/animitas"
  # when email is supplied, show the token input view even if no email was found
  config.paranoid = true
end