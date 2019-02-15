require 'method_source'
# Basic Commands for a Ruby Shell
module ShellCommands

  def get_cmd(command)
    self.class.instance_methods.select { |m| m.to_s.eql? 'do_' + command }[0]
  end

  def help_help; end

  # Test method source
  def do_help
    puts (docs 'help')
    puts (docs 'cd')
  end

  def do_cd; end

  def do_exit; end

  def do_ls; end

  def do_mv; end

  def do_rm; end

  def do_mkdir; end

  def do_touch; end

  def do_echo; end

  def do_cat; end

  def do_date; end

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
