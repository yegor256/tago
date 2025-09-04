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
  def seconds
    s = self
    s = -s if s.negative?
    if s < 0.001
      format('%dμs', s * 1000 * 1000)
    elsif s < 1
      format('%dms', s * 1000)
    elsif s < 10
      ms = format('%03d', s * 1000 % 1000)
      if ms == '000'
        format('%ds', s)
      else
        format('%<sec>ds%<msec>sms', sec: s, msec: ms)
      end
    elsif s < 100
      format('%ds', s)
    elsif s < 60 * 60
      format('%<mins>dm%<secs>ds', mins: s / 60, secs: s % 60)
    elsif s < 24 * 60 * 60
      format('%<hours>dh%<mins>dm', hours: s / (60 * 60), mins: (s % (60 * 60)) / 60)
    elsif s < 7 * 24 * 60 * 60
      format('%<days>dd%<hours>dh', days: s / (24 * 60 * 60), hours: (s % (24 * 60 * 60)) / (60 * 60))
    else
      weeks = s / (7 * 24 * 60 * 60)
      days = s / (24 * 60 * 60) % 7
      days.to_i.zero? ? format('%dw', weeks) : format('%<weeks>dw%<days>dd', weeks:, days:)
    end
  end
end

# A new method to print time as text.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
class Time
  def ago(now = Time.now)
    (now - self).seconds
  end
end
