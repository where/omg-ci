class Suite < ActiveRecord::Base
  belongs_to :project
  has_many :suite_runs, :dependent => :destroy
  attr_accessible :name, :suite_type, :command, :branch, :trigger, :trigger_length, :trigger_metric, :email_notification

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
  before_save :generate_banners

  def execute!
    run = self.suite_runs.create!(:sha => current_sha,
      :status => 'running')
    note = "Running: #{current_sha}"
    tr = run_suite
    status = tr[:success] ? :success : :failed
    mark_executed!(status, run)
    notes = [note, tr[:result]].join("\n")
    run.update_attributes!(:status => status.to_s,
      :result => notes)
  end

  def needs_to_run?
    if commit_trigger?
      current_sha.to_s != Rails.cache.read(cache_key).to_s
    else
      last_run = Rails.cache.read(cache_key)
      return true unless last_run && last_run.is_a?(Time)

      (last_run + trigger_delta) < Time.now 
    end
  end

  def mark_executed!(status, run)
    if commit_trigger?
      Rails.cache.write(cache_key, current_sha)
    else
      Rails.cache.write(cache_key, Time.now)
    end

    if status == :failed && ! last_run_failed? &&
      ! self.email_notification.blank?
      Notification.failure_message(run).deliver
    end

    Rails.cache.write("LastRun:#{self.id}", status.to_s)
  end

  def last_run_failed?
    Rails.cache.fetch("LastRun:#{self.id}") == 'failed'
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

  def trigger_delta
    return nil if ! TRIGGER_METRICS.include?(self.trigger_metric)
    return nil if self.trigger_length.blank?

    self.trigger_length.to_i.send(self.trigger_metric)
  end

  def banner_image
    open(self.banner_path, "rb").read
  end

  def banner_path
    last_run = self.suite_runs.where(:status => ['success', 'failed']).last

    if last_run.blank? 
      Rails.root.join("data", "pending.jpg").to_s
    elsif last_run.success?
      Rails.root.join("data", "#{self.name}-success.jpg").to_s
    elsif last_run.failed?
      Rails.root.join("data", "#{self.name}-failure.jpg").to_s
    else
      Rails.root.join("data", "pending.jpg").to_s
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
      puts cmd
      result = [cmd, `#{cmd}`].join("\n")
      puts result
      puts "OMG"

      exit_code = $?.to_i
      success = exit_code == 0
      return {:success => success, :result => result}
    end
  end

  def generate_banners
    generate_banner("success.jpg", "#{self.name}-success.jpg", self.name, '#00A8C6')
    generate_banner("failure.jpg", "#{self.name}-failure.jpg", self.name, '#292C37')
  end

  def generate_banner(base_file, destination_file, title, text_color)
    final = Magick::Image.from_blob(open(Rails.root.join("data", base_file)).read)

    list = Magick::ImageList.new
    list << final.first

    text = Magick::Draw.new
    text.annotate(list, 4, 0, 4, 15, title) do
      self.pointsize   = 15
      self.stroke      = 'transparent'
      self.fill        = text_color
      self.font_family = "Times-Roman"
      self.font_weight = Magick::BoldWeight
    end

    File.open(Rails.root.join("data", destination_file), 'wb') do |f| 
      f.write(list.to_blob)
    end
  end
end
