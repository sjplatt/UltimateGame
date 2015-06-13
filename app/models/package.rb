class Package < ActiveRecord::Base
  searchkick
  belongs_to :game
end
