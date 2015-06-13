class Game < ActiveRecord::Base
  searchkick autocomplete: ["name"]
  has_many :dlcs
  has_many :packages
end
