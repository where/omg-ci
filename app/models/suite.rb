class Suite < ActiveRecord::Base
  belongs_to :project
  attr_accessible :name, :suite_type

  TYPES = ['Ruby', 'Rails']

  validates :suite_type, :inclusion => {:in => TYPES}
  validates :name, :presence => true
  validates :project, :presence => true
end
