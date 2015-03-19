class Api::V1::BaseController < ApplicationController
  TOKEN_HEADER = "HTTP_X_FRIENDRANCHTOKEN"
  def current_user
    return nil unless auth_token
    @current_user ||= User.find_by(token: auth_token)
  end

  def auth_token
    request.headers.env[TOKEN_HEADER]
  end
end
