class Intro
  attr_reader :input
  def initialize
    @input = nil
    Prompts.intro()
    Prompts.instructions()
  end

  def get_input
    loop do
      Prompts.input()
      string = gets.chomp.upcase.gsub(/\s+/, "")
      valid_input?(string) ? break : Prompts.invalid_input()
    end
  end

  def valid_input?(string)
    valid_inputs = ['NEW', 'EXIT']
    if valid_inputs.any?(string)
      @input = string
      return true
    end

    return false
  end
end