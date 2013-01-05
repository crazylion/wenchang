class Favorite < ActiveRecord::Base
  attr_accessible :paper_id, :user_id
  belongs_to :user
  belongs_to :paper
end
