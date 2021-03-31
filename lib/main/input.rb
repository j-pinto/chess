class Input
  attr_accessor :start, :finish, :input_string
  attr_reader :data_request, :help_request, :save_request
  def initialize
    @input_string = nil
    @start = nil
    @finish = nil
    @data_request = false
    @help_request = false
    @save_request = false
  end
  
  def get()
    loop do
      Prompts.input()
      @input_string = gets.chomp.upcase.gsub(/\s+/, "")
      return if data_request?()
      return if help_request?()
      return if save_request?()
      valid?() ? break : Prompts.invalid_input()
    end

    converted_input = convert()
    @start = converted_input[0]
    @finish = converted_input[1]
  end

  def save_request?
    if @input_string == 'SAVE'
      @save_request = true
      return true
    else
      return false
    end
  end

  def help_request?
    if @input_string == 'HELP'
      @help_request = true
      return true
    else
      return false
    end
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

end