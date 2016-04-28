class Seeder

  def self.seed!
    self.users
    self.plans
    self.subjects
    self.parents
  end

  def self.users
    User.create(username: 'Erik', password: '123ABC', email_address: 'erik.mail@itggot.se', details: 'dlas')
  end

  def self.parents
    Parent.create(username: 'Parent', password: '123ABC', email_address: 'parent@parent.se', details: 'I am parent')
  end

  def self.plans
    Plan.create(name: 'Standard', length: 4800, amount: 4, weekend: 1, user_id: 1)
    Plan.create(name: 'Grabb', length: 3600, amount: 3, weekend: 1, user_id: 1)
  end

  def self.subjects
    Subject.create(name: 'Engelska', user_id: 1)
    Subject.create(name: 'NO', user_id: 1)

  end

end