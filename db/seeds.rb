if ENV['ZHF_CREATE_USER'] == 'true'
  User.create!(
    email: Settings.admin.email,
    password: Settings.admin.password,
    password_confirmation: Settings.admin.password
  ).confirm!
end
