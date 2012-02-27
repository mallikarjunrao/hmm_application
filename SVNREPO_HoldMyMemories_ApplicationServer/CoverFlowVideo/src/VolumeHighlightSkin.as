package components
{
	import flash.display.Graphics;
	
	import mx.skins.halo.SliderHighlightSkin;

	public class VolumeHighlightSkin extends SliderHighlightSkin
	{
		public function VolumeHighlightSkin()
		{
			//TODO: implement function
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			var g : Graphics = graphics;
			g.clear();
			g.beginFill(0x5e2700, 1);
			var count : int = unscaledWidth/6;
			for(var i : int = 0; i < count; i++)
			{
				var _xx : Number = i*6;
				g.drawRect(_xx, -4, 3, unscaledHeight+9);
			}
			g.endFill();
		}
	}
}