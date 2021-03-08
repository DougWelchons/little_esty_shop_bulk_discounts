class HolidayApi
  attr_reader :pull_request

  def initialize
    @service = HolidayService.new
    @holidays = holidays
  end

  def holidays
    @service.next_holidays("US")
  end
end
