package skins
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	
	import mx.skins.halo.ScrollThumbSkin;

	public class HmmScrollBarThumbSkin extends ScrollThumbSkin
	{
		public function HmmScrollBarThumbSkin()
		{
			//TODO: implement function
			super();
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var g : Graphics = graphics;
			
			g.beginGradientFill(GradientType.LINEAR, [0xACACAC, 0xc0c0c0], [0.7, 0.7], [128, 255]);
			g.drawRect(0,0,10,40);
			g.endFill();
		}
		
	}
}