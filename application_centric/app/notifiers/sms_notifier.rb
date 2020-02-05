require_relative './notifier'
require_relative '../../../lib/sms'

class SMSNotifier < Notifier
  def notify
    SMS.deliver(subscriber, alerts)
  end
end
