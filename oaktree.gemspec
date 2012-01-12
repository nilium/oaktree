require 'rake'

DESCRIPTION = <<EOD
OakTree static HTML blog generation tool.

If you're smart, you won't use this.
EOD

Gem::Specification.new { |spec|
  spec.name        = 'oaktree'
  spec.version     = '0.0.1pre'
  spec.date        = '2012-01-11'
  spec.summary     = 'OakTree static HTML blog'
  spec.description = DESCRIPTION
  spec.authors     = ['Noel Cower']
  spec.email       = 'ncower@gmail.com'
  spec.homepage    = 'http://spifftastic.net/oaktree/'
  spec.executables << 'oak'
  spec.files = FileList['lib/**/*.rb',
                        'bin/*',
                        'template/**/*.erb',
                        '[A-Z]*',
                        'test/**/*'].to_a
  
}
