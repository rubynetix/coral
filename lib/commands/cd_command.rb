class CdCommand
  include BaseCommand

  def initialize(args)
    @opts = Slop.parse args do |o|
    end

    @opts.arguments.shift
    @dir = !@opts.arguments.empty? ? @opts.arguments[0] : '~'
  end

  def execute
    begin
      Dir.chdir(File.expand_path(@dir))
    rescue SystemCallError => e
      $stderr.print "#{e.message}\n"
    end
  end
end
