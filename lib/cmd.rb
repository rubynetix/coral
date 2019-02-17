require_relative 'shell_commands'
require_relative 'color_text'
require 'readline'

# Ruby shell
class Cmd
  include ShellCommands

  def initialize(reader, welcome = 'Welcome to the Coral shell.')
    @welcome = welcome
    @reader = reader

    @reader.prepare
  end

  def loop_setup
    puts @welcome
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
    command = input.split(' ')[0]
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

  def prompt
    ColorText::red("#{ENV['USER']}@coral") +
        ':' +
        ColorText::blue("#{Dir.pwd}") +
        '$ '
  end
end
