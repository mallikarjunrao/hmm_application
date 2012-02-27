package components
{
	import mx.skins.halo.SliderTrackSkin;

	public class ScrollerTrackSkin extends SliderTrackSkin
	{
		public function ScrollerTrackSkin()
		{
			//TODO: implement function
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var g : Graphics = graphics;
			g.clear();
			g.lineStyle(0,0xffffff,0.4);
			g.drawRect();
			g.beginFill(0xFFFFFF,0.4);
			g.drawRect(0,-2, unscaledWidth-3, unscaledHeight+1);
			g.endFill();
			 
		}
	}
}