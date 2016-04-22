class Activity
  include DataMapper::Resource

  property :id, Serial
  property :title, String, required: true, unique: true
  property :type, String, required: true
  property :subject, String
  property :planning, String
  property :details, Text
  property :date, Date, required: true
  property :hidden, Boolean, required: true
  property :parent, Boolean, required: true

  belongs_to :user
end