#!/usr/bin/env ruby

# =================================================================================================
# PoolMaster
#
module PoolMaster
  class Base
    attr_accessor :server_socket

    def initialize(server_socket)
      self.server_socket = server_socket
    end

    def name
      "PoolMaster"
    end

    def run
      before_start
      log self, "INIT"

      loop {
        client_socket = server_socket.accept
        create_worker(client_socket)
      }

      log self, "SHUTDOWN"
      before_end
    end

    private
      def before_start
      end

      def before_end
      end
  end

  # ===============================================================================================
  # PoolMaster::Process
  #
  class Process < Base

    def id
      ::Process.pid
    end

    private

      def create_worker(client_socket)
        fork do
          Worker::Process.new(client_socket).run
        end
        client_socket.close
      end

      def before_start
        $PROGRAM_NAME = "RubySpark#{name}"

        trap(:TERM, :DEFAULT)
        trap(:HUP, :DEFAULT)

        trap(:CHLD) {

          pid, status = nil, nil

          begin
            while pid != 0 && status != 0
              pid, status = ::Process.waitpid2 0, ::Process::WNOHANG
            end
          rescue Errno::ECHILD
          end

          # Process.wait(0, Process::WNOHANG)
        }
      end

  end

  # ===============================================================================================
  # PoolMaster::Thread
  #
  class Thread < Base
    def id
      ::Thread.current.object_id
    end

    private

      def create_worker(client_socket)
        ::Thread.new do
          Worker::Thread.new(client_socket).run
        end
      end

  end
end
