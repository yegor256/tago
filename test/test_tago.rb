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
    assert_equal('1s', (t - 1).ago(t))
    assert_equal('1s350ms', (t - 1.35).ago(t))
    assert_equal('67s', (t - 67).ago(t))
    assert_equal('4m5s', (t - 245).ago(t))
    assert_equal('13h18m', (t - (13.3 * 60 * 60)).ago(t))
    assert_equal('5d0h', (t - (5 * 24 * 60 * 60)).ago(t))
    assert_equal('5d7h', (t - (5.3 * 24 * 60 * 60)).ago(t))
    assert_equal('22w1d', (t - (155 * 24 * 60 * 60)).ago(t))
  end

  def test_inverse
    t = Time.now
    assert_equal('14ms', (t + 0.014).ago(t))
    assert_equal('1s', (t + 1).ago(t))
    assert_equal('67s', (t + 67).ago(t))
    assert_equal('13h0m', (t + (13 * 60 * 60)).ago(t))
    assert_equal('5d0h', (t + (5 * 24 * 60 * 60)).ago(t))
    assert_equal('22w1d', (t + (155 * 24 * 60 * 60)).ago(t))
  end
end
