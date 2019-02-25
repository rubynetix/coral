require_relative 'watch_command'

class WatchDelete < WatchCommand

  USAGE = <<~EOS.freeze
    Usage: watch_delete [action] [duration] [filenames]
      ...

    [options]
  EOS

  def initialize(input)
    super input
  end

  def check_for_deletions
    until @files.empty?
      @files.each do |file|
        next if File.exists?(file)

        @files.delete(file)
        execute_action(file)
      end
    end
  end

  def execute
    return if nil_or_help?

    @files.map! { |file| File.expand_path(file) }

    @files.each do |file|
      @files.delete(file) unless File.exists?(file)
    end

    check_for_deletions
  end
end
