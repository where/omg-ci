class Project < ActiveRecord::Base
  attr_accessible :name, :git_repo
  scope :omg_pull_request, where(:omg_pull_request => true)

  validates :name, :presence => true
  validates :git_repo, :presence => true
  before_create :clone
  before_destroy :remove_repo
   
  has_many :suites, :dependent => :destroy

  private

  def remove_repo
    FileUtils.rm_rf(Stage.dir(self.name))
  end

  def clone
    Git.clone(self.git_repo, Stage.dir(self.name))
  end
end
