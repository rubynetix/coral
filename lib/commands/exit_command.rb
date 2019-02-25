class ExitCommand
  include BaseCommand

  def initialize(args, shell_pid)
    @shell_pid = shell_pid
  end

  def execute
    Process.kill('TERM', @shell_pid)
  end
end
