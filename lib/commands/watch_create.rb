require_relative 'watch_command'

class WatchCreate < WatchCommand

  USAGE = <<~EOS.freeze
    Usage: watch_create [filenames] [action] [duration]
      ...

    [options]
  EOS

  def initialize(input)
    super input
  end

  def execute
    super.execute
  end
end
