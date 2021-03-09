class HolidayProsessing

  def initialize
    @service = NagerDateService.new
  end

  def next_three_holidays(country_code)
    @holidays ||= @service.next_holidays(country_code)[0..2]
  end
end
