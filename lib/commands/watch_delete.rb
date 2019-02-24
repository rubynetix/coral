require_relative 'watch_command'

class WatchDelete < WatchCommand

  USAGE = <<~EOS.freeze
    Usage: watch_delete
      ...

    [options]
  EOS

  def execute; end
end
