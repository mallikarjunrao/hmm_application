class Special < ActiveRecord::Base
  
		validates_presence_of :title
    validates_uniqueness_of :title
		validates_presence_of :description
		validates_numericality_of :price
    validates_presence_of :image_file
    validates_presence_of :slug
    validate :unique_slug

    file_column :image_file, :root_path => IMAGE_ROOT #:magick => { :geometry =>  "974x529"}


    def unique_slug
      count = 0
      #for res in self.class.find_by_slug(slug)
      #  count += 1
      #end

      if self.class.find_by_slug(slug) && self.class.find_by_slug(slug).title != self.title && slug != ""
        errors.add_to_base("This slug is in use. Please select a unique name.")
      end
    end

		
end
