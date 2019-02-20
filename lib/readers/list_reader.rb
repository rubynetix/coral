class ListReader
  def initialize(cmd_list)
    @cmds = cmd_list
    @cmd_idx = 0
  end

  def prepare; end

  def read(_)
    @cmd_idx += 1
    @cmds[@cmd_idx - 1] unless @cmd_idx > @cmds.length
  end
end
