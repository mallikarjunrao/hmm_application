class MiniCupcake < ActiveRecord::Base
  has_many :mini_cupcakes_day, :dependent => true
  has_many :days, :through => :mini_cupcakes_day
		validates_presence_of :title
    validates_uniqueness_of :title
		validates_presence_of :description
    validates_presence_of :cake
    validates_presence_of :slug
    validate :unique_slug
    validates_presence_of :thumb_image
    validates_presence_of :image_file
    
				
  file_column :image_file, :root_path => IMAGE_ROOT #:magick => { :geometry =>  "974x529"}
  #for uploading thumb image. janath
  file_column :thumb_image, :root_path => IMAGE_ROOT #:magick => { :geometry =>  "974x529"}

  def unique_slug
      if self.class.find_by_slug(slug) && self.class.find_by_slug(slug).id != self.id && slug != ""
        errors.add_to_base("This slug is in use. Please select a unique name.")
      end
  end

  def day_ids=(day_ids)
    mini_cupcakes_day.each do |cup_day|
      cup_day.destroy unless day_ids.include? cup_day.day_id
    end
				
    day_ids.each do |day_id|
      self.mini_cupcakes_day.create(:day_id => day_id) unless mini_cupcakes_day.any? { |d| d.day_id == day_id }
    end
  end
		
end
