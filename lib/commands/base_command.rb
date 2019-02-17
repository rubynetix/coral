class NotEnoughArgumentsError < StandardError
end

module BaseCommand
  def split_args(input)
    input.strip.split(' ')
  end

  def term_columns
    ENV['COLUMNS'].to_i
  end
end