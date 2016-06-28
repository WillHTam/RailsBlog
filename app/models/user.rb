class User < ActiveRecord::Base
    has_many :posts

    has_secure_password
    
    validates :email, presence: true, uniqueness: true

    validates_format_of :email, :with => /@/

    validates :password, presence: true, length: {minimum: 8}
end
