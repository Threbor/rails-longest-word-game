require "json"
require "open-uri"

class ApplicationController < ActionController::Base

  def home
  end

  def score
    @user_input = params[:formulaire].upcase.chars
    @random_letters = params[:random_letters].split

    if verify_inclusion(@user_input, @random_letters)
      if valid_english_word(@user_input)
        @bot_answer = "<strong>Congratulations!</strong> #{@user_input.join} is a valid English word!"
      else
        @bot_answer = 'tes mots sont inclus MAIS N\'existent pas'
      end

    else
      @bot_answer = "Sorry but #{@user_input.join} can't be built out of #{@random_letters.join(', ')}"
    end
  end

  def verify_inclusion(user_input, random_letters)
      user_input.each do |one_letter|
      if random_letters.include?(one_letter)
        random_letters.delete(one_letter)
        true
      else
        return false
      end
    end
  end

  def valid_english_word(user_input)
    url_to_parse = "https://wagon-dictionary.herokuapp.com/#{user_input.join}"
    user_serialized = URI.open(url_to_parse).read
    user = JSON.parse(user_serialized)
    if user["found"]
      true
    else
      false
    end
  end

  def new
    @letters = ('A'..'Z').to_a
    @random_letters = @letters.sample(10)
  end

end
