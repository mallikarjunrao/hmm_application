package components
{
	import mx.controls.VideoDisplay;

	import mx.controls.VideoDisplay;
	import mx.core.mx_internal;
	
	use namespace mx_internal;

	public class SmoothVideoDisplay extends VideoDisplay
	{
		
		private var _smoothing:Boolean = false;
		
		public function SmoothVideoDisplay()
		{
			super();
			
		}
		
		override public function play():void
		{
			super.play();
			videoPlayer.smoothing = true;
		}
		
	}
}