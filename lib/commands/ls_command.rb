require 'slop'
require_relative 'base_command'

class LsCommand
  include BaseCommand

  SEP = '  '

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
    begin
      files = Dir.entries(@opts.arguments[0])
    rescue SystemCallError
      $stderr.print "Error: " + $!
      return
    end

    unless @opts.all?
      files.select! { |f| not f.start_with?('.') }
    end

    old_dir = Dir.pwd
    Dir.chdir(@opts.arguments[0])
    print_files(files)
    Dir.chdir(old_dir)
  end

  private

  def color_by_type(f)
    if File.directory?(f)
      ColorText.blue(f)
    elsif File.executable?(f)
      ColorText.green(f)
    else
      f
    end
  end

  def print_files(files)
    cols = term_columns
    buf = []
    buf_len = 0

    files.each do |f|
      if buf_len + SEP.length + f.length > cols
        puts buf.join(SEP)
        buf.clear
        buf_len = 0
      end

      buf.push(color_by_type(f))
      buf_len += f.length + SEP.length
    end

    puts buf.join(SEP)
  end
end
