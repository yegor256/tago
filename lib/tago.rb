# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'time'

# A new method to print time as text.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class Float
  def seconds(*args)
    s = self
    s = -s if s.negative?
    if args.include?(:pretty)
      locales = {
        en: {
          numbers: {
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
          },
          units: {
            microsecond: %w[microsecond microseconds],
            millisecond: %w[millisecond milliseconds],
            second: %w[second seconds],
            minute: %w[minute minutes],
            hour: %w[hour hours],
            day: %w[day days],
            week: %w[week weeks],
            month: %w[month months],
            year: %w[year years]
          },
          short_units: {
            microsecond: 'μs',
            millisecond: 'ms',
            second: 'sec',
            minute: 'min',
            hour: 'hr',
            day: 'd',
            week: 'wk',
            month: 'mo',
            year: 'y'
          }
        }
      }.freeze
      if s < 0.001
        val = Integer(s * 1_000_000)
        unit = :microsecond
      elsif s < 1
        val = Integer(s * 1000)
        unit = :millisecond
      elsif s < 60
        val = Integer(s)
        unit = :second
      elsif s < 60 * 60
        val = Integer(s / 60)
        unit = :minute
      elsif s < 24 * 60 * 60
        val = Integer(s / (60 * 60))
        unit = :hour
      elsif s < 7 * 24 * 60 * 60
        val = Integer(s / (24 * 60 * 60))
        unit = :day
      elsif s < 30 * 24 * 60 * 60
        val = Integer(s / (7 * 24 * 60 * 60))
        unit = :week
      elsif s < 365 * 24 * 60 * 60
        val = Integer(s / (30 * 24 * 60 * 60))
        unit = :month
      else
        val = Integer(s / (365 * 24 * 60 * 60))
        unit = :year
      end
      short = args.include?(:short)
      word = val <= 10 ? locales[:en][:numbers][val] : val.to_s
      names = locales[:en][:units][unit]
      symbol = val == 1 ? names[0] : names[1]
      text = format(
        '%<num>s %<tag>s',
        num: short ? val : word,
        tag: short ? locales[:en][:short_units][unit] : symbol
      )
      return args.include?(:caps) ? text.capitalize : text
    end
    if s < 0.001
      format('%dμs', s * 1000 * 1000)
    elsif s < 1
      format('%dms', s * 1000)
    elsif s < 10
      ms = Integer(s * 1000 % 1000)
      if args.include?(:round) || args.include?(:short) || ms.zero?
        format('%ds', s)
      else
        format('%<s>ds%<ms>dms', s:, ms:)
      end
    elsif s < 100
      format('%ds', s)
    elsif s < 60 * 60
      mins = Integer(s / 60)
      secs = Integer(s % 60)
      if args.include?(:round) || args.include?(:short) || secs.zero?
        format('%dm', mins)
      else
        format('%<mins>dm%<secs>ds', mins:, secs:)
      end
    elsif s < 24 * 60 * 60
      hours = Integer(s / (60 * 60))
      mins = Integer((s % (60 * 60)) / 60)
      if args.include?(:round) || args.include?(:short) || mins.zero?
        format('%dh', hours)
      else
        format('%<hours>dh%<mins>dm', hours:, mins:)
      end
    elsif s < 7 * 24 * 60 * 60
      days = Integer(s / (24 * 60 * 60))
      hours = Integer((s % (24 * 60 * 60)) / (60 * 60))
      if args.include?(:round) || args.include?(:short) || hours.zero?
        format('%dd', days)
      else
        format('%<days>dd%<hours>dh', days:, hours:)
      end
    elsif s < 30 * 24 * 60 * 60
      weeks = Integer(s / (7 * 24 * 60 * 60))
      days = Integer(s / (24 * 60 * 60) % 7)
      if args.include?(:round) || args.include?(:short) || days.zero?
        format('%dw', weeks)
      else
        format('%<weeks>dw%<days>dd', weeks:, days:)
      end
    elsif s < 365 * 24 * 60 * 60
      months = Integer(s / (30 * 24 * 60 * 60))
      weeks = Integer((s % (30 * 24 * 60 * 60)) / (7 * 24 * 60 * 60))
      if args.include?(:round) || args.include?(:short) || weeks.zero?
        format('%dmo', months)
      else
        format('%<months>dmo%<weeks>dw', months:, weeks:)
      end
    else
      years = Integer(s / (365 * 24 * 60 * 60))
      months = Integer((s % (365 * 24 * 60 * 60)) / (30 * 24 * 60 * 60))
      if args.include?(:round) || args.include?(:short) || months.zero?
        format('%dy', years)
      else
        format('%<years>dy%<months>dmo', years:, months:)
      end
    end
  end
end

# A new method to print time as text.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
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
