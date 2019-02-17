require 'method_source'

require_relative 'commands/ls_command'

# Basic Commands for a Ruby Shell
module ShellCommands
  def get_cmd(command)
    self.class.instance_methods.select { |m| m.to_s.eql? 'do_' + command }[0]
  end

  def help_help
    puts docs 'help'
    puts 'Available commands are:'
    self.class.instance_methods.each do |m|
      puts "\t" + m.to_s.gsub('do_', '') if m.to_s.start_with? 'do_'
    end
  end

  # Use help <command> to get command use information
  def do_help(input = 'help')
    input = input.strip
    command = input.split(' ')[1]
    return help_help if (input.eql? 'help') || command.nil?

    cmd_docs = docs command
    if cmd_docs.nil?
      puts 'No docs for: ' + command
      cmd_docs = docs input
    end
    puts cmd_docs
  end

  def do_cd(input); end

  def do_exit(input); end

  def do_ls(input)
    LsCommand.new(input).execute
  end

  def do_mv(input); end

  def do_rm(input); end

  def do_mkdir(input); end

  def do_touch(input); end

  def do_echo(input); end

  def do_cat(input); end

  def do_date(input); end

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
