require "test_helper"

class Api::V1::SessionsControllerTest < ActionController::TestCase
  it "returns user data including a token in exchange for valid email and password" do
    u = User.create(user_params)
    post :create, user_params.slice(:email, :password)
    assert_response :success
    assert_equal u.token, resp_data["user"]["token"]
  end

  it "401s invalid pw" do
    u = User.create(user_params)
    post :create, email: u.email, password: "fsafasfasdf"
    assert_response :unauthorized
  end

  it "re-assigns user token on #destroy" do
    u = User.create(user_params)
    login(u)
    token = u.token
    delete :destroy, id: u.id
    assert_response :success
    assert_not_equal token, u.reload.token
  end

  it "prevents regenerating another user's auth token" do
    u1 = User.create(user_params)
    u2 = User.create(user_params)
    login(u2)
    t1 = u1.token
    t2 = u2.token
    delete :destroy, id: u1.id
    assert_response :success
    assert_equal t1, u1.reload.token
    assert_not_equal t2, u2.reload.token
  end
end
