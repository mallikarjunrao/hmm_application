package components
{
	import flash.display.Graphics;
	
	import mx.skins.halo.SliderThumbSkin;

	public class VolumeSliderThumb extends SliderThumbSkin
	{
		public function VolumeSliderThumb()
		{
			//TODO: implement function
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var g : Graphics = graphics;
			g.lineStyle(1, 0xFFFFFF);
			g.clear();
			g.beginFill(0xFFFFFF, 0.4);
			g.drawRect(0,0, unscaledWidth/2, unscaledHeight+1);
			g.endFill();
			
		}
	}
}