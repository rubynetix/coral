require 'method_source'
# Basic Commands for a Ruby Shell
module ShellCommands
  def get_cmd(command)
    self.class.instance_methods.select { |m| m.to_s.eql? 'do_' + command }[0]
  end

  def help_help; end

  # Test method source
  def do_help(input = 'help')
    input = input.strip
    command = input.split(' ')[1]
    return puts docs input if (input.eql? 'help') || command.nil?

    cmd_docs = docs command
    if cmd_docs.nil?
      puts 'No docs for: ' + command
      cmd_docs = docs input
    end
    puts cmd_docs
  end

  def do_cd(input); end

  def do_exit(input); end

  def do_ls(input); end

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
