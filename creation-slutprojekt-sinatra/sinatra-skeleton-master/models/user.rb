class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String, required: true, unique: true
  property :password, BCryptHash, required: true
  property :email_address, String, required: true, unique: true
  property :details, Text
  property :planning, String

  # def self.request(app:, user:, parent_search:)
  #
  #
  # end

  has n, :relations
  has n, :activities
  has n, :plans
  has n, :parent_requests
  has n, :parents, through: :relations
end