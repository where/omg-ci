class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  ROLES = ['user', 'admin']
  validates :role, :inclusion => {:in => ROLES}, :allow_nil => true

  ROLES.each do |role|
    define_method "#{role}?" do
      self.role == role
    end
  end

  def self.create_user(email, password, role)
    user = User.new(:email => email,
      :password => password,
      :password_confirmation => password,
    )
    user.role = role
    user.save

    user
  end

end
