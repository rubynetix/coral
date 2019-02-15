require_relative 'shell_commands'
require 'readline'

# Ruby shell
class Cmd
  include ShellCommands

  def initialize(prompt = 'coral> ',
                 welcome = 'Welcome to the Coral shell.')
    @prompt = prompt
    @welcome = welcome
    @history_index = -1

    init_reader
  end

  def init_reader
    set_autocomplete
  end

  def loop_setup
    puts @welcome
  end

  def loop_finish; end

  def cmd_loop
    loop_setup

    add_hist_true = true
    while (input = Readline.readline(@prompt, add_hist_true))
      next if input == ''

      command = input.split(' ')[0]

      if !(new_cmd = get_cmd command).nil?
        process_cmd new_cmd, input
      else
        handle_unknown_cmd command
      end

    end
    loop_finish
  end

  # Create child/worker process
  # Parent : wait for worker (child) to finish
  # Child: change job
  # Parent: report results
  def process_cmd(command, input)
    send command
  end

  def handle_unknown_cmd(input)
    puts 'Invalid command: ' + input
  end

  def prev_hist
    return unless @history_index.positive?

    puts Readline::HISTORY[@history_index].to_s
    @history_index -= 1
  end

  def next_hist
    return unless @history_index < Readline::HISTORY.size

    puts Readline::HISTORY[@history_index].to_s
    @history_index += 1
  end

  def set_autocomplete
    comp = proc { |s| Dir.entries('.').grep(/^#{Regexp.escape(s)}/) }

    Readline.completion_append_character = ' '
    Readline.completion_proc = comp
  end
end
