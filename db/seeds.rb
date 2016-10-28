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

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
