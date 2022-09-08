class Friend < ApplicationRecord
	belongs_to :user, touch: true, class_name: "User", foreign_key: "foreign_id"
end
