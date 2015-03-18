require "test_helper"

class UserTest < ActiveSupport::TestCase
  it "is valid with standard attributes" do
    assert User.new(password: "pizza", password_confirmation: "pizza", email: "wat@wat.com", name: "wat").valid?
  end

  it "generates a token before saving the user" do
    u = User.new(password: "pizza", password_confirmation: "pizza", email: "wat@wat.com", name: "wat")
    assert_nil u.token
    u.save
    refute_nil u.token
  end

  it "regens auth token when asked" do
    u = User.create(user_params)
    token = u.token
    u.regenerate_auth_token!
    assert_not_equal token, u.reload.token
  end
end
