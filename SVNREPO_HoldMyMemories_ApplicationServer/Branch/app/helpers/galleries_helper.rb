module GalleriesHelper
	def resize(img, destinationH, destinationW,path)
		# maxU = destinationH/img.rows
		# maxV = destinationW/img.columns
		
		finalImage =  Image.new(destinationW,destinationH) { self.background_color = "black" }
		if(img.rows > img.columns)
			w = destinationH*img.columns/img.rows
			puts w
			h = destinationH
			x = (destinationW - w)/2
			y = 0
			img.scale!(w, h)
			finalImage = finalImage.composite(img,x,y,CopyCompositeOp) 
		else
			w = destinationW
			h = destinationW*img.rows/img.columns
			
			puts h
			puts w
			y = (destinationH - h)/2
			x = 0
			puts x
			puts y
			img.scale!(w, h)
			
			finalImage = finalImage.composite(img,x,y,CopyCompositeOp) 
			
		end
		return finalImage
		#finalImage.write("output.jpg")
		#finalImage.write("#{path}")
	end
	
end
