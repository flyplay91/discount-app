# config valid for current version and patch releases of Capistrano
# lock "~> 3.14.1"

set :application, 'keeperscollective'
set :branch, :main
set :repo_url, 'git@github.com:advancedwebtech/keeperscollective-shopify'
set :keep_releases, 5
set :rvm_type, :auto

set :rvm_ruby_version, 'ruby-2.7.2'
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/system solr vendor/bundle}
set :linked_files, %w{config/master.key .env}
# set :sidekiq_config, 'config/sidekiq.yml'

set :bundle_binstubs, nil
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  # desc 'Run Sidekiq for Mailer'
  # task :mailer do
  #   on roles(:app) do
  #     within release_path do
  #       # with rails_env: fetch(:rails_env) do
  #         execute :bundle, :exec, :"sidekiq -d -L log/sidekiq.log -C config/sidekiq.yml"
  #       # end
  #     end
  #   end
  # end

  after :finishing, 'deploy:cleanup'
  # after  :finishing, :mailer
end

after 'deploy:publishing', 'deploy:restart'