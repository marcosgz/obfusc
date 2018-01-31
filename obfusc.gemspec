
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'obfusc/version'

Gem::Specification.new do |spec|
  spec.name          = 'obfusc'
  spec.version       = Obfusc::VERSION
  spec.authors       = ['Marcos G. Zimmermann']
  spec.email         = ['mgzmaster@gmail.com']
  spec.license       = 'MIT'

  spec.summary       = 'Obfuscate a recursive tree directory or a filename'
  spec.description   = 'Simple script to obfuscate a recursive tree directory' \
                       ' or a filename'
  spec.homepage      = 'https://github.com/marcosgz/obfusc'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
