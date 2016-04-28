class UserRequest
  include DataMapper::Resource

  property :id, Serial
  property :time, Time, required: true
  property :user_username, String, unique: true, required: true

  belongs_to :parent
end