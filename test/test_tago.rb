# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../lib/tago'

# Main test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class TestTago < Minitest::Test
  def test_simple_printing
    t = Time.now
    assert_equal('14ms', (t - 0.014).ago(t))
    assert_equal('1s350ms', (t - 1.35).ago(t))
    assert_equal('2s', (t - 2).ago(t))
    assert_equal('67s', (t - 67).ago(t))
    assert_equal('4m5s', (t - 245).ago(t))
    assert_equal('6m', (t - 360).ago(t))
    assert_equal('13h18m', (t - (13.3 * 60 * 60)).ago(t))
    assert_equal('16h', (t - (16 * 60 * 60)).ago(t))
    assert_equal('5d7h', (t - (5.3 * 24 * 60 * 60)).ago(t))
    assert_equal('6d', (t - (6 * 24 * 60 * 60)).ago(t))
    assert_equal('2w1d', (t - (15 * 24 * 60 * 60)).ago(t))
    assert_equal('2mo2w', (t - (75 * 24 * 60 * 60)).ago(t))
    assert_equal('6mo', (t - (180 * 24 * 60 * 60)).ago(t))
    assert_equal('1y2mo', (t - (425 * 24 * 60 * 60)).ago(t))
    assert_equal('7y3mo', (t - (10 * 265 * 24 * 60 * 60)).ago(t))
    assert_equal('10y', (t - (10 * 365 * 24 * 60 * 60)).ago(t))
    assert_equal('10y3mo', (t - ((10 * 365 * 24 * 60 * 60) + (90 * 24 * 60 * 60))).ago(t))
  end

  def test_inverse
    t = Time.now
    assert_equal('14ms', (t + 0.014).ago(t))
    assert_equal('1s', (t + 1).ago(t))
    assert_equal('3s250ms', (t + 3.25).ago(t))
    assert_equal('67s', (t + 67).ago(t))
    assert_equal('2m', (t + 120).ago(t))
    assert_equal('4m51s', (t + 291).ago(t))
    assert_equal('13h', (t + (13 * 60 * 60)).ago(t))
    assert_equal('19h42m', (t + (19.7 * 60 * 60)).ago(t))
    assert_equal('5d', (t + (5 * 24 * 60 * 60)).ago(t))
    assert_equal('6d23h', (t + (6 * 24 * 60 * 60) + (23 * 60 * 60)).ago(t))
    assert_equal('1w', (t + (7 * 24 * 60 * 60)).ago(t))
    assert_equal('3w2d', (t + (23 * 24 * 60 * 60)).ago(t))
    assert_equal('5mo2w', (t + (165 * 24 * 60 * 60)).ago(t))
    assert_equal('11mo', (t + (330 * 24 * 60 * 60)).ago(t))
    assert_equal('2y1mo', (t + (760 * 24 * 60 * 60)).ago(t))
    assert_equal('5y', (t + (5 * 365 * 24 * 60 * 60)).ago(t))
  end

  def test_float_to_seconds
    assert_equal('18ms', 0.018.seconds)
    assert_equal('2s330ms', 2.33.seconds)
    assert_equal('4s', 4.0.seconds)
    assert_equal('69s', 69.17.seconds)
    assert_equal('3m4s', 184.2.seconds)
    assert_equal('7m', 420.0.seconds)
    assert_equal('12h6m', (12.1 * 60 * 60).seconds)
    assert_equal('20h', (20.001 * 60 * 60).seconds)
    assert_equal('5d7h', (5.3 * 24 * 60 * 60).seconds)
    assert_equal('6d', (6.0 * 24 * 60 * 60).seconds)
    assert_equal('2w1d', (15.5 * 24 * 60 * 60).seconds)
    assert_equal('4w', (28.0 * 24 * 60 * 60).seconds)
    assert_equal('3mo', (95.0 * 24 * 60 * 60).seconds)
    assert_equal('9mo', (270.0 * 24 * 60 * 60).seconds)
    assert_equal('1y3mo', (455.0 * 24 * 60 * 60).seconds)
    assert_equal('20y', (20.0 * 365 * 24 * 60 * 60).seconds)
    assert_equal('3y4mo', ((3.0 * 365 * 24 * 60 * 60) + (120 * 24 * 60 * 60)).seconds)
  end

  def test_round_formatting
    # Milliseconds range (< 1s)
    assert_equal('500ms', 0.5.seconds(:round))

    # Seconds with milliseconds (< 10s)
    assert_equal('9s', 9.444.seconds(:round))
    assert_equal('9s444ms', 9.444.seconds)

    # Seconds (10-100s)
    assert_equal('45s', 45.5.seconds(:round))

    # Minutes and seconds
    assert_equal('3m', 184.0.seconds(:round))
    assert_equal('3m4s', 184.0.seconds)

    # Hours and minutes
    assert_equal('1h', 3661.0.seconds(:round))
    assert_equal('1h1m', 3661.0.seconds)

    # Days and hours
    assert_equal('1d', 90_000.0.seconds(:round))
    assert_equal('1d1h', 90_000.0.seconds)

    # Weeks and days
    assert_equal('1w', 691_200.0.seconds(:round))
    assert_equal('1w1d', 691_200.0.seconds)

    # Months and weeks
    assert_equal('3mo', (100.0 * 24 * 60 * 60).seconds(:round))
    assert_equal('3mo1w', (100.0 * 24 * 60 * 60).seconds)

    # Years and months
    assert_equal('2y', (730.0 * 24 * 60 * 60).seconds(:round))
    assert_equal('3y', (1095.0 * 24 * 60 * 60).seconds)

    # Edge case: exact boundaries
    assert_equal('1h', 3600.0.seconds(:round))
    assert_equal('1d', 86_400.0.seconds(:round))
    assert_equal('1w', 604_800.0.seconds(:round))
    assert_equal('1mo', (30.0 * 24 * 60 * 60).seconds(:round))
    assert_equal('1y', (365.0 * 24 * 60 * 60).seconds(:round))
  end

  def test_pretty_formatting
    t = Time.now
    assert_equal('45 seconds', (t - 45.6).ago(:pretty))
    five_weeks_three_days = (5.0 * 7 * 24 * 60 * 60) + (3.0 * 24 * 60 * 60)
    assert_equal('one month', (t - five_weeks_three_days).ago(:pretty))
    assert_equal('45 seconds', 45.6.seconds(:pretty))
    assert_equal('six months', (180.0 * 24 * 60 * 60).seconds(:pretty))
    assert_equal('one year', (455.0 * 24 * 60 * 60).seconds(:pretty))
    assert_equal('ten years', (10.0 * 365 * 24 * 60 * 60).seconds(:pretty))
    assert_equal('ten years', ((10.0 * 365 * 24 * 60 * 60) + (90 * 24 * 60 * 60)).seconds(:pretty))
    assert_equal('three years', ((3.0 * 365 * 24 * 60 * 60) + (120 * 24 * 60 * 60)).seconds(:pretty))
  end

  def test_short_formatting
    t = Time.now
    assert_equal('5m', (t - 300).ago(:short))
    assert_equal('5m', 300.0.seconds(:short))
    assert_equal('1h', 3600.0.seconds(:short))
    assert_equal('3mo', (95.0 * 24 * 60 * 60).seconds(:short))
    assert_equal('2y', (800.0 * 24 * 60 * 60).seconds(:short))
    assert_equal('10y', ((10.0 * 365 * 24 * 60 * 60) + (90 * 24 * 60 * 60)).seconds(:short))
  end

  def test_pretty_short_formatting
    t = Time.now
    assert_equal('5 min', (t - 300).ago(:pretty, :short))
    assert_equal('5 min', 300.0.seconds(:pretty, :short))
    assert_equal('1 hr', 3600.0.seconds(:pretty, :short))
    assert_equal('6 mo', (180.0 * 24 * 60 * 60).seconds(:pretty, :short))
    assert_equal('1 y', (455.0 * 24 * 60 * 60).seconds(:pretty, :short))
    assert_equal('5 y', (5.0 * 365 * 24 * 60 * 60).seconds(:pretty, :short))
    assert_equal('10 y', ((10.0 * 365 * 24 * 60 * 60) + (90 * 24 * 60 * 60)).seconds(:pretty, :short))
  end

  def test_ago_with_time_and_flags
    t = Time.now
    assert_equal('5 min', (t - 300).ago(t, :pretty, :short))
    assert_equal('5m', (t - 300).ago(t, :short))
  end

  def test_caps_formatting
    t = Time.now
    assert_equal('Five seconds', (t - 5).ago(:pretty, :caps))
    assert_equal('Three minutes', 180.0.seconds(:pretty, :caps))
    assert_equal('Two hours', (t - 7200).ago(:pretty, :caps))
    assert_equal('Six months', (180.0 * 24 * 60 * 60).seconds(:pretty, :caps))
    assert_equal('One year', (455.0 * 24 * 60 * 60).seconds(:pretty, :caps))
    assert_equal('Ten years', ((10.0 * 365 * 24 * 60 * 60) + (90 * 24 * 60 * 60)).seconds(:pretty, :caps))
  end

  def test_caps_with_short
    assert_equal('5 sec', 5.0.seconds(:pretty, :short, :caps))
    assert_equal('3 min', 180.0.seconds(:pretty, :short, :caps))
    assert_equal('6 mo', (180.0 * 24 * 60 * 60).seconds(:pretty, :short, :caps))
    assert_equal('1 y', (455.0 * 24 * 60 * 60).seconds(:pretty, :short, :caps))
  end

  def test_caps_with_time_parameter
    t = Time.now
    assert_equal('Five seconds', (t - 5).ago(t, :pretty, :caps))
    assert_equal('Three minutes', (t - 180).ago(t, :pretty, :caps))
  end
end
