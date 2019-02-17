class NotEnoughArgumentsError < StandardError
end

module BaseCommand
  def split_args(input)
    input.strip.split(' ')
  end
end