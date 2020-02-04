require_relative '../../../lib/base_controller'
require_relative '../../../lib/alert'
require_relative '../../../lib/rss'
require_relative '../../../application_centric/app/adapters/http_response_adapter'
require_relative '../../../application_centric/app/readers/nws_reader'
require_relative '../../../application_centric/domain/repositories/alert_repository'
require_relative '../../../application_centric/domain/services/import_alerts_service'

class AlertsController < BaseController
  def import
    ImportAlertsService.new(reader, repository, observers).perform
  end

  private

  def reader
    NWSReader.new(params[:address])
  end

  def repository
    AlertRepository.new
  end

  def observers
    [
      HTTPResponseAdapter.new(self)
    ]
  end
end
