class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String, required: true, unique: true
  property :password, String, required: true
  property :email_address, String, required: true, unique: true
  property :details, Text

  has n, :relations
  has n, :parents, through: :relations
end