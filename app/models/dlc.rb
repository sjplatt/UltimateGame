class Dlc < ActiveRecord::Base
  #searchkick autocomplete: ["name"]
  searchkick word_start: [:name]
  belongs_to :game
end
