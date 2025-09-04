# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../lib/tago'

# Main test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
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
    assert_equal('10w', (t - (70 * 24 * 60 * 60)).ago(t))
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
    assert_equal('8w', (t + (56 * 24 * 60 * 60)).ago(t))
    assert_equal('22w1d', (t + (155 * 24 * 60 * 60)).ago(t))
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
    assert_equal('19w', ((132.6 * 24 * 60 * 60) + (23 * 60 * 60)).seconds)
  end
end
