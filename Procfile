web: bundle exec unicorn -c config/unicorn.rb -E production
rescue: bundle exec rake environment resque:work QUEUE=*
