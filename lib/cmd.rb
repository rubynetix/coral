require_relative 'shell_commands'
require_relative 'color_text'
require 'readline'
require 'set'

# Ruby shell
class Cmd
  include ShellCommands

  @shell_pid = Process.pid

  class << self
    attr_accessor :shell_pid
  end

  def initialize(reader, welcome = 'Welcome to the Coral shell.')
    @welcome = welcome
    @reader = reader

    @original_stdout

    @reader.prepare
  end

  def loop_setup
    @original_stdout = $stdout.dup
    puts @welcome unless @welcome.nil?
  end

  def loop_finish; end

  def cmd_loop
    loop_setup

    while (input = @reader.read(prompt))
      next if input == ''

      process_input input
    end
    loop_finish
  end

  def process_input(input)
    trap('TERM'){ exit(status=1) }

    begin
      input_tokens = input.strip.split(' ')
      command = input_tokens[0]
      if input_tokens.include?(">")
        input_tokens = redirect_stdout(input_tokens)
      end

      if !(new_cmd = get_cmd command).nil?
        process_cmd new_cmd, input_tokens
      else
        handle_unknown_cmd command
      end
    rescue IOError => e
      $stderr.print "#{e.message}\n"
      return
    rescue Slop::UnknownOption => e
      $stderr.print "#{command}: #{e.message}\n"
    end
  end

  # Create child/worker process
  # Parent : wait for worker (child) to finish
  # Child: change job
  # Parent: report results
  def process_cmd(command, input_tokens)
    send command, input_tokens
  end

  def handle_unknown_cmd(command)
    puts 'Invalid command: ' + command
  end

  def redirect_stdout(input_tokens)
    arrow_idx = input_tokens.index(">")
    if arrow_idx + 1 >= input_tokens.length
      raise IOError, "Unexpected stdout redirection: nil"
    end

    outfile = input_tokens[arrow_idx + 1]
    if File.directory?(outfile)
      raise IOError, "Unexpected stdout redirection: #{outfile} is a directory"
    end

    $stdout = $stdout.reopen(outfile, "w")
    remove_array_indexes(input_tokens, Set[arrow_idx, arrow_idx+1])
  end

  def prompt
    ColorText.red("#{ENV['USER']}@coral") +
      ':' +
      ColorText.blue(Dir.pwd.to_s) +
      '$ '
  end

  def remove_array_indexes(array, idx_set)
    array.reject{ |item| idx_set.include? array.index(item) }
  end
end
