# Chess
* Terminal-based chess game for two players
* Implemented using Ruby
* App was made to complete the final project for the Ruby Programming section of The Odin Project's Web Developement program.
* Assignment instructions can be found here: https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/ruby-programming/lessons/ruby-final-project

## Features
### Functionality
* Allows players to take turns entering moves in to terminal when prompted
* After each move, an updated board graphic is printed to the terminal to show location of all pieces
* All input is screened for validity/move legality
* Players are prompted to re-enter any invalid input
* Basic moves, captures, en passants, pawn promotion, and castling are all handled automatically based on player input
* Users are able to save their game and/or exit the program at any time
* Users can load any previously saved game at launch
* Usage instructions are printed at launch, with option to display them again at any time
### Design
* Board is represented by grid of colored squares with rank and file labels
* Each square that is currently occupied displays the occupying piece's unicode symbol in the appropriate color
* Terminal output is refreshed after each turn

## Development
* App was implemented entirely in Ruby
* Every effort was made to ensure methods were cleanly separated in to appropriate classes, and each major step in a method was further abstracted to its own method 
* Unit tests were used throughout development to ensure newly added functions were working prior to making commits
* Tests were written using Rspec, 50 separate test examples in total
### Autoplay testing
* Autoplay testing was written in order to test a large number of games known to be comprised entirely of legal moves
* If any archived game cannot be fully processed by the Autoplay test, it would indicate an issue with the program's move validation logic
* Test was run with a sample file containing 1,000 games, all of which were processed successfully
* More info can be found in comments of the autoplay_spec.rb file
