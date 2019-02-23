require 'slop'
require_relative 'base_command'
require_relative '../color_text'

class LsCommand
  include BaseCommand

  SEP = '  '.freeze

  def initialize(args)
    @opts = Slop.parse args do |o|
      o.bool '-a', '--all', 'display all files'
    end

    @opts.arguments.shift
    @dir = !@opts.arguments.empty? ? @opts.arguments[0] : '.'
  end

  def execute
    begin
      files = Dir.entries(@dir)
    rescue SystemCallError => e
      $stderr.print "#{e.message}\n"
      return
    end

    files.select! { |f| !f.start_with?('.') } unless @opts.all?

    orig_dir = Dir.pwd
    Dir.chdir(@dir)
    print_files(files)
    Dir.chdir(orig_dir)
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
