class VideoEncoderWorker < BackgrounDRb::MetaWorker
  set_worker_name :video_encoder_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
    logger.info 'Worker Created...'
  end

  def encode_video(args)
    # This method is called in it's own new thread when you
    # call new worker. args is set to :args
    logger.info("Entered VideoConversionWorker encoding video with id:#{args}.")
    user_content = UserContent.find(args)
    name =  user_content['v_filename']

    directory = "#{RAILS_ROOT}/public/user_content/videos/"
    directoryThumbnail = directory + "thumbnails/"
    # create the file path
    path = File.join(directory, name)
    thumbnailPath = File.join(directoryThumbnail, name)
    #video_file = args[:videofile]
    #image_file = args[:imagefile]
    video_file = path#"/home/alok/workspace/updatedProjected/public/user_content/videos/2_Particle3DSample.avi"
    #logger.info("File: " + video_file)
    image_file = thumbnailPath
    #logger.info("Video id: " + args[:id])

    result = system("nice -n +19 ffmpeg -i #{video_file}.avi -vb 512000 -vol 320 -ab 96000 -ar 22050 -s 320x240 #{video_file}.flv")
    logger.info(result)
    result2= system("nice -n +19 ffmpeg -i #{video_file}.flv -aspect 4:3 -ab 56 -ar 22050 -b 500 -s 320x240 -vcodec libxvid -acodec #{image_file}.avi")
    logger.info(result2)
    #logger.info("Deleteing the uploaded file: #{video_file}.avi")
#    begin
#      File.delete("#{video_file}.avi")
#    rescue
#      logger.info("File not found: #{video_file}.avi")
#    end
      logger.info("done worker code")
   end
end

