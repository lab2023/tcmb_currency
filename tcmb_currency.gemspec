# frozen_string_literal: true

# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tcmb_currency/version'

Gem::Specification.new do |gem|
  gem.name          = 'tcmb_currency'
  gem.version       = TcmbCurrency::VERSION
  gem.authors       = %w[lab2023]
  gem.email         = %w[info@lab2023.com]
  gem.description   = 'TCMB gem'
  gem.summary       = 'Access the TCMB exchange rate data.'
  gem.homepage      = 'https://github.com/lab2023/tcmb_currency'
  gem.licenses      = ['MIT']
  gem.required_ruby_version = '>= 2.0'
  gem.required_rubygems_version = '>= 1.3.6'
  gem.add_dependency 'ffi'
  gem.add_dependency 'json', '>= 1.4.0'
  gem.add_dependency 'money', '~> 6.7.1'
  gem.add_dependency 'money-rails', '~> 1.7'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'yajl-ruby', '>= 1.0.0'
  gem.add_dependency 'yard', '>= 0.5.8'
  gem.files = Dir.glob('{lib}/**/*')
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.require_paths = ['lib']
end
