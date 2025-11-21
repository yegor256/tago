# frozen_string_literal: true

module Locales
  # English words and unit names used for pretty formatting.
  module EN
    NUMBERS = {
      0 => 'zero',
      1 => 'one',
      2 => 'two',
      3 => 'three',
      4 => 'four',
      5 => 'five',
      6 => 'six',
      7 => 'seven',
      8 => 'eight',
      9 => 'nine',
      10 => 'ten'
    }.freeze

    UNITS = {
      microsecond: %w[microsecond microseconds],
      millisecond: %w[millisecond milliseconds],
      second: %w[second seconds],
      minute: %w[minute minutes],
      hour: %w[hour hours],
      day: %w[day days],
      week: %w[week weeks]
    }.freeze

    SHORT_UNITS = {
      microsecond: 'μs',
      millisecond: 'ms',
      second: 'sec',
      minute: 'min',
      hour: 'hr',
      day: 'd',
      week: 'wk'
    }.freeze

    module_function

    def number_to_words(value)
      return NUMBERS[value] if value <= 10

      value.to_s
    end

    def unit_name(unit_symbol, value, short: false)
      return SHORT_UNITS.fetch(unit_symbol) if short

      names = UNITS.fetch(unit_symbol)
      value == 1 ? names[0] : names[1]
    end
  end
end
