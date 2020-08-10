require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @suggestion = params[:suggestion]
    @letters = params[:letters]

    if included?(@suggestion.upcase, @letters)
      if english_word?(@suggestion)
        @result = 'Well done'
      else
        @result = "It's not an English word"
      end
    else
      @result = "Not in the grid"
    end
  end

  def included?(suggestion, letters)
    suggestion.chars.all? { |letter| suggestion.count(letter) <= letters.count(letter) }
  end

  def english_word?(suggestion)
    response = open("https://wagon-dictionary.herokuapp.com/#{suggestion}")
    json = JSON.parse(response.read)
    json['found']
  end
end
