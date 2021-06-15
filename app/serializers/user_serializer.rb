class UserSerializer < ActiveModel::Serializer
  attributes(*User.attribute_names.map(&:to_sym))

  # has_many :microposts, serializer: Api::V1::MicropostSerializer do
  #   include_data(false)
  #   link(:related) {api_v1_microposts_path(user_id: object.id)}
  # end

  has_many :followers, serializer: Api::V1::UserSerializer do
    include_data(false)
    link(:related) {api_v1_user_followers_path(user_id: object.id)}
  end

  has_many :followings, key: :followings, serializer: Api::V1::UserSerializer do
    include_data(false)
    link(:related) {api_v1_user_followings_path(user_id: object.id)}
  end
end
