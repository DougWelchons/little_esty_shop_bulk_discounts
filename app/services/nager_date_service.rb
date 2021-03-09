class NagerDateService

  def next_holidays(country_code)
    make_api_call("https://date.nager.at/Api/v2/NextPublicHolidays/#{country_code}")
  end

  def make_api_call(url)
    response = Faraday.get(url)
    data = response.body
    JSON.parse(data, symbolize_names: true)
  end
end
