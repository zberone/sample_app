namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		User.create!(name:"Micheal", 
			email:"micheal@example.org", 
			password:"foobar", 
			password_confirmation:"foobar")
		99.times do |n|
			name = Faker::Name.name
			email= "exuser#{n+1}@example.org"
			password = "password"
			User.create!(name: name,
						email: email,
						password: password,
						password_confirmation: password)
		end
	end
end