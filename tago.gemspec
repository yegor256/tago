# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'English'
require_relative 'lib/tago'

Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.required_ruby_version = '>=3.0'
  s.name = 'tago'
  s.version = '0.0.0'
  s.license = 'MIT'
  s.summary = 'A new .ago() method for the Time class'
  s.description =
    'This simple gem adds a new supplementary method .ago() to ' \
    'the existing class Time, thus making logging more convenient'
  s.authors = ['Yegor Bugayenko']
  s.email = 'yegor256@gmail.com'
  s.homepage = 'https://github.com/yegor256/tago.rb'
  s.files = `git ls-files`.split($RS)
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = ['README.md', 'LICENSE.txt']
  s.metadata['rubygems_mfa_required'] = 'true'
end
