require_relative 'watch_command'

class WatchDelete < WatchCommand

  USAGE = <<~EOS.freeze
    Usage: watch_delete
      ...

    [options]
  EOS

  def initialize(input)
    super input
  end

  def check_for_deletions
    # TODO
  end

  def execute
    return if nil_or_help?

    @files.each do |file|
      @files.pop(file) unless File.exist?(file)
    end

    check_for_deletions
  end
end
