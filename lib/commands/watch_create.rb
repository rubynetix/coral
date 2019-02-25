require_relative 'watch_command'

class WatchCreate < WatchCommand

  USAGE = <<~EOS.freeze
    Usage: watch_create [action] [duration] [filenames]
      ...

    [options]
  EOS

  def initialize(input)
    super input
  end

  def check_for_creations
    until @files.empty?
      @files.each do |file|
        next unless File.exists?(file)

        @files.delete(file)
        execute_action(file)
      end
    end
  end

  def execute
    return if nil_or_help?

    @files.map! { |file| File.expand_path(file) }

    @files.each do |file|
      @files.delete(file) if File.exists?(file)
    end

    check_for_creations
  end
end
