# ActiveAudit

Audit support for Active Record

## Install

Include `ActiveAudit` in your Gemfile
```ruby
gem 'activeaudit', :git=>'https://github.com/maintux/activeaudit.git'
```
and update your bundle
```
bundle install
```

Then run the task to generate migration
```
rake active_audit_rails_engine:install:migrations
```
and execute migration
```
rake db:migrate
```

## Usage

In your model you have to include the mixin
```ruby
include ActiveAudit::Logger
```
This mixin allow you to use an helper called `loggable_event` that define what you want to log.

The basic syntax is:
```ruby
loggable_event create: true
loggable_event destroy: true
loggable_event update: true
```
With this, ActiveAudit will log events using the standard callbacks `after_create`, `after_update` and `before_destroy`

If you want customize the fields that determine the logging action, you can use the Array syntax like the following example:
```ruby
loggable_event update: [:name,:surname]
```
So with this syntax, ActiveAudit will log the update event only if `name` __OR__ `surname` fields are changed.

You can also specify the value that a field must have to trigger the logging:
```ruby
loggable_event update: [{state: "confirmed"}]
```
In this case ActiveAudit will log the update event only if `state` field is changed and the new value is "confirmed"

It's possible to use custom event name that is managed like an update event. For exaple you can create an event called `confirmation` like this:
```ruby
loggable_event confirmation: [{state: "confirmed"}]
```

## Contributing to ActiveAudit

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 Massimo Maino. See LICENSE.txt for further details.

