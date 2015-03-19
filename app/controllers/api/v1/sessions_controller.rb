class Api::V1::SessionsController < Api::V1::BaseController
  protect_from_forgery :except => :create
  def create
    u = User.find_by(email: params[:email])
    if u && u.authenticate(params[:password])
      render json: u
    else
      render json: {status: "login failed"}, status: 401
    end
  end

  def destroy
    if current_user
      current_user.regenerate_auth_token!
      render json: {status: "successfully logged out"}
    else
      render json: {status: "unauthorized"}, status: 401
    end
  end
end
