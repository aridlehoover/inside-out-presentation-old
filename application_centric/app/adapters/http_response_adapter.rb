class HTTPResponseAdapter
  attr_reader :controller

  def initialize(controller)
    @controller = controller
  end

  def on_success(records)
    controller.redirect_to('/alerts', notice: 'Alerts imported.')
  end

  def on_failure
    controller.render(:new, notice: 'Unable to import alerts.')
  end
end
