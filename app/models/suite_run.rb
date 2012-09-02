class SuiteRun < ActiveRecord::Base
  belongs_to :suite
  attr_accessible :sha, :result, :status

  STATUSES = ['success', 'running', 'failed']
  validates :status, :inclusion => {:in => STATUSES}

  STATUSES.each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end
end
