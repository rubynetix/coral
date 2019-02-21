class NotEnoughArgumentsError < StandardError
end

module BaseCommand

  def parse_default_opts(args)
    opts = Slop.parse args do |o|
      o.bool '-h', '--help'
    end

    opts.arguments.shift
    opts
  end

  def term_columns
    ENV['COLUMNS'].to_i
  end
end
