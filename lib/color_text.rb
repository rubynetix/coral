class ColorText
  RED = 31
  GREEN = 32
  BLUE = 34

  class << self
    def green(text, bold: true)
      colorize(text, GREEN)
    end

    def blue(text, bold: true)
      colorize(text, BLUE)
    end

    def red(text, bold: true)
      colorize(text, RED)
    end

    private

    def colorize(text, color_code, bold: true)
      "\e[#{bold ? "1;" : ''}#{color_code}m#{text}\e[0m"
    end
  end
end