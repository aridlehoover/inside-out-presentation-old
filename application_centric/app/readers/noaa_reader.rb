require_relative './reader'
require_relative '../../../lib/rss'

class NOAAReader < Reader
  def read
    Array(RSS.read(address)).map { |item| parse(item) }
  end

  private

  def parse(item)
    {
      uuid: item.id,
      title: item.title,
      description: item.description,
      published_at: item.pub_date,
      updated_at: item.last_update,
      effective_at: item.pub_date,
      expires_at: (Time.parse(item.pub_date) + (6 * 3600)).to_s
    }
  end
end
