require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      letter = ('A'..'Z').to_a.sample
      @letters << letter
    end
    @letters
  end

  def score
    @grid = params[:grid]
    @answer = params[:word]
    if session[:score].nil?
      @score = 0
    else
      @score = session[:score]
    end

    if check_grid(@answer.upcase, @grid) == false
      @result = "Sorry, but #{@answer.upcase} can't be built out of #{@grid}"
    elsif english_word(@answer) == false
      @result = "Sorry, but #{@answer.upcase} doesn't seem to be a valid English word..."
    else
      @result = "Congratulations! #{@answer.upcase} is a valid English word!"
      @score += (@answer.length * 2)
      session[:score] = @score
    end
    @result
  end

  private

  def check_grid(answer, grid)
    answer.chars.all? { |letter| answer.count(letter) <= grid.count(letter) }
  end

  def english_word(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    result = URI.open(url).read
    parsed_result = JSON.parse(result)
    parsed_result["found"]
  end
end
