require_relative 'shell_commands'

# Ruby shell
class Cmd
  extend ShellCommands

  def initialize(prompt = 'coral> ',
                 welcome = 'Welcome to the Coral shell.')
    @prompt = prompt
    @welcome = welcome
    @history_index = -1

    init_reader
  end

  def init_reader; end

  def loop_setup
    puts @welcome
  end

  def loop_finish; end

  def cmd_loop
    loop_setup

    add_hist_true = true
    while (input = Readline.readline(@prompt, add_hist_true))
      next if input == ''

      process_cmd
    end
    loop_finish
  end

  def process_cmd; end

  def handle_unknown_cmd; end

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

  def help_help; end
end
