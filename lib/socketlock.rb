
require 'timeout'
require 'monitor'
require 'socket'
require 'uri'

class SocketLock
  SOCKETLOCK_ROOT = File.dirname(File.expand_path(File.dirname(__FILE__)))
  VERSION = '0.5.9'
  	
  def initialize port, interface = '127.0.0.1', lock_timeout = 15 * 60
		@port = port
		@interface = interface
		@locked = false
		@unlock_code = 'unlock'
		@lock_timeout = lock_timeout
		@monitor = Monitor.new
		@unlock_thread = nil
	end

	def lock
		@monitor.synchronize do
			return if locked? # we already have it
			Timeout::timeout(@lock_timeout) do
				while true
					begin
						@server = TCPServer.new(@interface, @port)
						@locked = true
						break
					rescue => e
						# Whoops... still not ours
						sleep(1.0)
					end
				end
			end # Timeout::timeout(@lock_timeout)
			# Watch for unlock requests
			@unlock_thread = Thread.new do
				while true
					begin
						socket = @server.accept()
						@monitor.synchronize do
							code = socket.gets.strip
							begin socket.close(); rescue; end
							if code == @unlock_code
								@locked = false
								@unlock_thread = nil
								@server.close()
								break
							end
						end
					rescue => e
						# Getting conn probs. We're just ignoring it.
						sleep(0.5)
					end
				end
			end # @unlock_thread
		end # @monitor.synchronize
	end # def lock

	def unlock
		@monitor.synchronize do
			if locked?
				socket = TCPSocket.new(@interface, @port)
				socket.puts @unlock_code
				socket.close()
				sleep(0.5) # Give it a chance
			end
		end
	end

	def locked?
		@monitor.synchronize {return @locked}
	end
end
