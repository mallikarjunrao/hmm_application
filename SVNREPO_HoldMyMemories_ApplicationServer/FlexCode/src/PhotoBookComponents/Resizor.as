package PhotoBookComponents
{
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	/**
	 * Resizor
	 * 
	 * This is a helper class designed to facilitate the resizing of a Photograph right on
	 * the scrapbook page.
	 */
	
	public class Resizor
	{
		public var target:ResizableCanvas;
		public var completeCallback:Function;
		public var isResizing:Boolean = false;
		
		private var startResizeX:Number;
		private var startResizeWidth:Number;
		private var startResizeY:Number;
		private var startResizeHeight:Number;
		
		/**
		 * constructor
		 * 
		 * The constructor is given the photograph to resize and a function to call
		 * when resizing completes. You go with the event approach and make this class
		 * extend EventDispatcher and use an event instead of a callback. I'm presenting
		 * this is a simpler alternative.
		 */
		public function Resizor( comp:ResizableCanvas, completeFn:Function )
		{
			target = comp;
			completeCallback = completeFn;
		}
		
		/**
		 * beginResize
		 * 
		 * This function is called with the MouseDown event that triggers the resize
		 * sequence. Event handlers are installed to watch the mouse actions.
		 */
		public function beginResize( event:MouseEvent ) : void
		{		
			var parent:UIComponent = target.parent as UIComponent;
			
			parent.addEventListener(MouseEvent.MOUSE_MOVE, doMove);
			parent.addEventListener(MouseEvent.MOUSE_UP, stopMove);
			parent.addEventListener(MouseEvent.ROLL_OUT, stopMove);
			
			startResizeX = event.stageX;
			startResizeWidth = target.imageWidth;
			startResizeY = event.stageY;
			startResizeHeight = target.imageHeight;
			
			isResizing = true;
		}
		
		/**
		 * handleResizeMove
		 * 
		 * This function is called as the mouse is being moved (with the button held
		 * down). The new size of the photograph is calculated and shown.
		 */
		private function doMove( event:MouseEvent ) : void
		{
			var diffX:Number = event.stageX - startResizeX;
			var diffY:Number = event.stageY - startResizeY;
			var ratio:Number = 1; 
			
			var imageWidth:Number = startResizeWidth + diffX;
			var imageHeight:Number = startResizeHeight + diffY;
			
			if( startResizeWidth < startResizeHeight) ratio = imageHeight/startResizeHeight;
			else ratio = imageWidth/startResizeWidth;
			
			target.setImageSize(startResizeWidth*ratio, startResizeHeight*ratio);			
		}
		
		/**
		 * handleResizeEnd
		 * 
		 * This function is called once the mouse has been released. The event handlers are
		 * removed so further actions on the photograph aren't interpreted as a resize.
		 */
		private function stopMove( event:MouseEvent ) : void
		{
			var parent:UIComponent = target.parent as UIComponent;
			
			parent.removeEventListener(MouseEvent.MOUSE_MOVE, doMove);
			parent.removeEventListener(MouseEvent.MOUSE_UP, stopMove);
			parent.removeEventListener(MouseEvent.ROLL_OUT, stopMove);
			
			if( completeCallback != null ) {
				completeCallback();
			}
			
			isResizing = false;
		}
	}
}