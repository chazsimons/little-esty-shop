require 'faraday'
require './app/service/holiday_service'

RSpec.describe 'Holiday Service' do
  before :each do
    mock_response =
    '[{
        "date": "2021-11-25",
        "localName": "Thanksgiving Day",
        "name": "Thanksgiving Day",
        "countryCode": "US",
        "fixed": false,
        "global": true,
        "counties": null,
        "launchYear": 1863
      },
      {
        "date": "2021-12-24",
        "localName": "Christmas Day",
        "name": "Christmas Day",
        "countryCode": "US",
        "fixed": false,
        "global": true,
        "counties": null,
        "launchYear": null
      },
      {
        "date": "2021-12-31",
        "localName": "New Years Day",
        "name": "New Years Day",
        "countryCode": "US",
        "fixed": false,
        "global": true,
        "counties": null,
        "launchYear": null
      }
    ]'
    allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(Faraday::Response.new)
    allow_any_instance_of(Faraday::Response).to receive(:body).and_return(mock_response)
  end

  it 'can receive the data and parse it' do
    json = HolidayService.upcoming

    expect(json).to be_a(Array)
  end

  it 'can list the names of upcoming holidays' do
    json = HolidayService.upcoming

    results = json.map do |holiday|
                holiday[:localName]
              end
    expect(results).to eq(['Thanksgiving Day', 'Christmas Day', 'New Years Day'])
  end
end
