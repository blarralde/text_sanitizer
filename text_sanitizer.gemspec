$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "text_sanitizer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "text_sanitizer"
  s.version     = TextSanitizer::VERSION
  s.authors     = ["Benjamin Larralde"]
  s.email       = ["benjamin.larralde@gmail.com"]
  s.homepage    = "https://github.com/saipas/text_sanitizer"
  s.summary     = "Cleans text fields in ActiveRecord."
  s.description = "Defines multiple helpers that operate various textual operations " <<
                  "like downcase, capitalize or sanitize (strip dangerous content) " <<
                  "from string/text attributes in ActiveRecord models at validation " <<
                  "(or any other callback)."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.6"
  s.add_dependency 'sanitize'

  s.add_development_dependency "sqlite3"
end
