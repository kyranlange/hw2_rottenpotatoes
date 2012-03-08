class Movie < ActiveRecord::Base
  def self.ratings
    select(:rating).order("rating ASC").map(&:rating).uniq
  end
end
