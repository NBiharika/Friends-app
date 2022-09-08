class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


         has_many :friends, class_name: "Friend", foreign_key: "foreign_id"
         has_many :posts

  scope :all_except, ->(user) { where.not(id: (user.friends + [user]).select(&:id))}
  #scope :all_except, ->(user) {id: (user.friends.where(user_id: user.id).select(:id))}

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  validates :email, format: URI::MailTo::EMAIL_REGEXP
  
  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end
end
