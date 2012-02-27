package skins
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import mx.skins.halo.ScrollTrackSkin;

	public class HmmScrollBarTrackSkin extends ScrollTrackSkin
	{
		public function HmmScrollBarTrackSkin()
		{
			//TODO: implement function
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var xx : Number = unscaledWidth/2 - 2;
			
			var g : Graphics = graphics;
			var m : Matrix = new Matrix();
			m.createGradientBox(unscaledWidth, unscaledHeight,0);
			g.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xffffff], [1.0, 1.0], [192,255], m);
			g.drawRect(0, xx,unscaledWidth, 4);
			g.endFill();
		}
		
	}
}