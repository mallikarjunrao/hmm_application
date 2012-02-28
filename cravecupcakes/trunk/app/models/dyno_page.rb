class DynoPage < ActiveRecord::Base
		belongs_to :dyno_type
		has_many :dyno_images, :order => 'position'
		
  validates_presence_of :title
  validates_presence_of :slug
  validates_uniqueness_of :slug, :scope => "dyno_type_id"
		validates_exclusion_of :dyno_type_id, :in => -1..0, :message => "must be selected"
		validates_length_of :summary, :maximum=>1000, :allow_nil => true

		
		def first_image( img_size )
			if self.product_images && self.product_images[0] 
				self.product_images[0].img_path( img_size )
			else 
				''
			end
		end

		def first_image_path
			if self.dyno_images && self.dyno_images[0] 
			  img = self.dyno_images[0]
					if img.image_relative_path && ! img.image_relative_path.blank?
			    "/images/dyno_image/image/#{img.image_relative_path}"
					else 
					  ''
					end
			else 
			  nil
			end
		end

		def thumb_path
			if self.dyno_images && self.dyno_images[0] 
			  img = self.dyno_images[0]
			  "/images/dyno_image/thumb/#{img.thumb_relative_path}"
			else 
			  nil
			end
		end
end
