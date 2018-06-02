module PathnameExtension
	def match? pattern, pos = 0
		return self.to_s.match? pattern, pos
	end
end
class Pathname
	include PathnameExtension
end
