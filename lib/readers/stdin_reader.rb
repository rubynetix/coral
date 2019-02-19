class StdinReader

  def initialize
    @history_index = -1
  end

  def prepare
    set_autocomplete
  end

  def read(prompt)
    Readline.readline(prompt, add_hist: true)
  end

  private

  def prev_hist
    return unless @history_index.positive?

    while Readline::HISTORY[@history_index].to_s == ""
      @history_index -= 1
    end

    puts Readline::HISTORY[@history_index].to_s
    @history_index -= 1
  end

  def next_hist
    return unless @history_index < Readline::HISTORY.size

    while Readline::HISTORY[@history_index].to_s == ""
      @history_index += 1
    end

    puts Readline::HISTORY[@history_index].to_s
    @history_index += 1
  end

  def set_autocomplete
    comp = proc { |s| Dir.entries('.').grep(/^#{Regexp.escape(s)}/) }

    Readline.completion_append_character = ' '
    Readline.completion_proc = comp
  end
end