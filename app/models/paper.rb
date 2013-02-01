class Paper < ActiveRecord::Base
  attr_accessible :abstract, :link, :title, :published_at, :source,:acm_id
  has_many :favorites
  has_many :users,:through=>:favorites
end
