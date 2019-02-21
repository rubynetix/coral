require 'method_source'

require_relative 'commands/ls_command'
require_relative 'commands/mkdir_command'
require_relative 'commands/rm_command'
require_relative 'commands/mv_command'
require_relative 'commands/cp_command'
require_relative 'commands/touch_command'
require_relative 'commands/date_command'
require_relative 'commands/cat_command'

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

  # Use help <command> to get command use information
  def do_help(input_tokens = 'help')
    input_tokens = input_tokens.strip
    command = input_tokens.split(' ')[1]
    return help_help if (input_tokens.eql? 'help') || command.nil?

    cmd_docs = docs command
    if cmd_docs.nil?
      puts 'No docs for: ' + command
      cmd_docs = docs input_tokens.join(" ")
    end
    puts cmd_docs
  end

  def do_cd(input_tokens); end

  def do_exit(input_tokens); end

  def do_ls(input_tokens)
    LsCommand.new(input_tokens).execute
  end

  def do_mv(input_tokens)
    MvCommand.new(input_tokens).execute
  end

  def do_cp(input_tokens)
    CpCommand.new(input_tokens).execute
  end

  def do_mkdir(input_tokens)
    MkdirCommand.new(input_tokens).execute
  end

  def do_rm(input_tokens)
    RmCommand.new(input_tokens).execute
  end

  def do_touch(input_tokens)
    TouchCommand.new(input_tokens).execute
  end

  def do_echo(input_tokens); end

  # Concatenate file(s) to standard output
  def do_cat(input_tokens)
    CatCommand.new(input_tokens).execute
  end

  # Display the local date and time (e.g. Sat Nov 04 12:02:33 EST 1989)
  def do_date(input_tokens)
    DateCommand.new(input_tokens).execute
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
