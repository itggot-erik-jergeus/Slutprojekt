class Activity
  include DataMapper::Resource

  property :id, Serial
  property :title, String, required: true, unique: true
  property :type, String, required: true
  property :subject, String
  property :planning, String
  property :details, Text
  property :date, DateTime, required: true
  property :hidden, Boolean, required: true
  property :parent, Boolean, required: true

  def plan(plan_length:)
    due = self.date
    # Fix a time varaible
    time = self.time
    amount = 0
    while time > 0
      amount += 1
      time -= plan_length
    end
    
  end

  belongs_to :user
end