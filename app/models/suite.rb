class Suite < ActiveRecord::Base
  belongs_to :project
  attr_accessible :name, :suite_type

  TYPES = ['Ruby', 'Rails']

  validates :suite_type, :inclusion => {:in => TYPES}
  validates :name, :presence => true
  validates :project, :presence => true

  #TODO this is premliniary and untested
  def run
    stage_dir = Stage.dir(self.project.name)
    Bundler.with_clean_env do
      cmd = "cd #{stage_dir} && bundle exec rake db:schema:load && bundle exec rake"
      puts cmd

      result = `#{cmd}`

      exit_code = $?.to_i
      success = exit_code == 0
      {:sucess => success, :result => result}
    end
  end
end
