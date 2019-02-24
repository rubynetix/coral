require_relative 'watch_command'

class WatchAlter < WatchCommand

  USAGE = <<~EOS.freeze
    Usage: watch_alter
      ...

    [options]
  EOS

  def initialize(input)
    super input
  end

  def check_for_alterations
    # TODO
  end

  def execute # TODO
    return if nil_or_help?

    @files.each do |file|
      @files.pop(file) if File.exist?(file)
    end

    check_for_alterations
  end
end
