class DataFile < ActiveRecord::Base
  def self.save(upload)
    name =  upload['menu_file'].original_filename
    directory = "public/images/ui"
    # create the file path
    path = File.join(directory, "navigation.gif")
    # write the file
    File.open(path, "wb") { |f| f.write(upload['menu_file'].read) }
  end
  
  def self.save_popup_stnd(upload)
    name =  upload['standard_file'].original_filename
    directory = "public/images"
    # create the file path
    path = File.join(directory, "special_decorations.jpg")
    # write the file
    File.open(path, "wb") { |f| f.write(upload['standard_file'].read) }
  end
  
  def self.save_popup_mini(upload)
    name =  upload['mini_file'].original_filename
    directory = "public/images"
    # create the file path
    path = File.join(directory, "mini_special_decorations.jpg")
    # write the file
    File.open(path, "wb") { |f| f.write(upload['mini_file'].read) }
  end
  
end
