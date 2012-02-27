class AudioEncodingWorker < BackgrounDRb::MetaWorker
  set_worker_name :audio_encoding_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end

  def encode_audio(args)
    # This method is called in it's own new thread when you
    # call new worker. args is set to :args
    logger.info("Entered Audio Conversion Worker. Encoding id:#{args}")
    user_content = UserContent.find(args)
    name =  user_content['v_filename']

    directory = "#{RAILS_ROOT}/public/user_content/audios/"

    # create the file path
    path = File.join(directory, name)

    #video_file = args[:videofile]
    #image_file = args[:imagefile]
    audio_file = path#"/home/alok/workspace/updatedProjected/public/user_content/videos/2_Particle3DSample.avi"
    #logger.info("File: " + video_file)
    output_file = path
    #logger.info("Video id: " + args[:id])

    result = system("nice -n +19 ffmpeg -i #{audio_file}.input -acodec libmp3lame -ab 96000 #{audio_file}")
    logger.info(result)
    logger.info("Deleteing the uploaded file: #{audio_file}.input")
    begin
    File.delete("#{audio_file}.input")
  rescue
    logger.info("File not found: #{video_file}.input")
    end
    logger.info("done worker code")
  end
end

