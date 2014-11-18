class User < ActiveRecord::Base
    before_save { self.email = email.downcase }
    validates :name, presence: true, length: {maximum: 255}, uniqueness: true

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

    has_secure_password

    validates_confirmation_of :password
    validates :password, length: { minimum: 6 }

    has_many :posts, dependent: :destroy
    has_many :post_comments, dependent: :destroy
end
