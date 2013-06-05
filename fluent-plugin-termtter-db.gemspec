Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-termtter-db"
  gem.version       = "0.0.1"
  gem.authors       = ["id774"]
  gem.email         = ["idnanashi@gmail.com"]
  gem.summary       = %q{Fluentd input/output plugin termtter}
  gem.homepage      = "https://github.com/id774/fluent-plugin-termtter-db"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "fluentd"

  gem.add_runtime_dependency "fluentd"
end
