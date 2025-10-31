# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'time'

# A new method to print time as text.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
class Float
  def seconds(format = nil)
    s = self
    s = -s if s.negative?
    if format == :pretty
      locales = {
        en: {
          numbers: { 0 => 'zero', 1 => 'one', 2 => 'two', 3 => 'three', 4 => 'four', 5 => 'five', 6 => 'six',
                     7 => 'seven', 8 => 'eight', 9 => 'nine', 10 => 'ten' },
          units: { microsecond: %w[microsecond microseconds], millisecond: %w[millisecond milliseconds],
                   second: %w[second seconds], minute: %w[minute minutes], hour: %w[hour hours], day: %w[day days],
                   week: %w[week weeks] }
        }
      }.freeze

      if s < 0.001
        val = (s * 1_000_000).to_i
        unit = :microsecond
      elsif s < 1
        val = (s * 1000).to_i
        unit = :millisecond
      elsif s < 60
        val = s.to_i
        unit = :second
      elsif s < 60 * 60
        val = (s / 60).to_i
        unit = :minute
      elsif s < 24 * 60 * 60
        val = (s / (60 * 60)).to_i
        unit = :hour
      elsif s < 7 * 24 * 60 * 60
        val = (s / (24 * 60 * 60)).to_i
        unit = :day
      else
        val = (s / (7 * 24 * 60 * 60)).to_i
        unit = :week
      end

      num = val < 10 ? locales[:en][:numbers][val] : val.to_s
      names = locales[:en][:units].fetch(unit)
      unit_name = val == 1 ? names[0] : names[1]
      return format('%<num>s %<unit_name>s', num:, unit_name:)
    end

    if s < 0.001
      format('%dμs', s * 1000 * 1000)
    elsif s < 1
      format('%dms', s * 1000)
    elsif s < 10
      ms = (s * 1000 % 1000).to_i
      if format == :round || ms.zero?
        format('%ds', s)
      else
        format('%<s>ds%<ms>dms', s:, ms:)
      end
    elsif s < 100
      format('%ds', s)
    elsif s < 60 * 60
      mins = (s / 60).to_i
      secs = (s % 60).to_i
      if format == :round || secs.zero?
        format('%dm', mins)
      else
        format('%<mins>dm%<secs>ds', mins:, secs:)
      end
    elsif s < 24 * 60 * 60
      hours = (s / (60 * 60)).to_i
      mins = ((s % (60 * 60)) / 60).to_i
      if format == :round || mins.zero?
        format('%dh', hours)
      else
        format('%<hours>dh%<mins>dm', hours:, mins:)
      end
    elsif s < 7 * 24 * 60 * 60
      days = (s / (24 * 60 * 60)).to_i
      hours = ((s % (24 * 60 * 60)) / (60 * 60)).to_i
      if format == :round || hours.zero?
        format('%dd', days)
      else
        format('%<days>dd%<hours>dh', days:, hours:)
      end
    else
      weeks = (s / (7 * 24 * 60 * 60)).to_i
      days = (s / (24 * 60 * 60) % 7).to_i
      if format == :round || days.zero?
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
  def ago(arg = Time.now, pretty = nil)
    if arg.is_a?(Symbol) || arg.nil?
      format = arg
      now = pretty || Time.now
    else
      now = arg
      format = pretty
    end

    (now - self).seconds(format)
  end
end
