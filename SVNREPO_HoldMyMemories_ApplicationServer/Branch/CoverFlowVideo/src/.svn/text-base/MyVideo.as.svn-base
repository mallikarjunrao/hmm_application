package
{
  import flash.events.Event;
  import flash.events.MouseEvent;
  
  import mx.containers.Canvas;
  import mx.controls.Button;
  import mx.controls.Image;
  import mx.controls.VideoDisplay;
  import mx.events.FlexEvent;

  public class MyVideo extends Canvas
  {
    private var thumb:Image;
    private var video:VideoDisplay;
    private var btn:Button;
    
    public var isPlaying:Boolean = false;
    private var thumbnail:String;
    private var flv:String;
      
    public function MyVideo(thumbnail:String,flv:String)
    {
      this.thumbnail = thumbnail;
      this.flv = flv;
      
      this.width = 402;
      this.height = 302;

      this.setStyle("backgroundColor", 0x333333);
      
      this.addEventListener(MouseEvent.CLICK, handleClick);
    }
    
    public function stop() : void
    {
    	if(video.playing)
    	{
    		video.stop();
    		video.close();
    	
    		this.removeChild(video);
    		this.dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));	
    	}else
    	{
    		isPlaying = true;

	        video = new VideoDisplay();
	        video.width = 400
	        video.height = 300
	        video.x = 1;
	        video.y = 1;
	        video.source = flv;
	        video.addEventListener(Event.ENTER_FRAME, updateDisplay);
	        this.addChild(video);
	        this.dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
    	}
    	
    }
    
    override protected function createChildren():void
    {
      thumb = new Image();
      thumb.width = 400;
      thumb.height = 300;
      thumb.x = 1;
      thumb.y = 1;
      thumb.source = thumbnail;
      this.addChild(thumb);
      
      btn = new Button();
      btn.label = "play";
      btn.width = 50;
      btn.height = 50;
      btn.setStyle("cornerRadius", 25);
      btn.setStyle("verticalCenter", 0);
      btn.setStyle("horizontalCenter", 0);
      this.addChild(btn);
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
      if (isPlaying)
      {
        isPlaying = false;
        if (this.contains(video))
        {
          video.close();
          this.removeChild(video);
        }
        this.dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
      }
      else
      {
        isPlaying = true;

        video = new VideoDisplay();
        video.width = 400
        video.height = 300
        video.x = 1;
        video.y = 1;
        video.source = flv;
        video.addEventListener(Event.ENTER_FRAME, updateDisplay);
        this.addChild(video);
        this.dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
      }
    }
    
  }
}