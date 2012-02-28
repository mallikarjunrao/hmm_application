class DynoImage < ActiveRecord::Base
		belongs_to :dyno_page
  validates_presence_of :caption
		acts_as_list :scope => 'dyno_page_id'
		
  file_column :image, :root_path => IMAGE_ROOT #:magick => { :geometry =>  "974x529"}
  file_column :thumb, :root_path => IMAGE_ROOT #:magick => { :geometry =>  "225x220"}
end
