require 'time'
require_relative 'base_command'

class DateCommand
  include BaseCommand

  USAGE = <<~EOS
    Usage: date
      Displays the date in the format (Day Month DD HH:MM:SS Timezone YYYY)

    [options]
  EOS

  def initialize(input)
    @opts = parse_default_opts(input)
    @opts.options.banner = USAGE
  end

  def execute
    if @opts.help?
      puts @opts.to_s(prefix: "  ")
      return
    end

    puts Time.now.strftime('%a %b %d %T %Z %Y')
  end
end