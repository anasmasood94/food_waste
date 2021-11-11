server '34.209.200.218', user: 'deployer', roles: %w{app web db}

set :branch, 'master'

namespace :deploy do
  after :finished, 'app:restart'
end
