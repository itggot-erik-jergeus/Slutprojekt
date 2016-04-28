class ParentRequest
  include DataMapper::Resource

  property :id, Serial
  property :time, Time, required: true
  property :parent_username, String, unique: true, required: true

  belongs_to :user
end