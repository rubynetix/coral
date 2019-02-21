require_relative 'shell_commands'
require_relative 'color_text'
require 'readline'
require 'set'

# Ruby shell
class Cmd
  include ShellCommands

  def initialize(reader, welcome = 'Welcome to the Coral shell.')
    @welcome = welcome
    @reader = reader

    @original_stdout

    @reader.prepare
  end

  def loop_setup
    @original_stdout = $stdout.dup
    puts @welcome
  end

  def loop_finish; end

  def cmd_loop
    loop_setup

    while (input = @reader.read(prompt))
      next if input == ''

      process_input input
      $stdout = @original_stdout.dup
    end
    loop_finish
  end

  def process_input(input)
    input_tokens = input.split(' ')
    command = input_tokens[0]
    if input_tokens.include?(">")
      begin
      input = redirect_stdout(input_tokens)
      rescue IOError => e
        $stderr.print "#{e.message}\n"
        return
      end
    end

    if !(new_cmd = get_cmd command).nil?
      process_cmd new_cmd, input
    else
      handle_unknown_cmd command
    end
  end

  # Create child/worker process
  # Parent : wait for worker (child) to finish
  # Child: change job
  # Parent: report results
  def process_cmd(command, input)
    cmd_pid = fork do
      send command, input
      exit
    end

    Process.waitpid(cmd_pid)
  end


  def handle_unknown_cmd(input)
    puts 'Invalid command: ' + input
  end

  def redirect_stdout(input)
    arrow_idx = input.index(">")
    if arrow_idx + 1 >= input.length
      raise IOError, "Unexpected stdout redirection: nil"
    end

    outfile = input[arrow_idx + 1]
    if File.directory?(outfile)
      raise IOError, "Unexpected stdout redirection: #{outfile} is a directory"
    end

    $stdout = $stdout.reopen(outfile, "w")
    remove_array_indexes(input, Set[arrow_idx, arrow_idx+1]).join(" ")
  end

  def prompt
    ColorText::red("#{ENV['USER']}@coral") +
        ':' +
        ColorText::blue("#{Dir.pwd}") +
        '$ '
  end

  def remove_array_indexes(array, idx_set)
    array.reject{ |item| idx_set.include? array.index(item) }
  end
end
