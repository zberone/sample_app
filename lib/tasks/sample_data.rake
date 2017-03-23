namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		User.create!(name:"Micheal", 
			email:"micheal@example.com", 
			password:"foobar", 
			password_confirmation:"foobar",
			admin: true )
		33.times do |n|
			name = Faker::Name.name
			email= "exuser#{n+1}@example.org"
			password = "password"
			User.create!(name: name,
						email: email,
						password: password,
						password_confirmation: password)
		end
		users = User.all(limit: 8)
		40.times do
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create!(content: content)}
		end
	end
end