require 'slop'
require_relative 'base_command'

class LsCommand
  include BaseCommand

  def initialize(input)
    args = split_args input
    @opts = Slop.parse args do |o|
      o.bool '-a', '--all', 'display all files'
    end

    @opts.arguments.shift
    @pos_args = @opts.arguments

    raise NotEnoughArgumentsError unless @pos_args.length >= 1
  end

  def execute
    files = Dir.entries(@opts.arguments[0])

    unless @opts.all?
      files.select! { |f| not f.start_with?('.') }
    end

    puts files
  end
end