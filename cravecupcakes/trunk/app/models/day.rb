class Day < ActiveRecord::Base
  has_many :cupcakes_day
  has_many :cupcakes, :through => :cupcakes_day, :order => 'is_breakfast desc, title'

  has_many :mini_cupcakes_day
  has_many :mini_cupcakes, :through => :mini_cupcakes_day, :order => 'title'

		validates_presence_of :title
		validates_presence_of :slug
		validates_uniqueness_of :slug
		
		def self.today
      today = TZTime::LocalTime::Builder.new('Central Time (US & Canada)').now.strftime("%Y-%m-%d").to_date
    _day = today.wday
    _day = 7 if _day == 0
    find(:first, :conditions => {:id => _day}, :include => :cupcakes, :order => 'is_breakfast desc, cupcakes.title' )
		end

    def self.select_options
    [['Select', 0]].concat(find(:all, :order => "id").map{|x| [x.title, x.title]})
  end
end
