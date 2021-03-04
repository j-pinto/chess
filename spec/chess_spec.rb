require './lib/input.rb'

describe Input do
  describe "#valid?" do
    it "returns true if input string is correct format and in bounds" do
      input = Input.new
      expect(input.valid?('a1b2')).to eql(true)
      expect(input.valid?('A1B2')).to eql(true)
      expect(input.valid?('A1                    b2')).to eql(true)

      expect(input.valid?('A1b9')).to eql(false)
      expect(input.valid?('A1-b2')).to eql(false)
      expect(input.valid?('1122')).to eql(false)
      expect(input.valid?('foo')).to eql(false)
    end
  end
end