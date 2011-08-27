Delayed KM
==========

Intended as replacement for the Kissmetrics provided gem but using delayed_job instead of cron.

If you are using Heroku for hosting you will find this much simpler than having to configure cron and a temp folder.

Include in your Gemfile:

  gem 'httparty'
  gem 'delayed_job'

and copy the file lib/km.rb to your app/models directory
