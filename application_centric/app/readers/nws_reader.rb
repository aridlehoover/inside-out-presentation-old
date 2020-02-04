require_relative './reader'

class NWSReader < Reader
  def read
    RSS.read(address)&.map { |item| parse(item) }
  end

  private

  def parse(item)
   {
     uuid: item.id,
     title: item.title,
     description: item.summary,
     published_at: item.published,
     updated_at: item.updated,
     effective_at: item.cap_effective,
     expires_at: item.cap_expires
   }
  end
end
