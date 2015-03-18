require "test_helper"

describe Api::V1::UsersController do
  it "creates a user on post to create" do
    SecureRandom.expects(:uuid => "token")
    post :create, user: user_params
    assert_response :success
    assert_equal ["id", "email", "token", "name"].sort, resp_data["user"].keys.sort
    u = User.last
    assert_equal user_params["email"], u.email
    assert_equal user_params["name"], u.name
    assert_equal "token", u.token
  end

  it "returns validation errors if user is invalid (eg pw doesnt match)" do
    params = hwia({email: "test@example.com", password: "asdgasg", password_confirmation: "pizza", name: "worace"})
    post :create, user: params
    assert_response 406
    assert_equal resp_data["status"], "error"
    assert resp_data["errors"].keys.include?("password_confirmation")
  end

  it "finds a user via token on show" do
    u = User.create!(user_params)
    request.env[Api::V1::BaseController::TOKEN_HEADER] = u.token
    get :show, {id: u.id}
    assert_response :success
    assert_equal u.email, resp_data["user"]["email"]
  end

  it "won't auth user with invalid token" do
    u = User.create!(user_params)
    @request.env[Api::V1::BaseController::TOKEN_HEADER] = "not-a-token"
    get :show, id: u.id
    assert_response :unauthorized
  end

  it "won't auth user with non-matching token" do
    u = User.create!(user_params)
    u2 = User.create!(user_params)
    @request.env[Api::V1::BaseController::TOKEN_HEADER] = u2.token
    get :show, id: u.id
    assert_response :unauthorized
  end
end

def user_params
  hwia({email: "test@example.com", password: "pizza", password_confirmation: "pizza", name: "worace"})
end

def resp_data
  JSON.parse(response.body)
end
