ActionMailer::Base.smtp_settings = {
  domain:         'foodwaste.aimfit.io',
  address:        "smtp.sendgrid.net",
  port:            587,
  authentication: :plain,
  user_name:      'apikey',
  enable_starttls_auto: true,
  password:       ENV['SENDGRID_API_KEY']
}
