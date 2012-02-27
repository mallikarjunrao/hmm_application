package components
{
	import flash.display.Graphics;
	
	import mx.skins.halo.SliderTrackSkin;

	public class VideoProgressTrackSkin extends SliderTrackSkin
	{
		public function VideoProgressTrackSkin()
		{
			//TODO: implement function
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var g : Graphics = graphics;
			if(unscaledWidth < 4)
				unscaledWidth = 3;
			g.clear();
			g.lineStyle(1,0xffffff,0.4);
			g.drawRect(-3,-5, 264, unscaledHeight+7);
			g.beginFill(0xFFFFFF,0.4);
			g.drawRect(0,-2, unscaledWidth-3, unscaledHeight+1);
			g.endFill();
			 
		}
		
	}
}