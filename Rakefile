require 'pathname'
require 'sprockets'
require 'uglifier'

root        = Pathname(File.expand_path('../', __FILE__))
environment = Sprockets::Environment.new(root)
environment.append_path(root.join('src'))

class Sprockets::JstProcessor
  def self.default_namespace
    'this.ColorCanvas'
  end
end

task :build do
  File.open('lib/colorcanvas.js', 'w+') do |f|
    f.write environment['index'].to_s
  end

  File.open('lib/colorcanvas.input.js', 'w+') do |f|
    f.write environment['input'].to_s
  end

  File.open('lib/colorcanvas.min.js', 'w+') do |f|
    f.write Uglifier.new.compile(File.read("lib/colorcanvas.js"))
  end
  File.open('lib/colorcanvas.input.min.js', 'w+') do |f|
    f.write Uglifier.new.compile(File.read("lib/colorcanvas.input.js"))
  end
end