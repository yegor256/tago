# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'time'

# Helper module for time formatting.
module TimeFormatter
  NUMBERS = {
    0 => 'zero', 1 => 'one', 2 => 'two', 3 => 'three', 4 => 'four',
    5 => 'five', 6 => 'six', 7 => 'seven', 8 => 'eight', 9 => 'nine', 10 => 'ten'
  }.freeze

  SHORT_UNITS = {
    microsecond: 'μs', millisecond: 'ms', second: 'sec', minute: 'min',
    hour: 'hr', day: 'd', week: 'wk'
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

  def calculate_time_unit(sec)
    if sec < 0.001
      [(sec * 1_000_000).to_i, :microsecond]
    elsif sec < 1
      [(sec * 1000).to_i, :millisecond]
    elsif sec < 60
      [sec.to_i, :second]
    elsif sec < 60 * 60
      [(sec / 60).to_i, :minute]
    elsif sec < 24 * 60 * 60
      [(sec / (60 * 60)).to_i, :hour]
    elsif sec < 7 * 24 * 60 * 60
      [(sec / (24 * 60 * 60)).to_i, :day]
    else
      [(sec / (7 * 24 * 60 * 60)).to_i, :week]
    end
  end
end

# A new method to print time as text.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
class Float
  def seconds(*args)
    s = self
    s = -s if s.negative?
    if args.include?(:pretty)
      val, unit = TimeFormatter.calculate_time_unit(s)
      short = args.include?(:short)
      num = short ? val : TimeFormatter.number_to_words(val)
      unit_name = TimeFormatter.unit_name(unit, val, short:)
      return format('%<num>s %<unit_name>s', num:, unit_name:)
    end

    if s < 0.001
      format('%dμs', s * 1000 * 1000)
    elsif s < 1
      format('%dms', s * 1000)
    elsif s < 10
      ms = (s * 1000 % 1000).to_i
      if args.include?(:round) || args.include?(:short) || ms.zero?
        format('%ds', s)
      else
        format('%<s>ds%<ms>dms', s:, ms:)
      end
    elsif s < 100
      format('%ds', s)
    elsif s < 60 * 60
      mins = (s / 60).to_i
      secs = (s % 60).to_i
      if args.include?(:round) || args.include?(:short) || secs.zero?
        format('%dm', mins)
      else
        format('%<mins>dm%<secs>ds', mins:, secs:)
      end
    elsif s < 24 * 60 * 60
      hours = (s / (60 * 60)).to_i
      mins = ((s % (60 * 60)) / 60).to_i
      if args.include?(:round) || args.include?(:short) || mins.zero?
        format('%dh', hours)
      else
        format('%<hours>dh%<mins>dm', hours:, mins:)
      end
    elsif s < 7 * 24 * 60 * 60
      days = (s / (24 * 60 * 60)).to_i
      hours = ((s % (24 * 60 * 60)) / (60 * 60)).to_i
      if args.include?(:round) || args.include?(:short) || hours.zero?
        format('%dd', days)
      else
        format('%<days>dd%<hours>dh', days:, hours:)
      end
    else
      weeks = (s / (7 * 24 * 60 * 60)).to_i
      days = (s / (24 * 60 * 60) % 7).to_i
      if args.include?(:round) || args.include?(:short) || days.zero?
        format('%dw', weeks)
      else
        format('%<weeks>dw%<days>dd', weeks:, days:)
      end
    end
  end
end

# A new method to print time as text.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
class Time
  def ago(arg = Time.now, *options)
    if arg.is_a?(Time)
      now = arg
    else
      now = Time.now
      options = [arg] + options
    end
    (now - self).seconds(*options)
  end
end
