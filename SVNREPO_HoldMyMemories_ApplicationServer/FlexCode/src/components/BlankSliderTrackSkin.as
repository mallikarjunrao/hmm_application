package components
{
	import flash.display.Graphics;
	
	import mx.skins.halo.SliderHighlightSkin;

	public class BlankSliderTrackSkin extends SliderHighlightSkin
	{
		
		public function BlankSliderTrackSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var fillColor : int = 0;
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			var g : Graphics = graphics;
			
			g.clear();
			g.beginFill(0xFFFFFF, 1);
			g.drawRect(0, -2.5,  unscaledWidth, 5);
			g.endFill();
			
			
		}
	}
}