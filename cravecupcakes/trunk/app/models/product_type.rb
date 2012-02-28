class ProductType < ActiveRecord::Base
  has_many :products
		
		validates_presence_of :title
    validates_presence_of :position
    validates_numericality_of :position, :only_integer => true, :message => "can only be whole number."
		
		acts_as_list

  file_column :image_file, :root_path => IMAGE_ROOT #:magick => { :geometry =>  "974x529"}
  #for uploading thumb image. janath
  file_column :thumb_image, :root_path => IMAGE_ROOT #:magick => { :geometry =>  "974x529"}
		
  def self.select_options
    [['choose one', 0]].concat(find(:all, :order => "title").map{|x| [x.title, x.id]})
  end
end
