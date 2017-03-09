FactoryGirl.define do
	factory :user do
		name "Michael Hartl"
		email "michael@example.net"
		password "foobar"
		password_confirmation "foobar"
	end
end