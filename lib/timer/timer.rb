require_relative 'ext/ctimer'

module Timer
  extend self

  def delay(nanoseconds, msg = "Timer Expired!")
    return unless valid_input?(nanoseconds, msg)

    child = Process.fork do
      Ctimer::delay(nanoseconds)
      puts msg
      exit
    end

    Process.detach(child)
  end

  def valid_input?(nanoseconds, msg)
    # TODO: Validate inputs with regexp
    true
  end
end
