class Dlc < ActiveRecord::Base
  searchkick autocomplete: ["name"]
  belongs_to :game
end
