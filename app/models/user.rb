class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  ROLES = ['user', 'admin']
  validates :role, :inclusion => {:in => ROLES}

  ROLES.each do |role|
    define_method "#{role}?" do
      self.role == role
    end
  end

end
