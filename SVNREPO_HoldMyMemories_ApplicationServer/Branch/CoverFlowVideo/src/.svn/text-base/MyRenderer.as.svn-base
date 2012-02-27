package
{
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.net.URLRequest;
  
  import mx.containers.Canvas;
  import mx.controls.Alert;
  import mx.controls.Button;
  import mx.controls.Image;
  import mx.controls.VideoDisplay;
  import mx.events.FlexEvent;

  public class MyRenderer extends Canvas
  {
    private var thumb:Image;
    private var video:VideoDisplay;
    private var btn:Button;
    
    public var isPlaying:Boolean = false;
    private var thumbnail:String;
    private var _type:String;
     private var _sound : Sound; 
     private var _channel : SoundChannel;
    public function MyRenderer(thumbnail:String,type : String )
    {
      this.thumbnail = thumbnail;
      this._type = type;
      
      this.width = 402;
      this.height = 302;

      this.setStyle("backgroundAlpha", 0x0);
      
      
      
      
      
    }
    
    public function stop() : void
    {
    	switch(_type)
			{
				case 'image':
								
								break;
				case 'video':
								 stopVideo();
								break;
				case 'audio':
								stopAudio();
								break;
					
			}
    	
    	
    }
    
    private function stopAudio() : void
    {
    	if(_channel)
    	{	
    		_channel.stop();
    		isPlaying = false;
    	}
    	
    }
    
    private function stopVideo() : void
    {
    	if(video && video.playing)
    	{
    		video.stop();
    		video.close();
    	
    		this.removeChild(video);
    		video = null;
    		this.dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));	
    	}else
    	{
    		
	        
    	}
    }
    
    private function playVideo() : void
    {
    	isPlaying = true;
			video = new VideoDisplay();
	        video.width = 400
	        video.height = 300
	        video.x = 1;
	        video.y = 1;
	        video.source = "/user_content/videos/"+thumbnail+".flv";
	        video.addEventListener(Event.ENTER_FRAME, updateDisplay);
	        this.addChild(video);
	        this.dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
    }
    
    
    private function playAudio() : void
    {
    	var url : String = "/user_content/audios/"+thumbnail;
    	try
    	{
    		if(!isPlaying)
    		{
    			_sound = new Sound(new URLRequest(url));
    			_channel = _sound.play();
    			isPlaying = true;	
    		}
    			
    	}
    	catch(e : Error) {
    		Alert.show("Audio file is missing. Please contact support.");
    	}
    }
    
    override protected function createChildren():void
    {
      thumb = new Image();
      
      thumb.x = 1;
      thumb.y = 1;
      switch(_type)
      {
      	case 'video':
      					thumb.source = "/user_content/videos/thumbnails/"+thumbnail+".jpg";
      					thumb.width = 320;
      					thumb.height = 240;
      					break;
      	case 'audio':
      					thumb.source = "/user_content/audios/speaker.jpg";
      					thumb.width = 320;
      					thumb.height = 240;
      					break;
      	case 'image':
      					thumb.source = "/user_content/photos/journal_thumb/"+thumbnail;
      					thumb.width = 360;
      					thumb.height = 254;
      					break;
      }
      thumb.setStyle("verticalCenter", 0);
      thumb.setStyle("horizontalCenter", 0);
      this.addChild(thumb);
      
      btn = new Button();
      btn.label = "play";
      btn.width = 50;
      btn.height = 50;
      btn.setStyle("cornerRadius", 25);
      btn.setStyle("verticalCenter", 0);
      btn.setStyle("horizontalCenter", 0);
      this.addChild(btn);
      switch(_type)
      {
      		case 'image':
      						btn.visible = false;
      						break;
      		case 'video':
      		case 'audio':
      						this.addEventListener(MouseEvent.CLICK, handleClick);
      						break;						
      }
    }
    
    private function updateDisplay(event:Event):void
    {
      if (isPlaying)
      {
        this.dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
      }
    }
    
    private function handleClick(event:Event):void
    {
      switch(_type)
      {
      	case 'video':
      					playVideo();
      					break;
      	case 'audio':
      					playAudio();
      					break;
      }			
    }
    
  }
}