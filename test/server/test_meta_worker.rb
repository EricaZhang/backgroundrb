require File.join(File.dirname(__FILE__) + "/../bdrb_test_helper")
require "meta_worker"
require "chronic"

context "A Meta Worker should" do
  setup do
    options = {:schedules =>
      {
        :foo_worker => { :barbar => {:trigger_args=>"*/5 * * * * *", :data =>"Hello World" }},
        :bar_worker => { :do_job => {:trigger_args=>"*/5 * * * * *", :data =>"Hello World" }}
      },
      :backgroundrb => {:log => "foreground", :debug_log => false, :environment => "production", :port => 11006, :ip => "localhost"}
    }
    BDRB_CONFIG.set(options)

    BackgrounDRb::MetaWorker.worker_name = "hello_worker"

    class BackgrounDRb::MetaWorker
      attr_accessor :outgoing_data
      attr_accessor :incoming_data
      def send_data(data)
        @outgoing_data = data
      end

      def start_reactor; end
    end
    @meta_worker = BackgrounDRb::MetaWorker.start_worker
  end

  specify "load appropriate db environment from config file" do
    ENV["RAILS_ENV"] = BDRB_CONFIG[:backgroundrb][:environment]
    @meta_worker.send(:load_rails_env)
    ActiveRecord::Base.connection.current_database.should == "rails_sandbox_production"
  end

  xspecify "remove a task from schedule if end time is reached" do
  end

  xspecify "load appropriate schedule from config file" do
  end

  xspecify "register status request should be send out to master" do
  end

  xspecify "load schedule from passed arguments to start worker" do

  end

  xspecify "should have access to logger objects" do

  end

  xspecify "logger object should support info, error and debug methods" do

  end

  xspecify "invoke particular method based on user arguments" do

  end

  xspecify "should send results back to master only when response can be dumped" do

  end

  xspecify "should check for arguments of the invoked worker method" do

  end
end

