require_relative './reader'
require_relative '../../../lib/twitter'

class TWAReader < Reader
  def read
    Array(Twitter.fetch(address)).map { |item| parse(item) }
  end

  private

  def parse(item)
     title, description = item.body.match(/^([^.]*)\.(.*)/).captures
    {
      uuid: item.id,
      title: title,
      description: description,
      published_at: item.date_time,
      updated_at: item.date_time,
      effective_at: item.date_time,
      expires_at: (Time.parse(item.date_time) + 3600).to_s
    }
  end
end
