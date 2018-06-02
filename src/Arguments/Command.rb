module Crap
	module Arguments
		class Command < Argument
			def initialize name, args = {}
				super
				@current_command_index = 0
				@used_accessors        = []
			end

			def accessed_with? accessor
				if    (@current_command_index < @accessors.size)
					current_accessors = @accessors[@current_command_index]
					return current_accessors.any? do |_accessor|
						[accessor, :INPUT, :INPUTS].include? _accessor
					end
				elsif (@accessors.last.include? :INPUTS)
					return true
				else
					return false
				end
			end

			def used_with argument
				@used_accessors[@current_command_index] = argument
			end

			def used!
				@current_command_index += 1
			end

			private

			def parse_accessors accessors
				return [accessors].flatten(1).map do |accessor_array|
					next [accessor_array].flatten
				end
			end
		end
	end
end
