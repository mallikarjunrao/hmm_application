class Session < ActiveRecord::Base
  def self.clear(time = 24.hour)
    delete_all "created_at < '#{time.ago.to_s(:db)}'"
  end
end
