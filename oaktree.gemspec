require 'rake'

Gem::Specification.new { |spec|
  spec.name = 'oaktree'
  spec.version = '0.0.0'
  spec.date = '2012-01-11'
  spec.summary = 'OakTree static HTML blog'
  spec.description = 'OakTree static HTML blog generation tool.'
  spec.authors = ['Noel Cower']
  spec.email = 'ncower@gmail.com'
  spec.files = FileList['lib/**/*.rb',
                        'bin/*',
                        'template/**/*.erb',
                        '[A-Z]*',
                        'test/**/*'].to_a
  spec.executables << 'oak'
  spec.homepage = 'http://spifftastic.net/oaktree/'
}
