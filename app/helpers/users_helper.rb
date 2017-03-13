module UsersHelper
	def gravatar_for(user)
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
#		image_tag("#{gravatar_id}.png", alt:user.name, class: "gravatar")
		image_tag("fox.png", alt:user.name, class: "gravatar")
	end
end
