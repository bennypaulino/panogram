User.create!(name: "Pan Optic",
             email: "example@panogram.com",
             username: "widelux",
             password: "password",
             password_confirmation: "password",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
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
70.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# Liking microposts
microposts = Micropost.all
good_microposts = microposts[1..20]
cool_microposts = microposts[2..12]
cooler_microposts = microposts[4..10]
user2 = users.second
user3 = users.third
user4 = users.fourth
good_microposts.each { |m| user2.like_post(m) }
cool_microposts.each { |m| user3.like_post(m) }
cooler_microposts.each { |m| user4.like_post(m) }
