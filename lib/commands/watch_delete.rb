require_relative 'watch_command'

class WatchDelete < WatchCommand

  USAGE = <<~EOS.freeze
    Usage: watch_delete [action] [duration] [filenames]
      ...

    [options]
  EOS

  def initialize(input)
    super input
    @opts.options.banner = USAGE
  end

  def check_for_deletions
    until @files.empty?
      @files.each do |file|
        next unless !File.exist?(file)

        @files.delete(file)
        execute_change_action
      end
    end
  end

  def execute
    return if nil_or_help?

    @files.each do |file|
      @files.pop(file) unless File.exist?(file)
    end

    check_for_deletions
  end
end
