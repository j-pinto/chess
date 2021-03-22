require './lib/required_files.rb'

 describe Input do
  describe "#valid?" do
    it "returns true if input string is correct format and in bounds" do
      input = Input.new()

      string = 'a1b2'
      input.instance_variable_set(:@input_string, string)
      expect(input.valid?()).to eql(true)

      string = 'A1B2'
      input.instance_variable_set(:@input_string, string)
      expect(input.valid?()).to eql(true)

      string = 'A1                    b2'
      input.instance_variable_set(:@input_string, string)
      expect(input.valid?()).to eql(true)

      string = 'A1b9'
      input.instance_variable_set(:@input_string, string)
      expect(input.valid?()).to eql(false)

      string = 'A1-b2'
      input.instance_variable_set(:@input_string, string)
      expect(input.valid?()).to eql(false)

      string = '1122'
      input.instance_variable_set(:@input_string, string)
      expect(input.valid?()).to eql(false)

      string = 'foo'
      input.instance_variable_set(:@input_string, string)
      expect(input.valid?()).to eql(false)
    end
  end

  describe '#convert' do
    it "returns an array to specify coordinates of start and finish (e.g. [[0,1], [0,2]]), given a valid input string" do
      input = Input.new() 
      string = 'a1a2'
      input.instance_variable_set(:@input_string, string)

      expect(input.valid?()).to eql(true)
      expect(input.convert()).to eql( [[0,0], [0,1]] )

      input = Input.new() 
      string = 'h8c3'
      input.instance_variable_set(:@input_string, string)

      expect(input.valid?()).to eql(true)
      expect(input.convert()).to eql( [[7,7], [2,2]] )
    end
  end
end