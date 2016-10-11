User.create!(name: "Example User",
             email: "example@panogram.com",
             username: "blah",
             password: "password",
             password_confirmation: "password",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

50.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@panogram.com"
  username = "reluctantracoon#{n+1}"
  password = "password"
  User.create!(name: name,
               email: email,
               username: username,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end
