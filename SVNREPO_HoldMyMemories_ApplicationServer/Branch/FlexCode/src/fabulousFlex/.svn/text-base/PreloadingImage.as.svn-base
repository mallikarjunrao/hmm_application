package fabulousFlex
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import mx.containers.TitleWindow;
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;

	/**
	 * Flex Image subclass with Preloading graphic
	 * Display.
	 * Uses the Flex PopUpManager to show and hide the 
	 * _popupWindow that is the preloading 
	 * graphic display.
	 * set the preloaderTitleWindow property to one of the preloader
	 * supplied classes or write your own.
	 * */
	public class PreloadingImage extends Image
	{
		private var _popupWindowClass:Class = null;
		private var _popupWindow:TitleWindow = null;
		private var _popupWindowCenterWindow:UIComponent = null;
		/**
		 * connect to open and complete events of image for showing
		 * and hiding preloading display
		 */
		public function PreloadingImage():void
		{
			addEventListener(Event.OPEN,onOpen);
			addEventListener(Event.COMPLETE,onComplete);
			addEventListener(ProgressEvent.PROGRESS,onProgress);
		}
		
		/** TitleWindow subclass that displayes the preloading**/
		public function set preloaderTitleWindow(val:Class):void
		{
			_popupWindowClass = val;
			//remove and popups if existed
			if(_popupWindow!=null)
			{
				PopUpManager.removePopUp(_popupWindow);
				//removeChild(_popupWindow);
				_popupWindow = null;
			}
		}
		
		/** window to center popup over, if left null then
		 * will center over image be default**/
		public function set preloadingCenterOverWindow(val:UIComponent):void
		{
			_popupWindowCenterWindow = val;
		}	
		
		/** call progress event if titlewindow supports interface**/
		protected function onProgress(event:ProgressEvent):void
		{
			if ((_popupWindow!=null)&&(_popupWindow is IProgress))
			{
				IProgress(_popupWindow).progress(event.bytesLoaded,event.bytesTotal);
			}
		}
		
		/** when image is done loading remove the popup**/
		protected function onComplete(event:Event):void
		{
			if(_popupWindow)
			{
				PopUpManager.removePopUp(_popupWindow);
				//removeChild(_popupWindow);
				_popupWindow = null;
			}	
		}	
		
		/**
		 * the start loading image event, in which I show the preloading
		 * popup.
		 */
		protected function onOpen(event:Event):void
		{
			if(_popupWindowClass)
			{
				if(_popupWindowCenterWindow==null)
				{	_popupWindow = TitleWindow(PopUpManager.createPopUp(this,_popupWindowClass));
					//_popupWindow = new _popupWindowClass();
					//addChild(_popupWindow);
				}
				else
				{
					//remove previous if exists
					PopUpManager.removePopUp(_popupWindow);
					//removeChild(_popupWindow);
					_popupWindow = null;
					_popupWindow = TitleWindow(PopUpManager.createPopUp(_popupWindowCenterWindow,_popupWindowClass));
					//_popupWindow = new _popupWindowClass();
					//addChild(_popupWindow);
				}
				//PopUpManager.centerPopUp(_popupWindow);
			}	
		}
		
	}
}