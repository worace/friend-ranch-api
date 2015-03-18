class Api::V1::UsersController < Api::V1::BaseController
  before_filter :require_matching_auth_token, only: [:show]
  protect_from_forgery :except => :create

  def create
    u = User.new(user_params)
    if u.save
      render json: u
    else
      render json: {status: "error", errors: u.errors}.to_json, status: 406
    end
  end

  def me
    if current_user
      render json: current_user
    else
      render json: {"error" => "not logged in"}, status: 401
    end
  end

  def show
    render json: current_user
  end

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

  def require_matching_auth_token
    unless current_user.present? && current_user.id == params["id"].to_i
      render json: {error: "not authorized"}, status: 401
    end
  end
end
