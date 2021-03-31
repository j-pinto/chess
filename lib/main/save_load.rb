require 'yaml'

module SaveLoad
  def SaveLoad.save(game)
    serialized_game = YAML::dump(game)

    Prompts.enter_save_name()
    name = gets.chomp.gsub(/\s+/, "")

    unless Dir.exists?("#{Dir.pwd}/saved_games/")
      Dir.mkdir("#{Dir.pwd}/saved_games")
    end

    save_file = File.new("#{Dir.pwd}/saved_games/#{name}.yml", "w")
    File.write(save_file, serialized_game)
  end

  def SaveLoad.load
    game = nil
    unless SaveLoad.save_files_exist?()
      Prompts.no_saved_games()
      game = Game.new()
      return game
    end

    until game != nil
      Prompts.display_saved_games()
      Prompts.input()
      input = gets

      request = SaveLoad.other_request(input)
      if request != nil 
        game = request
        return game
      end

      input = input.to_i
      loaded_game = SaveLoad.get_saved_game(input)
      if loaded_game != nil
        game = loaded_game
        return game
      end
    end
  end

  def SaveLoad.save_files_exist?
    return false unless Dir.exists?("#{Dir.pwd}/saved_games/")
    return false unless !( Dir.empty?("#{Dir.pwd}/saved_games/") )

    save_files = Dir.children("#{Dir.pwd}/saved_games/")
    return false unless save_files.any?{|file| File.extname(file) == ".yml"}

    return true
  end

  def SaveLoad.other_request(input)
    request = input.clone.chomp.upcase.gsub(/\s+/, "")
    if request == 'NEW'
      game = Game.new()
      return game
    elsif request == 'EXIT'
      exit
    else
      return nil
    end
  end

  def SaveLoad.get_saved_game(input)
    save_files = Dir.children("#{Dir.pwd}/saved_games/")
    unless SaveLoad.load_number_valid?(input, save_files)
      Prompts.load_name_error()
      return nil
    end

    index = input - 1
    file_path = "#{Dir.pwd}/saved_games/#{save_files[index]}"
    serialized_game = File.read(file_path)
    deserialized_game = YAML.load(serialized_game)
    return deserialized_game
  end

  def SaveLoad.load_number_valid?(input, save_files)
    return false unless input.is_a?(Integer)
    return false unless input.between?(1, save_files.length)
    
    return true
  end
end