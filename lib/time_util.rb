require_relative 'timer/ctimer'

class TimeUtil
  FLICKS_PER_SECOND = 705_600_000
  NANOS_PER_SECOND = 1_000_000_000

  class << self
    def delay_ns(ns)
      Ctimer::delay(ns / NANOS_PER_SECOND, ns % NANOS_PER_SECOND)
    end

    def delay_seconds(s)
      delay_ns(s * NANOS_PER_SECOND)
    end

    def delay_flicks(fs)
      delay_ns(fs * NANOS_PER_SECOND / FLICKS_PER_SECOND)
    end
  end
end
