User.create!(
  email: ENV['ZHF_ADMIN_EMAIL'],
  password: 'password',
  password_confirmation: 'password'
).confirm!
