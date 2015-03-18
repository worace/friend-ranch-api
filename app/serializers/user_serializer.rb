class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :token
end
