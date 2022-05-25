require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    def generate_grid(grid_size)
      # TODO: generate random grid of letters
      arr1 = []
      arr = %w[A B C D E F G H I J K L M N O P Q R S T U V]
      while grid_size > 0
        arr1 << arr.sample
        grid_size -= 1
      end

      return arr1
    end

  @newarr = generate_grid(params[:size].to_i  )
  end

  def score
    def run_game(attempt, grid, start_time, end_time)
      # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
        url = "https://wagon-dictionary.herokuapp.com/" + attempt.to_s
        wordCheck = URI.open(url).read
        result = JSON.parse(wordCheck)

      #define init
        message = ""
        score = 0

      #define if word found is assessed to be false
        if "#{result["found"]}".to_s == "false"
          message = "The given word is not an english word"
          score = 0
        elsif (attempt.split("") - grid.map{|x| x.downcase}).size > 0
          message = "Not in the grid"
          score = 0
        elsif grid.map{|x| x.downcase}.length - (grid.map{|x| x.downcase} - attempt.split("")).size < attempt.length
          message = "Letters are overused and not in the grid"
          score = 0
        else
          message = "Well done"
          score = attempt.length
        end

        # give higher score for quicker answers
        if end_time - start_time < 5.0
          score *= 1.2
        end

        return {
          score: score,
          message: message,
          time: end_time - start_time
        }
    end
    # raise
      # run_game(attempt, grid, start_time, end_time)
      @output = run_game(params[:word], params[:letters].split(" "), Time.zone.parse(params[:start_time]).utc, Time.now())
      # @output = "working sample"
  end
  # //end of score
end
