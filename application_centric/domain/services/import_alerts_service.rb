class ImportAlertsService
  attr_reader :reader, :repository, :observers

  def initialize(reader, repository, observers)
    @reader = reader
    @repository = repository
    @observers = Array(observers)
  end

  def perform
    return observers.each(&:on_failure) unless feed_available?

    observers.each { |observer| observer.on_success(alerts) }
  end

  private

  def feed_available?
    !(items.nil? || items.empty?)
  end

  def items
    @items ||= reader.read
  end

  def alerts
    @alerts ||= items.map { |item| repository.create(item) }
  end
end
