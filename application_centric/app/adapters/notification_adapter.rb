require_relative '../../../lib/subscriber'
require_relative '../notifiers/notifier_factory'

class NotificationAdapter
  def on_success(records)
    Subscriber.find_all.each do |subscriber|
      NotifierFactory.build(subscriber, records).notify
    end
  end

  def on_failure; end
end
