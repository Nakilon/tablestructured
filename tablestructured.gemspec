Gem::Specification.new do |spec|
  spec.name         = "tablestructured"
  spec.version      = "0.3.0"
  spec.summary      = "convert two-dimensional Array into an Array of Structs consuming the first row and/or column as attributes"

  spec.author       = "Victor Maslov aka Nakilon"
  spec.email        = "nakilon@gmail.com"
  spec.license      = "MIT"
  spec.metadata     = {"source_code_uri" => "https://github.com/nakilon/tablestructured"}

  spec.files        = %w{ LICENSE tablestructured.gemspec lib/tablestructured.rb }
end
