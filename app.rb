require 'sinatra/base'
require 'sinatra/flash'

require_relative 'lib/wordguesser_game'

class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  set :host_authorization, { permitted_hosts: [] }  

  before do
    @game = session[:game] || WordGuesserGame.new('')
  end

  after do
    session[:game] = @game
  end

  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  # Use existing methods in WordGuesserGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    params[:guess].to_s[0]
    ### YOUR CODE HERE ###
    letter = params[:guess].to_s[0]
    begin 
      changed = @game.guess(letter)
      flash[:message] = 'You have already used that letter' unless changed
    rescue ArgumentError
      flash[:message] = 'Invalid guess.' 
    end
    redirect '/show'

  end

  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in WordGuesserGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    ### YOUR CODE HERE ###
    case @game.check_win_or_lose
    when :win  then redirect '/win'
    when :lose then redirect '/lose'
    else
      @word_with_guesses = @game.word_with_guesses
      @wrong_guesses     = @game.wrong_guesses
      erb :show # You may change/remove this line
    end
  end

  get '/win' do
    ### YOUR CODE HERE ###
   if @game.check_win_or_lose == :win
     @word = @game.word 
     erb :win # You may change/remove this line
   else 
    redirect '/show'
   end  
  end

  get '/lose' do
    ### YOUR CODE HERE ###
   if @game.check_win_or_lose == :lose
     @word = @game.word   
     erb :lose # You may change/remove this line
   else 
    redirect '/show'
   end
  end
end
