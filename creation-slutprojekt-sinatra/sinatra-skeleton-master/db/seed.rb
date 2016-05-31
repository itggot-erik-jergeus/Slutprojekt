class Seeder

  def self.seed!
    self.users
    self.plans
    self.subjects
    self.parents
    self.user_requests
    self.parent_requests
    self.activities

    puts "Suggestion after seed: Create an activity with the standard planning schedule"

  end

  def self.users
    User.create(username: 'John', password: '123ABC', email_address: 'barn.mail@itggot.se', details: 'Hello, I am John. I use this website because I am not goot at keeping track of homework', bed_time: Time.new(0000,01,01,20,00))
    User.create(username: 'Mike', password: '123ABC', email_address: 'barn2.mail@itggot.se', details: 'Hello, I am Mike and I am from Sweden', bed_time: Time.new(0000,01,01,20,00))
  end

  def self.parents
    Parent.create(username: 'Rachel', password: '123ABC', email_address: 'parent@parent.se', details: "I am John's mother")
    Parent.create(username: 'Robert', password: '123ABC', email_address: 'parent2@parent.se', details: "I am John's father and Mike's uncle")
  end

  def self.plans
    Plan.create(name: 'Standard', length: 90, amount: 4, weekend: 1, user_id: 1)
    Plan.create(name: 'Hourly', length: 60, amount: 3, weekend: 1, user_id: 1)
    Plan.create(name: 'Standard', length: 90, amount: 4, weekend: 1, user_id: 2)
  end

  def self.subjects
    Subject.create(name: 'English', user_id: 1)
    Subject.create(name: 'Programming', user_id: 1)
    Subject.create(name: 'Programming', user_id: 2)
    Subject.create(name: 'Social Studies', user_id: 2)
  end

  def self.user_requests
    UserRequest.create(time: DateTime.now, requester_id: 2, parent_id: 2)
  end

  def self.parent_requests
    ParentRequest.create(time: DateTime.now, requester_id: 1, user_id: 1)
    ParentRequest.create(time: DateTime.now, requester_id: 2, user_id: 1)
  end

  def self.activities
    Activity.create(title: "English essay", type: "Homework", subject: "English", planning: "nil", time: 120, date: (DateTime.now+12), hidden: false, parent: false, user_id: 1)
    a = Activity.create(title: "Programming test", type: "Homework", subject: "Programming", planning: "nil", time: 300, date: (DateTime.now+15), hidden: false, parent: false, user_id: 1)
    a.plan(plan_length: (Plan.first(name: "Standard", user_id: 1)).length)
    Activity.create(title: "Fest hos Mange", type: "Other", subject: "nil", planning: "nil", time: 0, date: (DateTime.now+1), hidden: true, parent: false, user_id: 2)
  end

end