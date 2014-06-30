#!/usr/bin/env ruby

require "daemon_spawn"

class MyServer < DaemonSpawn::Base

  def start(args)
    # process command-line args
    # start your bad self
    require_relative "newrelic_gcstorage_agent.rb"
  end

  def stop
    # stop your bad self
  end
end

MyServer.spawn!(:log_file => 'server_deamon.log',
                :pid_file => 'server_deamon.pid',
                :sync_log => true,
                :working_dir => File.dirname(__FILE__))