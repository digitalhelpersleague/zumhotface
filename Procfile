web: bundle exec rails s thin -p $ZHF_PORT -b $ZHF_HOST
rescue: RESQUE_TERM_TIMEOUT=7 TERM_CHILD=1 bundle exec rake environment resque:work QUEUE=*
