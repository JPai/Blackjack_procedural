#tic_tac_toe.rb

#Exercise for Ruby - build a tic_tac_toe game
#Tealeaf - Intro - lesson 1
#
#Author: Justin Pai
#Date: June 21 14
#Ver: 0.1

require 'pry'

NO_ONE_S = 0 #the block is not selected
PLAY_S = 1 #the block selected by player
COM_S = -1 #the block selected by computer


NO_ONE_WIN = 0 #no one wins the game
PLAYER_WIN = 1 #the play wins
COM_WIN = 2 #the computer wins
TIE_GAME = 3 #no one wins and all blocks are taken!

#adding "=>" in front of prompt
def say(msg)
  puts "=> #{msg}"
end

#return a new board
def new_board
  #the board array, true: the block is taken; false: the block is not taken
  #the order for the array value is referring to the block location as following:
  #[r1-c1, r1-c2, r1-c3, r2-c1, r2-c2, r2-c3, r3-c1, r3-c2, r3-c3]
  board_array = []
  (0..8).each {|v| board_array[v] = NO_ONE_S}
  board_array
end


#givin an location array [r, c], return this location to the board_array order
#example: if location array  = [0, 0], return number 1 => 
def block_loc_convert(location)
  case 
  when location == [0, 0]
    0
  when location == [0, 1]
    1
  when location == [0, 2]
    2
  when location == [1, 0]
    3
  when location == [1, 1]
    4
  when location == [1, 2]
    5
  when location == [2, 0]
    6
  when location == [2, 1]
    7
  when location == [2, 2]
    8
  end
end

#asking user to select a block
#return the array [r, c] of user's selection
def ask_player_choose()
  #user enter the row
  say "plsese select the row (enter 1, 2, or 3)?"
  r = gets.chomp.strip
  while r != '1' && r != '2' && r != '3'
    say "Note: invalided number! please enter 1, 2, or 3"
    r = gets.chomp.strip
  end

  #user enter the col
  say "plsese select the column (enter 1, 2, or 3)?"
  c = gets.chomp.strip
  while c != '1' && c != '2' && c != '3'
    say "Note: invalided number! please enter 1, 2, or 3"
    c = gets.chomp.strip
  end
  say "Your selection is [#{r}, #{c}]"
  player_s = [(r.to_i - 1), (c.to_i - 1)]
end


#validate the selected block [r, c] is not selected in board_arrs
def player_choose(board_arr)
  valid_selection = false
  begin
    player_s = ask_player_choose
    if board_arr[block_loc_convert(player_s)] == NO_ONE_S
      board_arr[block_loc_convert(player_s)] = PLAY_S
      valid_selection = true
      board_arr #return the new board_arr
    else
      say "Note: the block has been selected! please select another block!"
    end
  end while !valid_selection
end

#computer randomly chooses a block on an given board
def com_choose(board_arr)
  valid_selection = false
  say "Computer's turn:"
  begin
    com_s = [rand(3), rand(3)] #randomly select a block
    if board_arr[block_loc_convert(com_s)] == NO_ONE_S
      board_arr[block_loc_convert(com_s)] = COM_S
      valid_selection = true
      board_arr #return the new board_arr
#binding.pry
    end
  end while !valid_selection
end

#ruturn the winning status below of the game
#NO_ONE_WIN = 0 #no one wins the game
#PLAYER_WIN = 1 #the play wins
#COM_WIN = 2 #the computer wins
#TIE_GAME = 3 #no one wins and all blocks are taken!
def win_check(board_arr)
  return_value = NO_ONE_WIN
  #8 cases for winning status
  c1 = board_arr[0] + board_arr[1] + board_arr[2]
  c2 = board_arr[3] + board_arr[4] + board_arr[5]
  c3 = board_arr[6] + board_arr[7] + board_arr[8]
  c4 = board_arr[0] + board_arr[3] + board_arr[6]
  c5 = board_arr[1] + board_arr[4] + board_arr[7]
  c6 = board_arr[2] + board_arr[5] + board_arr[8]
  c7 = board_arr[0] + board_arr[4] + board_arr[8]
  c8 = board_arr[2] + board_arr[4] + board_arr[6]
  #different cases return different values
  status = [c1, c2, c3, c4, c5, c6, c7, c8]
  status.each do |v| 
    if v == 3 || v == -3
      v == 3 ? return_value = PLAYER_WIN : return_value = COM_WIN  
    end
  end
  #check tie game
  if return_value == NO_ONE_WIN && !board_arr.include?(NO_ONE_S)
    return_value = TIE_GAME
  end
  return_value
end


def draw_board(board_arr)
  #transfer board into 'O' and 'X'
  board_ox = board_arr.map do |v|
    case 
    when v == NO_ONE_S
      "   "
    when v == PLAY_S #player is assigned to "X"
      " X "
    when v == COM_S #computer is assigned to "O"
      " O "
    end
  end
  #drawing the board now
  puts "#{board_ox[0]} | #{board_ox[1]} | #{board_ox[2]}}"
  puts "--------------"
  puts "#{board_ox[3]} | #{board_ox[4]} | #{board_ox[5]}}"
  puts "--------------"
  puts "#{board_ox[6]} | #{board_ox[7]} | #{board_ox[8]}}"
end

#prints out game result and return final game status
def game_result(player_name, game_status, board_arr)
  game_status = win_check(board_arr)
  case game_status
  when PLAYER_WIN
    say "Congraduates, #{player_name}. You win!"
  when COM_WIN
    say "Hoops! You lose!"
  when TIE_GAME
    say "It's a tie.  No one wins!"      
  end
  game_status  
end


def new_game()
  #create a new board
  board = new_board

  #asking user's name
  #Asking the player's name
  say "Welcome to our Tic Tac Toe Game!"
  say "What's your name?"
  player_name = gets.chomp.strip

  say "Hi #{player_name}, Game Starts!"

  game_status = NO_ONE_WIN

  while game_status == NO_ONE_WIN
    player_choose(board)
    draw_board(board)
    game_status = game_result(player_name, game_status, board)
    if game_status == NO_ONE_WIN
      com_choose(board)
      draw_board(board)
      game_status = game_result(player_name, game_status, board)    
    end
  end
end

#main method
new_game





 