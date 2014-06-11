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

  #
  # Agent, Metric and PollCycle classes
  #
  # Each agent module must have an Agent, Metric and PollCycle class that inherits from their
  # Component counterparts as you can see below.
  #

  class Agent < NewRelic::Plugin::Agent::Base
    agent_guid "ch.nkcr.test.google_cloud_storage_metric2"
    agent_version "1.0.1"
    #
    # agent_config is a list of variables that the component will need
    # from its instances.
    #
    agent_config_options :google_storage_bucket_name, :google_storage_key_path,:google_storage_key_secret,:google_storage_mail
    agent_human_labels("Example Agent") { "Synthetic example data" }

    def setup_metrics
      @google = GClient.new(google_storage_key_path,google_storage_key_secret,google_storage_mail)
      @next_hour = (Time.now + 86400).day
      @last_number = @google.number(google_storage_bucket_name)
      @current_dif = 0
      @elements_rate = NewRelic::Processor::EpochCounter.new
    end

    def poll_cycle
      number = @google.number(google_storage_bucket_name)
      tot_size = @google.size(google_storage_bucket_name)
      report_metric "Total/size", "Megabytes", tot_size
      report_metric "Total/elements", "Elements", number
      current_day = Time.now.day
      if now_hour == @next_hour
        @next_hour = (Time.now + 86400).day
        @current_dif = number - @last_number
        @last_number = number
        puts "[#{Time.now}] i go"
      end
      report_metric "Difference/day", "Elements", @current_dif
      report_metric "Difference/rate/elements", "Elements", @elements_rate.process(number)
      report_metric "Difference/rate/size", "Elements", @elements_rate.process(number)
    end

    def next_hour(hour)
      if hour == 23
        return 0
      else
        return hour + 1
      end
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
