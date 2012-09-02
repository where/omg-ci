class Suite < ActiveRecord::Base
  belongs_to :project
  attr_accessible :name, :suite_type, :command, :branch

  TYPES = ['Ruby', 'Rails']

  validates :suite_type, :inclusion => {:in => TYPES}
  validates :name,    :presence => true
  validates :project, :presence => true
  validates :command, :presence => true
  validates :branch,  :presence => true

  def execute!
    note = "Running: #{current_sha}"
    test_results = run
    mark_executed!
  end

  def needs_to_run?
    current_sha.to_s != Rails.cache.read(cache_key).to_s
  end

  def mark_executed!
    Rails.cache.write(cache_key, current_sha)
  end

  def cache_key
    "Suite::#{self.id}"
  end

  private

  def current_sha
    @current_sha ||= git.log.first
  end

  def git
    return @git if @git
    @git = Git.open(Stage.dir(self.project.name))
    @git.fetch(git.remotes.first)
    @git.checkout("origin/#{self.branch}")

    @git
  end

  def run
    stage_dir = Stage.dir(self.project.name)
    Bundler.with_clean_env do
      cmd = "cd #{stage_dir} && #{self.command}"
      result = `#{cmd}`

      exit_code = $?.to_i
      success = exit_code == 0
      {:success => success, :result => result}
    end
  end
end
