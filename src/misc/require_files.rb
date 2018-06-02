require Crap::DIR[:misc].join('extensions')
require Crap::DIR[:misc].join('Helpers')
require Crap::ROOT.join('Parser')
Crap::Helpers.require_directories(
	Crap::DIR[:arguments]
)
