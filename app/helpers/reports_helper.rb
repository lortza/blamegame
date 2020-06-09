# frozen_string_literal: true

module ReportsHelper
  def styler(number)
    "line-height: 50px; font-size: #{sizer(number)}px; opacity: #{opacitizer(number)};"
  end

  def sizer(number)
    number += 2
    return 250 if number > 250
    return 5 if number <= 5

    number
  end

  def opacitizer(number)
    rand(0.1..0.7) if number >= 30
  end
end
