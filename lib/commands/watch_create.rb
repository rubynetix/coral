require_relative 'watch_command'

class WatchCreate < WatchCommand

  USAGE = <<~EOS.freeze
    Usage: watch_create [action] [duration] [filenames]
      ...

    [options]
  EOS

  def initialize(input)
    super input
    @opts.options.banner = USAGE
  end

  def check_for_creations
    until @files.empty?
      @files.each do |file|
        next unless File.exist?(file)

        @files.delete(file)
        execute_change_action
      end
    end
  end

  def execute
    return if nil_or_help?
    @files.each do |file|
      @files.pop(file) if File.exist?(file)
    end

    check_for_creations
  end
end
