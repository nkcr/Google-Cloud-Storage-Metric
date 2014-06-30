#! /usr/bin/env ruby

#
# This module is an agent that provides metric for
# a google cloud storage buket
# Please fill the config file before run
#

require "rubygems"
require "bundler/setup"

require "newrelic_plugin"

require_relative 'modules/googleAuth'

module GCloudStorageAgent

  #
  # Agent, Metric and PollCycle classes
  #
  # Each agent module must have an Agent, Metric and PollCycle class that inherits from their
  # Component counterparts as you can see below.
  #

  class Agent < NewRelic::Plugin::Agent::Base
    agent_guid "ch.nkcr.google_cloud_storage_metric"
    agent_version "1.0.1"
    #
    # agent_config is a list of variables that the component will need
    # from its instances.
    #
    agent_config_options :google_storage_bucket_name, :google_storage_key_path,:google_storage_key_secret,:google_storage_mail, :element_offset_alert, :size_offset_alert
    agent_human_labels("GCloud Storage") { "gs://#{google_storage_bucket_name}" }

    def setup_metrics
      @google = GClient.new(google_storage_key_path,google_storage_key_secret,google_storage_mail)
      @next_day = (Time.now + 86400).day
      @last_number = @google.number(google_storage_bucket_name)
      @last_size = @google.size(google_storage_bucket_name)
      @current_element_dif = 0
      @current_size_dif = 0
      @elements_rate = NewRelic::Processor::EpochCounter.new
      @size_rate = NewRelic::Processor::EpochCounter.new
    end

    def poll_cycle
      number = @google.number(google_storage_bucket_name)
      tot_size = @google.size(google_storage_bucket_name)
      current_day = Time.now.day
      if current_day == @next_day
        @next_day = (Time.now + 86400).day
        @current_element_dif = number - @last_number
        @last_number = number
        @current_size_dif = tot_size - @last_size
        @last_size = tot_size
        puts "[#{Time.now}] i go"
      end
      report_metric "Total/size", "Bytes", tot_size
      report_metric "Total/elements", "Elements", number
      report_metric "Difference/day/elements", "Elements/day", @current_element_dif
      report_metric "Difference/day/size", "Bytes/day", @current_size_dif
      report_metric "Difference/rate/elements", "Elements/sec", @elements_rate.process(number)
      report_metric "Difference/rate/size", "Bytes/sec", @size_rate.process(tot_size)
      report_metric "Alert/elements", "Offset - Elements/day", element_offset_alert - @current_element_dif
      report_metric "Alert/size", "Offset - Bytes/day", size_offset_alert - @current_size_dif
    end

  end

  #
  # Register this agent with the component.
  # The GCStorageAgent is the name of the module that defines this
  # driver (the module must contain at least three classes - a
  # PollCycle, a Metric and an Agent class, as defined above).
  #
  NewRelic::Plugin::Setup.install_agent :gcstorage, GCloudStorageAgent

  #
  # Launch the agent; this never returns.
  #
  NewRelic::Plugin::Run.setup_and_run

end
