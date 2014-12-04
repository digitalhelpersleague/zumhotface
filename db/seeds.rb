User.create!(
  email: Settings.mail.admin,
  password: 'password',
  password_confirmation: 'password'
).confirm!
