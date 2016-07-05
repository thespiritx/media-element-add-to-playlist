$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "media_element_add_to_playlist/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "media_element_add_to_playlist"
  s.version     = MediaElementAddToPlaylist::VERSION
  s.authors     = ["Leah Lee"]
  s.email       = ["lmb@iu.edu"]
  s.homepage    = "https://github.com/avalonmediasystem/media-element-add-to-playlist"
  s.summary     = "Add the current time or segment to a playlist.  Also, add marker to playlist item."
  s.description = "Add the current time or segment to a playlist.  Also, add marker to playlist item."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'guard-coffeescript'
end
