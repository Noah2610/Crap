module Crap
	module Arguments
		class Argument
			def initialize name, args = {}
				@name        = name
				@accessors   = parse_accessors(args[:accessors] || args[:accessor])
				@takes_value = !!args[:value]
				@description = args[:description]
				@value       = nil
			end

			def accessed_with? accessor
				return @accessors.include? accessor
			end

			def takes_value?
				return @takes_value
			end

			def set_value value
				@value = value
			end

			def get_value
				return @value
			end

			def get_description
				return @description
			end

			private

			def parse_accessors accessors
				return [accessors].flatten.reject { |a| !a }
			end
		end
	end
end
