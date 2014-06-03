#! /usr/bin/env ruby

#
# This is an example agent which generates synthetic data.
# A 1mHz (one cycle every 16 minutes) sin+1, cos+1 and sin+5 wave is generated,
# using the Unix epoch as the base.
#

require "rubygems"
require "bundler/setup"

require "newrelic_plugin"

require_relative 'modules/googleAuth'

module ExampleAgent

  class Agent < NewRelic::Plugin::Agent::Base
    agent_guid "ch.nkcr.test.google_cloud_storage_metric"
    agent_version "1.0.1"
    agent_config_options :google_storage_bucket_name, :google_storage_key_path,:google_storage_key_secret,:google_storage_mail
    agent_human_labels("Example Agent") { "Synthetic example data" }

    def setup_metrics
      @google = GClient.new(google_storage_key_path,google_storage_key_secret,google_storage_mail)
      @last_time = Time.now
      @last_number = @google.number(google_storage_bucket_name)
      @current_dif = 0
    end

    def poll_cycle
      report_metric "Total/size", "Megabytes", @google.size(google_storage_bucket_name)
      number = @google.number(google_storage_bucket_name)
      report_metric "Total/elements", "Elements", number
      now = Time.now
      if now <= (@last_time + 60)
        @last_time = now
        @current_dif = number - @last_number
        @last_number = number
        puts "i go"
      end
      report_metric "Difference/2min", "Elements", @current_dif
    end

  end

  #
  # Register this agent with the component.
  # The ExampleAgent is the name of the module that defines this
  # driver (the module must contain at least three classes - a
  # PollCycle, a Metric and an Agent class, as defined above).
  #
  NewRelic::Plugin::Setup.install_agent :example, ExampleAgent

  #
  # Launch the agent; this never returns.
  #
  NewRelic::Plugin::Run.setup_and_run

end
