User.create!(name: "Example User",
             email: "example@panogram.com",
             username: "blah",
             password: "password",
             password_confirmation: "password")

50.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@panogram.com"
  username = "reluctantracoon#{n+1}"
  password = "password"
  User.create!(name: name,
               email: email,
               username: username,
               password: password,
               password_confirmation: password)
end
