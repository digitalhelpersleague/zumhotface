# vi: set ft=sh :

job: RESQUE_TERM_TIMEOUT=7 TERM_CHILD=1 bundle exec rake environment resque:work QUEUE=*
web: bundle exec rails s thin -p $ZHF_APP_PORT -b $ZHF_APP_HOST
