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

      input = input.split(' ')

      if !(new_cmd = get_cmd input[0]).nil?
        process_cmd new_cmd, (input.slice 1, -1)
      else
        handle_unknown_cmd input[0]
      end

    end
    loop_finish
  end

  def get_cmd(command)
    self.class.instance_methods.select { |m| m.to_s.eql? 'do_' + command }[0]
  end

  # Create child/worker process
  # Parent : wait for worker (child) to finish
  # Child: change job
  # Parent: report results
  def process_cmd(command, *args)
    send command, args
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

    Readline.completion_append_character = "\t"
    Readline.completion_proc = comp
  end
end
