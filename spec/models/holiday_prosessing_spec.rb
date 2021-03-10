require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe "poro tests" do
    it "exists" do
      holidays = HolidayProsessing.new

      expect(holidays).to be_a(HolidayProsessing)
    end

    it "returns the next three holidays" do
      VCR.use_cassette('nds_public_holidays') do
        holidays = HolidayProsessing.new
        next_three = holidays.next_three_holidays("US")

        expect(next_three[0][:localName]).to eq("Memorial Day")
        expect(next_three[1][:localName]).to eq("Independence Day")
        expect(next_three[2][:localName]).to eq("Labor Day")
        expect(next_three.count).to eq(3)
      end
    end
  end
end
