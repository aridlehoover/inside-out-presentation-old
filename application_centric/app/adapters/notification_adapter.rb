require_relative '../../../lib/subscriber'
require_relative '../notifiers/notifier_factory'

class NotificationAdapter
  def on_success(alerts)
    active_alerts = alerts.select(&:active?)

    if active_alerts.any?
      Subscriber.find_all.each do |subscriber|
        NotifierFactory.build(subscriber, active_alerts).notify
      end
    end
  end

  def on_failure; end
end
