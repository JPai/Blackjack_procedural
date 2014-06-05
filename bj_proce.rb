#bj_proce.rb

#This is a procedural blackjack game built for:
#Tealeaf course - Introduction to Ruby and Web Development - Lesson 1
#
#Authur: Justin Pai
#Date: June 05 2014

BJ = 100 #When it's BlackJack, the total value will retrun -1
BUSTED = -2 #When total value is over 21

#Array for 52 pcs of cards
cards = [['Spade', 'A'], ['Spade', 2], ['Spade', 3], ['Spade', 4], ['Spade', 5], ['Spade', 6], 
      ['Spade', 7], ['Spade', 8], ['Spade', 9], ['Spade', 10], ['Spade', 'J'],['Spade', 'Q'],['Spade', 'K'],
      ['Heart', 'A'], ['Heart', 2], ['Heart', 3], ['Heart', 4], ['Heart', 5], ['Heart', 6],['Heart', 7], 
      ['Heart', 8], ['Heart', 9], ['Heart', 10], ['Heart', 'J'],['Heart', 'Q'],['Heart', 'K'], ['Diamond', 'A'], 
      ['Diamond', 2], ['Diamond', 3], ['Diamond', 4], ['Diamond', 5], ['Diamond', 6], ['Diamond', 7], 
      ['Diamond', 8], ['Diamond', 9], ['Diamond', 10], ['Diamond', 'J'],['Diamond', 'Q'],['Diamond', 'K'],
      ['Club', 'A'], ['Club', 2], ['Club', 3], ['Club', 4], ['Club', 5], ['Club', 6], ['Club', 7], 
      ['Club', 8], ['Club', 9], ['Club', 10], ['Club', 'J'],['Club', 'Q'],['Club', 'K']]

#playing or not
playing = true

#Asking the player's name
puts "Welcome to our Blackjack Game!"
puts "What's your name?"
player_name = gets.chomp.strip

#Data structure for the player and delaer
player = {name: player_name, card_get: []}
dealer = {name: "Dealer", card_get: []}

#hit 1 card
#return the card [suit, value]
def hit(c_cards)
  c_cards.pop
end

#return the total value of the c_arr[]
def total(c_arr)	
  sum = 0 #sum of the values
	
  #convert J, Q, K into 10
  n_c_arr = c_arr.map do |a_v|
    if a_v[1] == 'J' || a_v[1] == 'Q' || a_v[1] == 'K'
      10 #NOTE: array is reference by pointer!
    else
      a_v[1]
    end
  end
  #check if A exists
  if !n_c_arr.include?('A')
    n_c_arr.each {|v| sum += v}
  #BUSTED situation
    if sum > 21
      sum = BUSTED
    else
      sum
    end
  #BJ situation
  elsif n_c_arr == ['A', 10] || n_c_arr == [10, 'A']
    sum = BJ
  else
    first_A = true #check if it's the first A => in this case, A will be 11
    #convert A into 1 or 11
    n_c_arr.map! do |v|
      if v == 'A'
        if first_A 
          first_A = false
          v = 11					
        else
          v = 1
        end		
      else
        v
      end
    end
  #calculate sum now
    n_c_arr.each {|v| sum += v}
    if sum > 21
      sum -= 10 #convert first A from 11 to 1
      if sum > 21
        sum = BUSTED
      end
    else
      sum
    end
    sum
  end
end

#Asking the player to hit or stay.
#Return true for hit, and false for stay
def hit?
  puts "'Hit' or 'Stay'?"
  ans = gets.chomp.strip.upcase
  while ans != 'HIT' && ans != 'STAY'
    puts "Note: enter 'Hit' or 'Stay'"
    ans = gets.chomp.strip.upcase
  end
  if ans == 'HIT'
    true
  else
    false
  end 
end

#Display the current card status for the player and dealer
#Show dealer's cards if d_s is true
def show_cards_status(player, dealer, d_s)
  if d_s
    puts "#{dealer[:name]} cards: " + dealer[:card_get].to_s
    puts "#{player[:name]} cards: " + player[:card_get].to_s
  else
    puts "#{dealer[:name]} cards: [[?, ?], [?, ?]]"
    puts	"#{player[:name]} cards: " + player[:card_get].to_s
  end
end


##Game Start!
while playing
  #shuffle cards for the game
  shuf_cards = cards.shuffle
  #total value for delear and player
  player_total = 0
  dealer_total = 0
  #deal 2 cards by default
  2.times do
    player[:card_get].push(hit(shuf_cards))
    dealer[:card_get].push(hit(shuf_cards))
  end
  #Display the cards to player and to dealer
  show_cards_status(player, dealer, false)

  player_total = total(player[:card_get])
  dealer_total = total(dealer[:card_get])

  #player's move	
  if player_total != BJ
    while hit?
      player[:card_get].push(hit(shuf_cards))
      player_total = total(player[:card_get])
      show_cards_status(player, dealer, false)
      if player_total == BUSTED
        #print out some info
        puts "#{player[:name]}: Oh No! Busted!"
        break
      end
      if player_total == 21
        #print out some info
        puts "#{player[:name]}: Great! Got 21!"
        break
      end
    end
  else
    puts "#{player[:name]}: Awesome! Blackjack!"
  end

	#dealer's move
  if dealer_total != BJ
    #dealer needs to be over 17
    while dealer_total < 17 
      dealer[:card_get].push(hit(shuf_cards))
      dealer_total = total(dealer[:card_get])
      show_cards_status(player, dealer, true)
      if dealer_total == BUSTED
        puts "Dealer: busted!!"
        break
      end
      if dealer_total == 21
        break
      end
    end
  else
    puts "Dealer: blackjack!!"
  end

  #Game results
  if player_total > dealer_total
    puts "Congradulations! You win!"
  elsif player_total == dealer_total
    puts "It's a push. No one wins."
  else
    puts "Ohoh... Dealer wins!"
  end

#Asking player if he wants to play again
  puts "Do you want to play again? (Yes/No)"
  ans = gets.chomp.strip.upcase
  while ans != 'YES' && ans != 'NO'
    puts "Note: enter 'YES' or 'NO'"
    ans = gets.chomp.strip.upcase
  end
  if ans == 'YES'
    playing = true
    player[:card_get] = []
    dealer[:card_get] = []
    shuf_cards = cards.shuffle
  else
    playing = false
  end 
end

