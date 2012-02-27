package skins
{
	import flash.display.Graphics;
	
	import mx.skins.ProgrammaticSkin;

	public class BreadCrumbSkin extends ProgrammaticSkin
	{
		public function BreadCrumbSkin()
		{
			//TODO: implement function
			super();
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var lineColor : int = getStyle("crumbColor");
			var g : Graphics = graphics;
			g.clear();
			g.beginFill(0);
			g.lineStyle(1,lineColor);
			g.moveTo(unscaledWidth - 9, unscaledHeight/2 - 5);
			g.lineTo(unscaledWidth - 6, unscaledHeight/2);
			g.lineTo(unscaledWidth - 9, unscaledHeight/2 +5);
			g.moveTo(unscaledWidth - 3, unscaledHeight/2 - 5);
			g.lineTo(unscaledWidth , unscaledHeight/2);
			g.lineTo(unscaledWidth -3, unscaledHeight/2 +5);
			g.endFill()
		}
	}
}