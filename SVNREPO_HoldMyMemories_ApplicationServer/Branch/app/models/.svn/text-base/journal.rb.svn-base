class Journal < ActiveRecord::Base

  def self.save(journal)
    #name =  journal.original_filename
    name = journal['v_image_filename'].original_filename
    #self.content_type= advertisement_detail['v_filename'].original_filename
   
    directory = "public/journals/photos"
    # create the file path
    path = File.join(directory, name)
    #path1 = File.join(directory1, name)
    # write the file
    File.open(path, "wb") { |f| f.write(journal['v_image_filename'].read) }
    #File.open(path1, "wb") { |f| f.write(journal['v_video_filename'].read) }
#     name = journal['v_video_filename'].original_filename 
 
    end
  
  def self.save1(journal)
    name =  journal['v_video_filename'].original_filename
    directory = "public/journals/videos"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(journal['v_video_filename'].read) }
  end
  
  def self.save2(journal)
    name = journal['v_audio_filename'].original_filename
    directory = "public/journals/audios"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(journal['v_audio_filename'].read) }
  end
  
  def self.save3(journal)
    name = journal['v_paper_filename'].original_filename
    directory = "public/journals/paperworks"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(journal['v_paper_filename'].read) }
  end
  
end