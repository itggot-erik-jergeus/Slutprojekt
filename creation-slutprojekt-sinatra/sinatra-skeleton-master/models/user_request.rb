class UserRequest
  include DataMapper::Resource

  property :id, Serial
  property :time, Time, required: true
  property :requester_id, String, unique: true, required: true

  belongs_to :parent
end