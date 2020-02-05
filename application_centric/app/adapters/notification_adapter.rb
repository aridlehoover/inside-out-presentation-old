require_relative '../../../lib/subscriber'
require_relative '../notifiers/sms_notifier'

class NotificationAdapter
  def on_success(records)
    Subscriber.find_all.each do |subscriber|
      SMSNotifier.new(subscriber, records).notify
    end
  end

  def on_failure; end
end
