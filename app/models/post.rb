class Post < ApplicationRecord

  	scope :most_recent, -> { order(id: :desc)}


  	def display_day_published
  		"Published #{created_at.strftime('%-b %-d, %Y')}"
  	end

  	belongs_to :user
  	#scope :posts_by_not_current_user, ->(user) { where.not(user: user) }
end
