class Input
  attr_reader :start, :finish
  def initialize
    @start = nil
    @finish = nil
  end
  
  def get()
    input_string = nil
    loop do
      prompt()
      input_string = gets
      valid?(input_string) ? break : error_msg()
    end

    converted_input = convert(input_string)
    @start = converted_input[0]
    @finish = converted_input[1]
  end

  def valid?(string)
    string = string.chomp.upcase.gsub(/\s+/, "")
    return false unless string.length == 4

    return false unless string[0].match?(/\A[A-H]*\z/)
    return false unless string[1].match?(/\A[1-8]*\z/)

    return false unless string[2].match?(/\A[A-H]*\z/)
    return false unless string[3].match?(/\A[1-8]*\z/)
    
    return true
  end

  def convert(string)
    start_file = (string[0].ord) % 65
    start_rank = (string[1].to_i) - 1

    finish_file = (string[2].ord) % 65
    finish_rank = (string[3].to_i) - 1

    return [ [start_file, start_rank,] ,  [finish_file, finish_rank] ]
  end

  def prompt
    puts "Enter Move:"
  end

  def error_msg
    puts "invalid input, please try again"
  end

#
end