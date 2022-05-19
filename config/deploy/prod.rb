server 'was-robots1-prod.stanford.edu', user: 'was', roles: %w{web app db monitor rollup}

Capistrano::OneTimeKey.generate_one_time_key!
