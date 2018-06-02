module Crap
	class Parser
		def initialize valid_arguments = {}
			@valid_arguments = {
				options:  [],
				commands: []
			}
			@parsed_arguments = {
				options:  [],
				commands: []
			}
			@argument_takes_value = nil
			@active_command       = nil
		end

		def set_option name, args = {}
			@valid_arguments[:options] << Arguments::Option.new(name, args)
		end

		def set_command name, args = {}
			@valid_arguments[:commands] << Arguments::Command.new(name, args)
		end

		def parse_arguments
			ARGV.each do |argument|
				parse_argument argument
			end
		end
		alias :parse :parse_arguments

		def get_arguments
			return @parsed_arguments.ai
		end

		private

		def parse_argument argument
			if    (is_argument_single_option? argument)
				parse_argument_single_option argument
			elsif (is_argument_double_option? argument)
				parse_argument_double_option argument
			elsif (!!@argument_takes_value)
				@argument_takes_value.set_value argument
			elsif (is_argument_command?       argument)
				parse_argument_command       argument
			else
				error_argument_not_valid argument
			end
		end

		def is_argument_single_option? argument
			return argument.match? /\A-\w+\z/
		end

		def is_argument_double_option? argument
			return argument.match? /\A--\S+\z/
		end

		def is_argument_command? argument
			return !(argument.match? /\A-{1,2}\S+\z/) && argument.match?(/\A.+\z/)
		end

		def parse_argument_single_option argument
			letters = argument.delete(?-).split('')
			letters.each do |letter|
				option = get_option_accessed_with letter
				add_parsed_option option  if (!!option)
			end
		end

		def parse_argument_double_option argument
			option_name = argument.sub /\A--/, ''
			option = get_option_accessed_with option_name
			add_parsed_option option  if (!!option)
		end

		def parse_argument_command argument
			command = get_command_accessed_with argument
			if (!!command)
				command.used_with argument
				add_parsed_command command
			end
		end

		def get_option_accessed_with accessor
			option = get_argument_of_type_accessed_with :options, accessor
			error_option_not_valid accessor  if (option.nil?)
			return option
		end

		def get_command_accessed_with accessor
			command = get_argument_of_type_accessed_with :commands, accessor
			error_command_not_valid accessor  if (command.nil?)
			return command
		end

		def get_argument_of_type_accessed_with type, accessor
			return nil  unless (@valid_arguments.key? type)
			return @valid_arguments[type].detect do |valid_option|
				next valid_option.accessed_with? accessor
			end
		end

		def add_parsed_option option
			return  unless (option.is_a? Crap::Arguments::Option)
			add_parsed_argument_of_type :options, option
		end

		def add_parsed_command command
			return  unless (command.is_a? Crap::Arguments::Command)
			command.used!
			add_parsed_argument_of_type :commands, command
		end

		def add_parsed_argument_of_type type, argument
			return  unless (@parsed_arguments.key? type)
			return  if     (@parsed_arguments[type].include? argument)
			return  unless (argument.is_a? Crap::Arguments::Argument)
			@parsed_arguments[type] << argument
			@argument_takes_value = argument  if (argument.takes_value?)
		end

		def error_option_not_valid argument
			padding = "#{' ' * $0.size}  "
			abort([
				"#{$0}: Error:",
				"#{padding}Invalid option: \'#{argument}\'. Exitting."
			].join("\n"))
		end

		def error_command_not_valid argument
			padding = "#{' ' * $0.size}  "
			abort([
				"#{$0}: Error:",
				"#{padding}Invalid command: \'#{argument}\'. Exitting."
			].join("\n"))
		end
	end
end
