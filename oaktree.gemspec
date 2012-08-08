require 'rake'

DESCRIPTION = <<EOD
OakTree static HTML blog generation tool.

If you're smart, you won't use this.  Otherwise, run 'oak' and read the
instructions.  It's fairly simple to use.
EOD

Gem::Specification.new { |spec|
  spec.name        = 'oaktree'
  spec.version     = '0.4.1'
  spec.date        = '2012-07-01'
  spec.summary     = 'OakTree static HTML blog'
  spec.description = DESCRIPTION
  spec.authors     = ['Noel Cower']
  spec.licenses    = ['WTFPL-2', 'MIT']
  spec.email       = 'ncower@gmail.com'
  spec.homepage    = 'http://spifftastic.net/oaktree/'
  spec.executables << 'oak'
  spec.files = FileList['lib/**/*.rb',
                        'bin/*',
                        '[A-Z]*',
                        'test/**/*'].to_a

  spec.add_dependency 'mustache', '>= 0.99'
  spec.add_dependency 'kramdown', '>= 0.13'
}
