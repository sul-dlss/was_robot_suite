server 'was-robots1-qa.stanford.edu', user: 'was', roles: %w{web app db rollup worker}

Capistrano::OneTimeKey.generate_one_time_key!
