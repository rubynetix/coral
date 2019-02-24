require_relative 'cmd'

# Functionality to keep track of all files in existence at any point in time.
class FileMonitor < Cmd
  def initialize(reader, welcome = 'Welcome to the Coral shell.')
    super reader, welcome
    @watch_threads = []
  end

  def do_watch(input_tokens)
    # TODO
  end


end
