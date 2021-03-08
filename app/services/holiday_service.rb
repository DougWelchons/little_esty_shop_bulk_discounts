class HolidayService

  def next_holidays(country_code)
    data = get_url("https://date.nager.at/Api/v2/NextPublicHolidays/#{country_code}")
  end

  def get_url(url)
    response = Faraday.get(url)
    data = response.body
    json = JSON.parse(data, symbolize_names: true)
  end
end
