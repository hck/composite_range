# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Hck"]
  gem.homepage      = "http://github.com/hck/composite_range"
  gem.description   = %q{CompositeRange class allows you to work with few ranges in one container}
  gem.summary       = %q{Simple composite ranges}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "composite_range"
  gem.require_paths = ["lib"]
  gem.version       = '0.1'
end
