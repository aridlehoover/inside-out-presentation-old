require_relative '../../../application_centric/app/readers/noaa_reader'
require_relative '../../../application_centric/app/readers/nws_reader'
require_relative '../../../application_centric/app/readers/reader'

class ReaderFactory
  def self.build(address)
    case address
    when /noaa/
      NOAAReader.new(address)
    when /nws/
      NWSReader.new(address)
    else
      Reader.new(address)
    end
  end
end
