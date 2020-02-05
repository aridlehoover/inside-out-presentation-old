require_relative './notifier'
require_relative '../../../lib/messenger'

class MessengerNotifier < Notifier
  def notify
    Messenger.deliver(subscriber, alerts)
  end
end
