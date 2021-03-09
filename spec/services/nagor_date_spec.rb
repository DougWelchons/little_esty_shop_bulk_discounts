require 'rails_helper'

RSpec.describe NagerDateService do
  it "exists" do
    nds = NagerDateService.new

    expect(nds).to be_a(NagerDateService)
  end

  it "makes and API call and returns the next public holidays" do
    VCR.use_cassette('nds_public_holidays') do
      nds = NagerDateService.new
      holidays = nds.next_holidays("US")

      expect(holidays[0][:localName]).to eq("Memorial Day")
      expect(holidays[1][:localName]).to eq("Independence Day")
      expect(holidays[2][:localName]).to eq("Labor Day")
      # expect(holidays.count).to eq(3)
    end
  end
end
