require './lib/required_files.rb'
require './spec/autoplay/autoplay_helper.rb'

file = './spec/autoplay/autoplay_test_games.txt'
matches = AutoPlay.get_matches(file)
test_count = 0
failure_count = 0

describe AutoPlay do
  it 'completes each move of a match without error' do

    matches.each { |match|
      outcome = AutoPlay.success?(match)
    
      if outcome == false
        failure_count += 1
      end

      test_count += 1
      print `clear`
      puts "Starting autoplay test, please wait..."
      puts "#{matches.size} matches to test"
      puts "#{test_count} out of #{matches.size} tests complete"
      puts "#{failure_count} failures"
    }
  
    puts "#{matches.size - failure_count} matches tested successfully"
    expect(failure_count).to eql(0)
  end
end






