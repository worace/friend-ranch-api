require "securerandom"

class User < ActiveRecord::Base
  has_secure_password
  before_create :generate_auth_token

  def generate_auth_token
    token = SecureRandom.uuid
    while User.exists?(token: token)
      token = SecureRandom.uuid
    end
    self.token = token
  end

  def regenerate_auth_token!
    generate_auth_token && save!
  end
end
