require_relative './notifier'
require_relative '../../../lib/email'

class EmailNotifier < Notifier
  def notify
    Email.deliver(subscriber, alerts)
  end
end
