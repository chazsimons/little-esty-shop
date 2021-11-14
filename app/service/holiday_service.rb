require 'json'

class HolidayService

  def self.upcoming
    response = get_url('https://date.nager.at/api/v2/NextPublicHolidays/').get("US")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_url(url)
    Faraday.new(url)
  end
end
