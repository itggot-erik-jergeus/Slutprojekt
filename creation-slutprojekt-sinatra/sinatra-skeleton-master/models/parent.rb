class Parent
  include DataMapper::Resource

  property :id, Serial
  property :username, String, required: true, unique: true
  property :password, BCryptHash, required: true
  property :email_address, String, required: true, unique: true
  property :details, Text

  has n, :user_requests
  has n, :users, :through => Resource
end