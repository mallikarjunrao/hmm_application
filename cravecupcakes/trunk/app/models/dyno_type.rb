class DynoType < ActiveRecord::Base
		has_many :dyno_pages, :order => 'page_on desc'
		
  validates_presence_of :title
  validates_presence_of :slug
		
  def self.select_options
    [['choose one', 0]].concat(find(:all, :order => "title").map{|x| [x.title, x.id]})
  end		
end
