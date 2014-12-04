app_root = File.expand_path('../..', __FILE__)

$LOAD_PATH << "#{app_root}"
$LOAD_PATH << "#{app_root}/lib"

require 'bundler/setup'
require 'config/initializers/_settings'

log_file   = Settings.server.log || "#{app_root}/log/unicorn.log"
err_log    = "#{app_root}/log/unicorn_error.log"
pid_file   = Settings.server.pid || "#{app_root}/tmp/pids/unicorn.pid"
old_pid    = "#{pid_file}.oldbin"

rails_env = ENV['RAILS_ENV'] || 'production'

working_directory app_root
worker_processes Settings.server.workers

preload_app true
timeout 30
listen Settings.server.socket || Settings.server.port

pid pid_file
stderr_path err_log
stdout_path log_file

before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end


after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end
