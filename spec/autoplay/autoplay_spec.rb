# Autoplay test takes a text file with lists of moves representing real games, and plays the games automatically

# If given a valid list of moves, any failure to autoplay through a game in its entirety would indicate and issue with the programs move validation logic

# To create a text file of games to test, first download a Portable Game Notation (PGN) file containing one or archived games from a number of freely-available online chess game databases

# Text file can be created using the free pgn-extract program found here: https://www.cs.kent.ac.uk/people/staff/djb/pgn-extract/

# pgn-extract should be configured to process your PGN file and output a .txt file with moves in UCI format, no tags, and no results (see pgn-extract instructions for details)

# .txt file should be named autoplay_test_games.txt and stored in /spec/autoplay/

# A sample file of 1,000 games has been supplied with this repository 

require './lib/required_files.rb'
require './spec/autoplay/autoplay_helper.rb'

file = './spec/autoplay/autoplay_test_games.txt'
if File.exist?(file)
  matches = AutoPlay.get_matches(file)
  test_count = 0
  failure_count = 0

  if matches.length > 0
    
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

  else
    puts "Warning: autoplay test could not initiate because text file contains no games"
  end

else
  puts "Warning: autoplay test could not initiate due to missing or incorrectly formatted game file"
end






