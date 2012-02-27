package custompreloader
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;
	
	public class PreloaderHourGlass extends DownloadProgressBar
	{
		[Embed(source="hourglass_en.swf")]
		private var preloaderglass : Class;
		
		[Embed(source="hourglass_en1.swf")]
		private var initializingGlass : Class;
		
		private var inaitailizeFlag : Boolean = false;
		
		private var preloaderglasstest : DisplayObject;
		public function PreloaderHourGlass()
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

            preloader.addEventListener(
                FlexEvent.INIT_PROGRESS, myHandleInitProgress);
            preloader.addEventListener(
                FlexEvent.INIT_COMPLETE, myHandleInitEnd);
        }
    
        // Event listeners for the ProgressEvent.PROGRESS event.
        private function myHandleProgress(event:ProgressEvent):void {
            /* progressText.appendText("\n" + "Progress l: " + 
                event.bytesLoaded + " t: " + event.bytesTotal); */
        }
    
        // Event listeners for the Event.COMPLETE event.
        private function myHandleComplete(event:Event):void {
            //progressText.appendText("\n" + "Completed");
        }
    
        // Event listeners for the FlexEvent.INIT_PROGRESS event.
        private function myHandleInitProgress(event:Event):void {
        	if(!inaitailizeFlag)
        	{
        		var initailize = new initializingGlass();
        		try
        		{
        			this.removeChild(preloaderglasstest);
        			this.removeChild(initailize);
        		}
        		catch(errorObj : ArgumentError)
        		{
        			trace("Error occured while removing the child");
        		}
        		
        		
        		this.addChild(initailize);
        		initailize.x = (stage.stageWidth-initailize.width)/2;//350;
        		initailize.y = (stage.stageHeight-initailize.height)/2;//220;
        		inaitailizeFlag = true;
        	}
           // progressText.appendText("\n" + "App Init Start");n
        }
    
        // Event listeners for the FlexEvent.INIT_COMPLETE event.
        private function myHandleInitEnd(event:Event):void {
           // msgText.appendText("\n" + "App Init End");
            inaitailizeFlag = false;
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