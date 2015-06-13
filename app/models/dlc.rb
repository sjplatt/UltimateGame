class Dlc < ActiveRecord::Base
  searchkick
  belongs_to :game
end
