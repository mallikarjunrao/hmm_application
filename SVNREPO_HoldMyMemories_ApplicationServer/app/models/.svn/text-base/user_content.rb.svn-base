class UserContent < ActiveRecord::Base
  belongs_to :mobile_gallery, :foreign_key => "gallery_id"
  #  after_save :clear_homepage_data1
  #  def clear_homepage_data1
  #    clear_homepage_data
  #  end
  @command_mencoder = "mencoder input.avi -o output.avi -oac lavc -ovc lavc -lavcopts vcodec=xvid:acodec=mp3"
  @command_ffmpeg = " -vcodec xvid -acodec mp3 -ab 96 "
  
  def self.save1(obj,id)
    name =  "#{id}_#{obj.original_filename}"
    #v_filename = user_content['v_filename[]'].original_filename
    #self.content_type= advertisement_detail['v_filename'].original_filename
    directory = "public/user_content/photos"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(obj.read) }
  end

  def self.save2( user_content)

    args = user_content.id
    logger.info(args.display)
    directory = "#{RAILS_ROOT}/public/user_content/videos/"
    directoryThumbnail = directory + "thumbnails/"

    # create the file path
    name = user_content.v_filename
    path = File.join(directory, name)
    thumbnailPath = File.join(directoryThumbnail, name)
    image_file = thumbnailPath
    video_file = path
    result = system("nice -n +19 ffmpeg -i #{video_file}.avi -ss 00:00:03 -t 00:00:01 -vcodec mjpeg -vframes 1 -an -f rawvideo -s 320x240 #{image_file}.jpg")
    logger.info(result)
    logger.info '************************************Calling the worker************************************************'
    # worker = MiddleMan.worker(:video_encoder_worker)
    #worker.encode_video(args, false)
    MiddleMan.worker(:video_encoder_worker).async_encode_video(:arg => args)
    #worker = MiddleMan.worker(:video_encoder_worker)
    #worker.async_encode_videok(:arg => user_content.id)
    #session[:job_key] = MiddleMan.new_worker(:worker => :video_encoder_worker, :job_key => 'the_key', :data => args)
    # MiddleMan.send_request(:worker => :fibonacci_worker, :worker_method => :encode_video, :data => args,:job_key => session[:job_key])

  end

  def self.save3(user_content)
	  args = user_content.id
    logger.info(args.display)
    directory = "#{RAILS_ROOT}/public/user_content/audios/"
    # create the file path
    #logger.info(result)
    logger.info '************************************Calling the worker************************************************'
    worker = MiddleMan.worker(:audio_encoding_worker).async_encode_audio(:arg => args) 
    # worker.encode_audio(args)
  end


end
