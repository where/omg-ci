class Project < ActiveRecord::Base
  attr_accessible :name, :git_repo

  validates :name, :presence => true
  validates :git_repo, :presence => true
end
