require "test_helper"

describe Api::V1::UsersController do
  it "creates a user on post to create" do
    assert_equal 0, User.count
    params = {email: "test@example.com", password: "pizza", password_confirmation: "pizza", name: "worace"}
    post :create, user: params
    assert_response :success
    assert_equal params, User.last.attributes.slice(params.keys)
  end
end
