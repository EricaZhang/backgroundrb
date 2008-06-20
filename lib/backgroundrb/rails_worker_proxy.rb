module BackgrounDRb
  class RailsWorkerProxy
    attr_accessor :worker_name, :worker_method, :data, :worker_key,:middle_man

    def self.worker(p_worker_name,p_worker_key = nil,p_middle_man = nil)
      t = new
      t.worker_name = p_worker_name
      t.middle_man = p_middle_man
      t.worker_key = p_worker_key
      t
    end

    def method_missing(method_id,*args)
      worker_method = method_id
      data = args[0]
      case worker_method
      when :ask_result
        middle_man.ask_result(compact(:worker => worker_name,:worker_key => worker_key,:job_key => data))
      when :worker_info
        middle_man.worker_info(compact(:worker => worker_name,:worker_key => worker_key))
      when :delete
        middle_man.delete_worker(compact(:worker => worker_name, :worker_key => worker_key))
      else
        choose_method(worker_method,data)
      end
    end

    def choose_method worker_method,data
      if worker_method =~ /^async_(\w+)/
        method_name = $1
        middle_man.ask_work(compact(:worker => worker_name,:worker_key => worker_key,:worker_method => method_name,:data => data))
      else
        middle_man.send_request(compact(:worker => worker_name,:worker_key => worker_key,:worker_method => worker_method,:data => data))
      end
    end

    def compact(options = { })
      options.delete_if { |key,value| value.nil? }
      options
    end
  end # end of RailsWorkerProxy class

end # end of BackgrounDRb module
