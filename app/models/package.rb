class Package < ActiveRecord::Base
  searchkick autocomplete: ["name"]
  belongs_to :game
end
