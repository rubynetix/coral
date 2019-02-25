require 'method_source'

require_relative 'cmd'
require_relative 'commands/ls_command'
require_relative 'commands/mkdir_command'
require_relative 'commands/rm_command'
require_relative 'commands/mv_command'
require_relative 'commands/cp_command'
require_relative 'commands/cd_command'
require_relative 'commands/touch_command'
require_relative 'commands/date_command'
require_relative 'commands/cat_command'
require_relative 'commands/delay_command'
require_relative 'commands/clear_command'
require_relative 'commands/exit_command'

# Basic Commands for a Ruby Shell
module ShellCommands
  def get_cmd(command)
    self.class.instance_methods.select { |m| m.to_s.eql? 'do_' + command }[0]
  end

  def help_help
    puts docs 'help'
    self.class.instance_methods.each do |m|
      puts "\t" + m.to_s.gsub('do_', '') if m.to_s.start_with? 'do_'
    end
  end

  # Use <command> --help to get command use information
  def do_help(input_tokens = 'help')
    return help_help
  end

  def exec_as_child
    cmd_pid = fork do
      yield
      exit
    end

    Process.waitpid(cmd_pid)
  end

  def do_clear(input_tokens)
    ClearCommand.new(input_tokens).execute
  end

  def do_cd(input_tokens)
    CdCommand.new(input_tokens).execute
  end

  def do_exit(input_tokens);
    ExitCommand.new(input_tokens, Cmd.shell_pid).execute()
  end

  def do_ls(input_tokens)
    exec_as_child do
      LsCommand.new(input_tokens).execute
    end
  end

  def do_mv(input_tokens)
    exec_as_child do
      MvCommand.new(input_tokens).execute
    end
  end

  def do_cp(input_tokens)
    exec_as_child do
      CpCommand.new(input_tokens).execute
    end
  end

  def do_mkdir(input_tokens)
    exec_as_child do
      MkdirCommand.new(input_tokens).execute
    end
  end

  def do_rm(input_tokens)
    exec_as_child do
      RmCommand.new(input_tokens).execute
    end
  end

  def do_touch(input_tokens)
    exec_as_child do
      TouchCommand.new(input_tokens).execute
    end
  end

  def do_echo(input_tokens); end

  # Concatenate file(s) to standard output
  def do_cat(input_tokens)
    exec_as_child do
      CatCommand.new(input_tokens).execute
    end
  end

  # Display the local date and time (e.g. Sat Nov 04 12:02:33 EST 1989)
  def do_date(input_tokens)
    exec_as_child do
      DateCommand.new(input_tokens).execute
    end
  end

  def do_delay(input_tokens)
    DelayCommand.new(input_tokens).execute
  end

  def docs(command_name)
    return if command_name.nil?
    return if (command = get_cmd(command_name)).nil?

    comment = self.class.instance_method(command).comment
    return nil if comment == ''

    format_docs comment
  end

  def format_docs(comment)
    comment.gsub('# ', '').strip
  end
end
