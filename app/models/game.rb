class Game < ActiveRecord::Base
  #searchkick autocomplete: ["name"]
  searchkick word_start: [:name]
  has_many :dlcs
  has_many :packages
end
