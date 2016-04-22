class Plan
  include DataMapper::Resource

  property :id, Serial
  property :name, String, required: true
  property :length, Integer, required: true
  property :amount, Integer
  property :weekend, Integer, required: true

  belongs_to :user
end