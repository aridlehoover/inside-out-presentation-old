require_relative '../../../lib/base_controller'
require_relative '../../../lib/alert'
require_relative '../../../lib/subscriber'
require_relative '../../../lib/rss'
require_relative '../../../lib/twitter'
require_relative '../../../lib/sms'

class AlertsController < BaseController
  def import
    address = params[:address]

    unless address.match(/nws|noaa|TornadoWeather/)
      return render(:new, notice: 'Unable to import alerts.')
    end

    items = case address
    when /xml/
      RSS.read(address)
    when /twitter/
      Twitter.fetch(address)
    end

    if items.nil? || items.empty?
      return render :new, notice: 'Unable to import alerts.'
    end

    alerts = items.map do |item|
      case address
      when /noaa/
        Alert.create(
          uuid: item.id,
          title: item.title,
          description: item.description,
          published_at: item.pub_date,
          updated_at: item.last_update,
          effective_at: item.pub_date,
          expires_at: (Time.parse(item.pub_date) + (6 * 3600)).to_s
        )
      when /nws/
        Alert.create(
          uuid: item.id,
          title: item.title,
          description: item.summary,
          published_at: item.published,
          updated_at: item.updated,
          effective_at: item.cap_effective,
          expires_at: item.cap_expires
        )
      when /TornadoWeather/
        title, description = item.body.match(/^([^.]*)\.(.*)/).captures
        Alert.create(
          uuid: item.id,
          title: title,
          description: description,
          published_at: item.date_time,
          updated_at: item.date_time,
          effective_at: item.date_time,
          expires_at: (Time.parse(item.date_time) + 3600).to_s
        )
      end
    end

    active_alerts = alerts.select(&:active?)

    Subscriber.find_all.each do |subscriber|
      SMS.deliver(subscriber, active_alerts)
    end

    redirect_to '/alerts', notice: 'Alerts imported.'
  end
end
