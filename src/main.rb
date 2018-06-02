require 'pathname'

module Crap
	ROOT = Pathname.new(File.expand_path(File.dirname(File.realpath(__FILE__))))
	DIR  = {
		misc:      ROOT.join('misc'),
		arguments: ROOT.join('Arguments')
	}
end

require Crap::DIR[:misc].join 'require_files'
