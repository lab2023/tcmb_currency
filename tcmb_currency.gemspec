# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tcmb_currency/version'

Gem::Specification.new do |gem|
  gem.name          = "tcmb_currency"
  gem.version       = TcmbCurrency::VERSION
  gem.authors       = %w[lab2023]
  gem.email         = %w[info@lab2023.com]
  gem.description   = %q{Tcmb gem}
  gem.summary       = %q{Access the TCMB exchange rate data.}
  gem.homepage      = "https://github.com/lab2023/tcmb_currency"
  gem.required_rubygems_version = ">= 1.3.6"
  gem.add_dependency "yard", ">= 0.5.8"
  gem.add_dependency "json", ">= 1.4.0"
  gem.add_dependency "yajl-ruby", ">= 1.0.0"
  gem.add_dependency "ffi"
  gem.add_dependency "money"
  gem.add_dependency "money-rails"
  gem.add_dependency "nokogiri"
  gem.files         = `git ls-files`.split($/)
  gem.files 		=  Dir.glob("{lib}/**/*")
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]
end
