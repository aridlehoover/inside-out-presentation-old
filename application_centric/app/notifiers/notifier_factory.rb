require_relative '../../../application_centric/app/notifiers/email_notifier'
require_relative '../../../application_centric/app/notifiers/sms_notifier'
require_relative '../../../application_centric/app/notifiers/notifier'

class NotifierFactory
  def self.build(subscriber, alerts)
    case subscriber.channel
    when 'Email'
      EmailNotifier.new(subscriber, alerts)
    when 'SMS'
      SMSNotifier.new(subscriber, alerts)
    else
      Reader.new(subscriber, alerts)
    end
  end
end
