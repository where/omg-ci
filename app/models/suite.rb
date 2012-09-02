class Suite < ActiveRecord::Base
  belongs_to :project
  has_many :suite_runs
  attr_accessible :name, :suite_type, :command, :branch, :trigger, :trigger_length, :trigger_metric

  TRIGGERS = ['commit', 'time']
  TRIGGER_METRICS = ['hours', 'minutes']

  validates :name,    :presence => true
  validates :project, :presence => true
  validates :command, :presence => true
  validates :branch,  :presence => true
  validates :trigger, :inclusion => {:in => TRIGGERS}
  validates :trigger_length, :numericality => {:greater_than => 0}, :allow_blank => true
  validates :trigger_metric, :inclusion => {:in => TRIGGER_METRICS}, :allow_blank => true
  validate :trigger_length_and_metric, :if => :time_trigger?

  def execute!
    run = self.suite_runs.create!(:sha => current_sha,
      :status => 'running')
    note = "Running: #{current_sha}"
    tr = run_suite
    mark_executed!
    notes = [note, tr[:result]].join("\n")
    run.update_attributes!(:status => tr[:success] ? 'success' : 'failed',
      :result => notes)
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

  def current_sha
    @current_sha ||= git.log.first
  end

  TRIGGERS.each do |trig|
    define_method "#{trig}_trigger?" do
      self.trigger == trig
    end
  end

  private

  def trigger_length_and_metric
    self.errors.add(:trigger_metric, 'cannot be blank') if self.trigger_metric.blank?
    self.errors.add(:trigger_length, 'cannot be blank') if self.trigger_length.blank?
  end

  def git
    return @git if @git
    @git = Git.open(Stage.dir(self.project.name))
    @git.fetch(git.remotes.first)
    @git.checkout("origin/#{self.branch}")

    @git
  end

  def run_suite
    stage_dir = Stage.dir(self.project.name)
    Bundler.with_clean_env do
      cmd = "cd #{stage_dir} && #{self.command}"
      result = `#{cmd}`

      exit_code = $?.to_i
      success = exit_code == 0
      return {:success => success, :result => result}
    end
  end
end
