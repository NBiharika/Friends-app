class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google]

  def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    # user.first_name = auth.info.first_name  # assuming the user model has a name
    # user.last_name = auth.info.last_name 
    # user.phone = auth.info.phone
    # user.twitter = auth.info.twitter]
    #user.uid = request.env["omniauth.auth"].uid,
    #user.provider = request.env["omniauth.auth"].provider,
    #user.image = auth.info.image # assuming the user model has an image
    # If you are using confirmable and the provider(s) you use validate emails, 
    # uncomment the line below to skip the confirmation emails.
     #user.skip_confirmation!
  end
end


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
