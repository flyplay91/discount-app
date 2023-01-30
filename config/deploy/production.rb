server 'app.keeperscollective.com', user: 'deploy', roles: %w{app web db}
set :branch, :main
set :deploy_to, '/var/www/app.keeperscollective.com'
set :rails_env, :production

set :ssh_options, {
	keys: %w(~/.ssh/id_rsa),
	forward_agent: false
}


set :pty,             true
set :use_sudo,        false
set :deploy_via,      :remote_cache
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/keeperscollective-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord