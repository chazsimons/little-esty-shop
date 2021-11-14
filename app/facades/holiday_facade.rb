class HolidayFacade
  def self.create_upcoming
    json = HolidayService.upcoming
    json.map do |data|
      Holiday.new(data)
    end[0..2]
  end 
end
