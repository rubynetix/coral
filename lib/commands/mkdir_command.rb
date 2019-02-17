require 'slop'
require_relative 'base_command'

class MkdirCommand
  include BaseCommand

  ERR_DIR_EXISTS = "mkdir : cannot create directory #{@dir}, file already exists."
  USAGE = <<~EOS
    Usage: mkdir <directory>
      Creates the <directory> if it does not already exist.
  EOS

  def initialize(input)
    args = split_args input
    @opts = Slop.parse args do |o|
      o.bool '-h', '--help'
    end

    @dir = @opts.arguments.length > 1 ? @opts.arguments[1] : nil
  end

  def execute
    if @opts.help? || @dir.nil?
      puts USAGE
      return
    end

    if File.exist?(@dir)
      puts ERR_DIR_EXISTS
      return
    end

    Dir.mkdir(@dir)
  end
end