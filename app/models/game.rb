class Game < ActiveRecord::Base
  searchkick
  has_many :dlcs
  has_many :packages
end
