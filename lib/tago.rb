# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'time'
require_relative 'locales/en'

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
      short = args.include?(:short)
      num = short ? val : Locales::EN.number_to_words(val)
      unit_name = Locales::EN.unit_name(unit, val, short:)
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
