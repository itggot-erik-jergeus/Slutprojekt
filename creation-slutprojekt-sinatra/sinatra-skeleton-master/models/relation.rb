class Relation
  include DataMapper::Resource

  property :id, Serial

  belongs_to :user
  belongs_to :parent
end