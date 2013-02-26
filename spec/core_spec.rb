require 'spec_helper'
require 'models/person'

describe "Core" do

  it "should have loggable_event method" do
    ret = Person.respond_to?(:loggable_event)
    ret.should be_true
  end

  it "should have audit_user_id attribute" do
    person = Person.new
    ret = person.respond_to?(:audit_user_id)
    ret.should be_true
  end

  it "should have right loggable_events" do
    events = Person.loggable_events
    events.should eq({create: true, destroy: true, update: [:name,:surname], adult: [{age: 18}], child: [{age: 14}]})
  end

end