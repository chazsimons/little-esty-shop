class HolidayFacade
  def self.create_upcoming
    json = HolidayService.upcoming
    json.map do |data|
      Holiday.new(data)
    end
  end 
end
