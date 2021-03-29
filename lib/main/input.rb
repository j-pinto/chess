class Input
  attr_accessor :start, :finish, :input_string
  attr_reader :data_request
  def initialize
    @input_string = nil
    @start = nil
    @finish = nil
    @data_request = false
  end
  
  def get()
    loop do
      prompt()
      @input_string = gets.chomp.upcase.gsub(/\s+/, "")
      return if data_request?()
      valid?() ? break : error_msg()
    end

    converted_input = convert()
    @start = converted_input[0]
    @finish = converted_input[1]
  end

  def data_request?
    if @input_string == 'DATA'
      @data_request = true
      return true
    else
      return false
    end
  end

  def valid?()
    return false unless @input_string.length == 4

    return false unless @input_string[0].match?(/\A[A-H]*\z/)
    return false unless @input_string[1].match?(/\A[1-8]*\z/)

    return false unless @input_string[2].match?(/\A[A-H]*\z/)
    return false unless @input_string[3].match?(/\A[1-8]*\z/)
    
    return true
  end

  def convert()
    start_file = (@input_string[0].ord) % 65
    start_rank = (@input_string[1].to_i) - 1

    finish_file = (@input_string[2].ord) % 65
    finish_rank = (@input_string[3].to_i) - 1

    return [ [start_file, start_rank,] ,  [finish_file, finish_rank] ]
  end

  def prompt
    puts "Enter Input:"
  end

  def error_msg
    puts "invalid input, please try again"
  end

#
end