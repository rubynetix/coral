class NotEnoughArgumentsError < StandardError
end

module BaseCommand
  def parse_default_opts(input)
    args = split_args input
    opts = Slop.parse args do |o|
      o.bool '-h', '--help'
    end

    opts.arguments.shift
    opts
  end

  def split_args(input)
    input.strip.split(' ')
  end

  def term_columns
    ENV['COLUMNS'].to_i
  end
end
