require_relative 'lib/restool/version'

Gem::Specification.new do |spec|
  spec.name          = "restool"
  spec.version       = Restool::VERSION
  spec.authors       = ["Juan Andres Zeni"]
  spec.email         = ["juanandreszeni@gmail.com"]

  spec.summary       = 'Turn your API and its responses into Ruby interfaces.'
  spec.description   = 'Make HTTP requests and handle its responses using simple method calls Restool turns your HTTP API and its responses into Ruby interfaces.'
  spec.homepage      = "https://github.com/jzeni/restool"
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')
  spec.require_paths = %w[lib]

  spec.files         = Dir.glob('{lib}/**/*')

  spec.add_dependency('persistent_http', '~> 2')
end
