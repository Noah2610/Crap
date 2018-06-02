#!/bin/env ruby

require 'pathname'

require 'awesome_print'
require 'byebug'

ROOT = Pathname.new File.expand_path(File.dirname(File.realpath(__FILE__)))

DIR = {
	entry: Pathname.pwd,
	src:   ROOT.join('src')
}

require DIR[:src].join 'main'

CRAPPER = Crap::Parser.new

CRAPPER.set_option(
	:help,
	accessors: [?h, 'help'],
	description: 'Display help'
)
CRAPPER.set_option(
	:foo,
	accessors: [?f, 'foo'],
	value: true, description: 'Foo Bar Baz!!'
)
CRAPPER.set_command(
	:hello,
	accessors: [
		['hello', 'hi'],
		['world', 'earth'],
		:INPUT
	]
)
CRAPPER.set_command(
	:custom,
	accessors: [
		'custom',
		:INPUT,
		'more',
		:INPUTS
	]
)

CRAPPER.parse
puts CRAPPER.get_arguments
