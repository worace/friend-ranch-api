class Api::V1::BaseController < ApplicationController
  TOKEN_HEADER = "X-FriendRanchToken"
  def current_user
    return nil unless request.headers.env[TOKEN_HEADER]
    @current_user ||= User.find_by(token: request.headers.env[TOKEN_HEADER])
  end
end
