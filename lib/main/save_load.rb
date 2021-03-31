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
end