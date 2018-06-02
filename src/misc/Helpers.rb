module Crap
	module Helpers
		def self.require_tree directory
			return  unless (File.directory? directory)
			directory = Pathname.new directory
			directory directory
			directory.each_child do |filename|
				next  unless (File.directory? filename)
				filepath = directory.join filename
				require_directory filepath
			end
		end

		def self.require_directories *directories
			directories.each do |directory_name|
				next  unless (File.directory? directory_name)
				require_directory directory_name
			end
		end

		def self.require_directory directory
			return  unless (File.directory? directory)
			directory = Pathname.new directory
			directory.each_child do |filename|
				next  unless (is_valid_ruby_file? filename)
				filepath = directory.join filename
				require filepath
			end
		end

		def self.is_valid_ruby_file? filename
			return false  unless (File.file? filename)
			return true   if     (filename.match? /\/[\w\-]+\.rb\z/)
			return false
		end
	end
end
