package custompreloader
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.preloaders.DownloadProgressBar;
	public class PreloaderGlassLoading extends DownloadProgressBar
	{
		[Embed(source="hourglass_en.swf")]
		private var preloaderglass : Class;
		private var preloaderglasstest : DisplayObject;
		
		public function PreloaderGlassLoading()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,handleEnterFrame)
		}
		
		private function handleEnterFrame(event : Event) : void
		{
			//removeEventListener(Event.ADDED_TO_STAGE,handleEnterFrame);
			
			preloaderglasstest = new preloaderglass();
			this.addChild(preloaderglasstest);
			preloaderglasstest.x = (stage.stageWidth-preloaderglasstest.width)/2;
			preloaderglasstest.y = (stage.stageHeight-preloaderglasstest.height)/2;
			
		}
		
		 override public function set preloader(preloader:Sprite):void {
            // Listen for the relevant events
            preloader.addEventListener(
                ProgressEvent.PROGRESS, myHandleProgress);   
            preloader.addEventListener(
                Event.COMPLETE, myHandleComplete);
        }
    
        // Event listeners for the ProgressEvent.PROGRESS event.
        private function myHandleProgress(event:ProgressEvent):void {
            /* progressText.appendText("\n" + "Progress l: " + 
                event.bytesLoaded + " t: " + event.bytesTotal); */
        }
    
        // Event listeners for the Event.COMPLETE event.
        private function myHandleComplete(event:Event):void {
            //progressText.appendText("\n" + "Completed");
            var timer:Timer = new Timer(2000,1);
            timer.addEventListener(TimerEvent.TIMER, dispatchComplete);
            timer.start();
        }
        
          
        // Event listener for the Timer to pause long enough to 
        // read the text in the download progress bar.
        private function dispatchComplete(event:TimerEvent):void {
            dispatchEvent(new Event(Event.COMPLETE));
        }


    

	}
}