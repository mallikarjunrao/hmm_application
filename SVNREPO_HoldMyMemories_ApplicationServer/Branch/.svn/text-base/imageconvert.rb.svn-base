require 'rubygems'
require 'RMagick'
include Magick

def resizeWithoutBorder(img, destinationW, destinationH, name)
	 # maxU = destinationH/img.rows
	 # maxV = destinationW/img.columns
	 
	 temp_image = nil
	 if(img.rows > img.columns)
		 w = destinationH*img.columns/img.rows
		 puts w
		 h = destinationH
		 x = (destinationW - w)/2
		 y = 0
		 temp_img = img.scale(w, h)
		 
	 else
		 w = destinationW
		 h = destinationW*img.rows/img.columns
		 
		# puts h
		 #puts w
		 y = (destinationH - h)/2
		 x = 0
		# puts x
		# puts y
		 temp_img = img.scale(w, h)
		 
		 
		 
	 end
puts "Executing..."
		exec("convert ./public/user_content/photos/#{name} -resize #{w}x#{h} ./public/user_content/photos/coverflow/#{name}")

	 #finalImage.write("output.jpg")
	 #finalImage.write("#{path}")
 end


files = Dir.entries("./public/user_content/photos/")
existing = Dir.entries("./public/user_content/photos/coverflow/")
for file in files
    if(file != "." || file !="..")
	
	puts "Opening file: #{file}"
	begin
	img = Image.read("./public/user_content/photos/#{file}").first
	resizeWithoutBorder(img, 320, 240, file)
      
	rescue
	  puts "Cannot open Image"
	end
	
    end
end
