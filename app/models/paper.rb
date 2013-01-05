class Paper < ActiveRecord::Base
  attr_accessible :abstract, :link, :name, :published_at, :source
end
