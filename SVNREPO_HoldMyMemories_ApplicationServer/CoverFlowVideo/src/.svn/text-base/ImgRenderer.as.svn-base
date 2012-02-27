package
{
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.events.FlexEvent;

	public class ImgRenderer extends Canvas
	{
		private var iconUrl : String;
		private var image : Image;
		public function ImgRenderer(icon : String)
		{
			//TODO: implement function
			super();
			
			iconUrl = icon;
			image = new Image();
			image.scaleContent = true;
			image.source = iconUrl;
			image.load(icon);
			this.addChild(image);
			this.height = 400;
			this.width = 300;
			//this.setStyle("backgroundAlpha", 0x0);
			this.addEventListener(Event.ENTER_FRAME, updateDisplay);
		}
		
		    private function updateDisplay(event:Event):void
		    {
		      this.dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
		      
		    }
	}
}