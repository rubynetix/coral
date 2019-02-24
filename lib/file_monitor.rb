require_relative 'cmd'
require_relative 'commands/watch_create'
require_relative 'commands/watch_alter'
require_relative 'commands/watch_delete'

# Cmd with extra functionality to keep track of all files in existence at any point in time.
class FileMonitor < Cmd
  def initialize(reader, welcome = 'Welcome to the Coral shell.')
    super reader, welcome
    @watch_threads = []
  end

  def do_watch_create(input_tokens)
    thread = Thread.start { WatchCreate.new(input_tokens).execute }
    @watch_threads.push(thread)
  end

  def do_watch_alter(input_tokens)
    thread = Thread.start { WatchAlter.new(input_tokens).execute }
    @watch_threads.push(thread)
  end

  def do_watch_delete(input_tokens)
    thread = Thread.start { WatchDelete.new(input_tokens).execute }
    @watch_threads.push(thread)
  end

  def loop_finish
    @watch_threads.each do |thread|
      Thread.kill(thread)
    end
  end
end
