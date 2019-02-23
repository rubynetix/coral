class ClearCommand
  include BaseCommand
  def initialize(args)
  end

  def execute
    # ANSI sequence wont work with RubyMine console but will work with others (eg Ubuntu Terminal)
    puts "\e[H\e[2J"
  end
end
