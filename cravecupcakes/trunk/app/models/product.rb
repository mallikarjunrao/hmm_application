class Product < ActiveRecord::Base
  belongs_to :product_type
		
		validates_presence_of :title
		validates_presence_of :price    
    validates_numericality_of :sort

  file_column :image_file, :root_path => IMAGE_ROOT #:magick => { :geometry =>  "974x529"}
  #for uploading thumb image. janath
  file_column :thumb_image, :root_path => IMAGE_ROOT #:magick => { :geometry =>  "974x529"}
				
end
