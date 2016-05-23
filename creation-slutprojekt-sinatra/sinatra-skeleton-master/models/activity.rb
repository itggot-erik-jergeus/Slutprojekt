class Activity
  include DataMapper::Resource

  property :id, Serial
  property :title, String, required: true
  property :type, String, required: true
  property :subject, String
  property :planning, String
  property :time, Integer
  property :date, DateTime, required: true
  property :hidden, Boolean, required: true
  property :parent, Boolean, required: true

  def plan(plan_length:)
    due = self.date
    time = self.time
    # Start of the intervall
    bed_time = (User.get(self.user_id)).bed_time - plan_length*60
    amount = 0
    while time > 0
      amount += 1
      time -= plan_length
    end
    # Amount of days left to due date.
    left = (due - Date.today)
    intervalls = left/(amount+1)
    day = 1
    while amount > 0
      next_training = Date.today+intervalls*day
      date = DateTime.new(next_training.year,next_training.month,next_training.day,bed_time.hour,bed_time.min)
      Activity.create(title: "#{self.title} Training", type: "Training", subject: self.subject,
                      date: date, planning: nil,
                      hidden: self.hidden, parent: self.parent, user_id: self.user_id)
      day += 1
      amount -= 1
    end
  end

  belongs_to :user
end