require_relative '../../../lib/base_controller'
require_relative '../../../lib/alert'
require_relative '../../../lib/rss'

class AlertsController < BaseController
  def import
    unless params[:address].match(/nws/)
      return render(:new, notice: 'Unable to import alerts.')
    end

    items = RSS.read(params[:address])

    if items.nil? || items.empty?
      return render :new, notice: 'Unable to import alerts.'
    end

    items.each do |item|
      Alert.create(
        uuid: item.id,
        title: item.title,
        description: item.summary,
        published_at: item.published,
        updated_at: item.updated,
        effective_at: item.cap_effective,
        expires_at: item.cap_expires
      )
    end

    redirect_to '/alerts', notice: 'Alerts imported.'
  end
end
