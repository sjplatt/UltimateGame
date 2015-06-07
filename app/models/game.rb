class Game < ActiveRecord::Base
  has_many :dlcs
  has_many :packages
end
