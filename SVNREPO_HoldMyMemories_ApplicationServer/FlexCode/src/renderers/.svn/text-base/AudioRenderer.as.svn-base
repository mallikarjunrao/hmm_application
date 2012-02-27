package renderers
{
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.core.Application;
	import mx.events.FlexEvent;

	public class AudioRenderer extends Canvas 
	{
		public static const type : String = "exportableAudio";	
		private var url : String; 
		private var urlRequest : URLRequest;
		public var audio : Sound;
		public var audioChannel : SoundChannel =  new SoundChannel();
		public var isPaused : Boolean;
		public var channelPosition : Number;
		public var loaded : Boolean = false;
		//pass parameter to ExportableAudio() of type URLRequest 
		public function AudioRenderer()
		{
			super();
			var request:URLRequest = new URLRequest();
			audio = new Sound();
			isPaused = true;
			this.addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
			
		}
		
		private function handleCreationComplete(event : Event) : void
		{
			var playBut : Button = new Button();
			playBut.label = "Play";
			playBut.width = 16;
			playBut.height = 16;
			playBut.x = (200 - 16)/2;
			playBut.y = (200 - 16)/2;
			playBut.toggle = true
			this.height = 200;
			this.width = 200;
			
			playBut.styleName = "playPauseStyle";
			playBut.addEventListener(MouseEvent.CLICK, handlePlayClicked);
			this.addChild(playBut);
			this.setStyle("backgroundColor", 0xACACAC);
			this.setStyle("backgroundAlpha", 0.8);
			channelPosition = 0;
			
			
		}
		
		public function dragStartEventHandler(event:MouseEvent):void 
        {
            Application.application.parent.addEventListener(MouseEvent.MOUSE_UP, dragDropEventHandler);
            this.alpha = 0.6;
            this.startDrag(false, new Rectangle(0,0, this.parent.width - this.width, this.parent.height - this.height));
        }
        
        public function dragDropEventHandler(event:MouseEvent):void 
        {
            this.alpha = 1;
            this.stopDrag();
        } 
		
		private function handlePlayClicked( event : Event) : void
		{
			if(!loaded)
			{
				var urlreq : URLRequest = new URLRequest(url);
			audio.load(urlreq);
			isPaused = true;	
				loaded = true;
			}
			
			if(isPaused)
			{
				
				audioChannel = audio.play(channelPosition);
				isPaused = false;
			}else
			{
				channelPosition = audioChannel.position;
				isPaused = true;
				audioChannel.stop();
			}
				
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			source = value.icon;
		}
		
		
		
		
		public function getType():String
		{
			return type;
		}
		
		public function get source() : String
		{
			return urlRequest.url;
		}
		
		public function set source(val : String) : void
		{
			if(urlRequest == null)
				urlRequest = new URLRequest(val);
			url = val;
			this.toolTip = val;
			//audio.load(urlRequest);	
		}
	
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
        	var g : Graphics = graphics;
        	g.lineStyle(1, 0);
        	
        	
		}
		
	}
}