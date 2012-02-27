package components
{
	import flash.display.Graphics;
	
	import mx.skins.halo.SliderTrackSkin;

	public class VolumeControlTrackSkin extends SliderTrackSkin
	{
		public function VolumeControlTrackSkin()
		{
			//TODO: implement function
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			var g : Graphics = graphics;
			g.clear();
			g.beginFill(0xda8d59, 1);
			var count : int = unscaledWidth/6;
			for(var i : int = 0; i < count; i++)
			{
				var _xx : Number = i*6;
				g.drawRect(_xx, -3, 3, unscaledHeight+7);
			}
			g.endFill();
		}
		
	}
}