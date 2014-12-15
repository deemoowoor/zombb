class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable

    validates :name, length: {maximum: 255}, uniqueness: true
    validates :password, length: { minimum: 6 }

    has_many :posts, dependent: :destroy
    has_many :post_comments, dependent: :destroy

    Role = [Reader = 'reader', Editor = 'editor', Admin = 'admin']
    after_initialize :set_default_role, :if => :new_record?

    def set_default_role
        self.role = Reader
    end

    def admin?
        self.role == Admin
    end

    def editor?
        self.role == Editor
    end

    def reader?
        self.role == Reader
    end

    protected

    # XXX: dirty hack
    def password_digest(password=nil)
        if password
            return Devise.bcrypt(self.class, password)
        else
            return 'nil'
        end
    end
end
