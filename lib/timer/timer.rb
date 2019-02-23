require_relative 'ext/ctimer'

module Timer
  extend self

  def countdown(nanoseconds, msg)
    return unless valid_input?(nanoseconds, msg)

    child = Process.fork do
      Ctimer::countdown(nanoseconds, msg)
      exit
    end

    Process.detach(child)
  end

  def valid_input?(nanoseconds, msg)
    # TODO: Validate inputs with regexp
    true
  end
end