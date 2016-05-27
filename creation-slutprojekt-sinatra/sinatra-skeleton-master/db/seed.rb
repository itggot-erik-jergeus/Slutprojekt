class Seeder

  def self.seed!
    self.users
    self.plans
    self.subjects
    self.parents
    self.user_requests
    self.parent_requests
    self.activities
  end

  def self.users
    User.create(username: 'Barn', password: '123ABC', email_address: 'barn.mail@itggot.se', details: 'Hej, Jag heter barn', bed_time: Time.new(0000,01,01,20,00))
    User.create(username: 'Barn2', password: '123ABC', email_address: 'barn2.mail@itggot.se', details: 'Hej, Jag heter barn2', bed_time: Time.new(0000,01,01,20,00))
  end

  def self.parents
    Parent.create(username: 'Parent', password: '123ABC', email_address: 'parent@parent.se', details: 'I am parent')
  end

  def self.plans
    Plan.create(name: 'Standard', length: 90, amount: 4, weekend: 1, user_id: 1)
    Plan.create(name: 'Grabb', length: 60, amount: 3, weekend: 1, user_id: 1)
  end

  def self.subjects
    Subject.create(name: 'Engelska', user_id: 1)
    Subject.create(name: 'Programmering', user_id: 1)
  end

  def self.user_requests
    UserRequest.create(time: DateTime.now, requester_id: 1, parent_id: 1)
  end

  def self.parent_requests
    ParentRequest.create(time: DateTime.now, requester_id: 1, user_id: 2)
  end

  def self.activities
    Activity.create(title: "Engelska Prov", type: "Homework", subject: "Engelska", planning: "nil", time: 0, )
  end

end