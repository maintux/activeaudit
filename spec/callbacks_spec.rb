require 'spec_helper'
require 'models/person'
require './app/models/active_audit/audit'

describe "Callbacks" do

  before :each do
    ActiveAudit::Audit.destroy_all
    @person = Person.create name: Faker::Name.first_name, surname: Faker::Name.last_name, age: 10, audit_user_id: 1
    @person.should_not be_nil
  end

  it "should create a 'create log'" do
    ActiveAudit::Audit.count.should eq(1)
    latest_log = ActiveAudit::Audit.last
    latest_log.obj_id.should eq(@person.id)
    latest_log.obj_type.should eq("Person")
    latest_log.activity.should eq("create")
    latest_log.user_id.should eq(1)
  end

  it "should create a 'destroy log'" do
    @person.destroy
    ActiveAudit::Audit.count.should eq(2)
    latest_log = ActiveAudit::Audit.last
    latest_log.obj_id.should eq(@person.id)
    latest_log.obj_type.should eq("Person")
    latest_log.activity.should eq("destroy")
    latest_log.user_id.should eq(1)
  end

  it "should create a 'update log' - One field" do
    @person.name = "new_#{Faker::Name.first_name}"
    @person.save
    ActiveAudit::Audit.count.should eq(2)
    latest_log = ActiveAudit::Audit.last
    latest_log.obj_id.should eq(@person.id)
    latest_log.obj_type.should eq("Person")
    latest_log.activity.should eq("update")
    latest_log.user_id.should eq(1)
  end

  it "should create a 'update log' - More fields" do
    @person.name = "new_#{Faker::Name.first_name}"
    @person.surname = "new_#{Faker::Name.last_name}"
    @person.email = Faker::Internet.email
    @person.save
    ActiveAudit::Audit.count.should eq(2)
    latest_log = ActiveAudit::Audit.last
    latest_log.obj_id.should eq(@person.id)
    latest_log.obj_type.should eq("Person")
    latest_log.activity.should eq("update")
    latest_log.user_id.should eq(1)
  end

  it "should not create a 'update log' - External field" do
    @person.email = Faker::Internet.email
    @person.save
    ActiveAudit::Audit.count.should eq(1)
  end

  it "should not create a 'update log' - Field linked to other event" do
    @person.age = 1
    @person.save
    ActiveAudit::Audit.count.should eq(1)
  end

  it "should create a 'child log'" do
    @person.age = 14
    @person.save
    ActiveAudit::Audit.count.should eq(2)
    latest_log = ActiveAudit::Audit.last
    latest_log.obj_id.should eq(@person.id)
    latest_log.obj_type.should eq("Person")
    latest_log.activity.should eq("child")
    latest_log.user_id.should eq(1)
  end

  it "should create a 'adult log'" do
    @person.age = 18
    @person.save
    ActiveAudit::Audit.count.should eq(2)
    latest_log = ActiveAudit::Audit.last
    latest_log.obj_id.should eq(@person.id)
    latest_log.obj_type.should eq("Person")
    latest_log.activity.should eq("adult")
    latest_log.user_id.should eq(1)
  end

  it "should create a 'adult log' and 'update log'" do
    @person.age = 18
    @person.name = "new_#{Faker::Name.first_name}"
    @person.save
    ActiveAudit::Audit.count.should eq(3)
    latest_logs = ActiveAudit::Audit.last(2)
    first_log = latest_logs.first
    first_log.obj_id.should eq(@person.id)
    first_log.obj_type.should eq("Person")
    first_log.activity.should eq("update")
    first_log.user_id.should eq(1)
    second_log = latest_logs.second
    second_log.obj_id.should eq(@person.id)
    second_log.obj_type.should eq("Person")
    second_log.activity.should eq("adult")
    second_log.user_id.should eq(1)
  end

end