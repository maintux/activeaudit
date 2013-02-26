class Person < ActiveRecord::Base
  include ActiveAudit::Logger

  attr_accessible :name, :surname, :age

  loggable_event create: true
  loggable_event destroy: true
  loggable_event update: [:name,:surname]
  loggable_event adult: [{age: 18}]
  loggable_event child: [{age: 14}]

end