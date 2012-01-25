Delayed KM
==========

Alternative for the Kissmetrics provided gem but using delayed_job instead of cron. This will suit Heroku users.

This will become a gem in the future, but for now, include in your Gemfile:

    gem 'httparty'
    gem 'delayed_job'

and copy the file lib/dkm.rb to your app/models directory
and copy the file spec/models/dkm_spec.rb to your spec/models directory
