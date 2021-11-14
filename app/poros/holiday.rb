class Holiday
  attr_reader :name, :date

  def initialize(data)
    @name = data[:localName]
    @date = Time.parse(data[:date]).strftime('%A, %b %d, %Y')
  end
end
