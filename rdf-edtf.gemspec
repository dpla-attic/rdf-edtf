# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'rdf/edtf/version'

Gem::Specification.new do |s|
  s.name        = "rdf-edtf"
  s.version     = RDF::EDTF::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Tom Johnson']
  s.homepage    = 'https://github.com/dpla/rdf-edtf'
  s.email       = 'tom@dp.la'
  s.summary     = %q{}
  s.description = %q{}
  s.license     = 'APACHE2'
  s.required_ruby_version     = '>= 2.0.0'

  s.add_dependency('rdf', '~> 1.1')
  s.add_dependency('edtf')
  s.add_dependency('ebnf')

  s.add_development_dependency('pry')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rdf-spec')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")

  s.extra_rdoc_files = ['LICENSE',
                        'README.md']
end
