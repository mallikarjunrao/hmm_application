package qs.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import mx.core.Application;
	import mx.messaging.messages.HTTPRequestMessage;
	
	public class HmmBitmapTile extends BitmapTile
	{
		protected var imageId : String;
		private static var navUrl : String;
		public function HmmBitmapTile()
		{
			//TODO: implement function
			super();
			addEventListener(MouseEvent.DOUBLE_CLICK, handleDoubleClick);
			this.doubleClickEnabled = true;
			toolTip = "Double click to see an enlarged view";
			navUrl = Application.application.parameters.navigateTo;
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			
			
		}
		
		private function handleDoubleClick(event : Event) : void
		{
			/* var popup : IFlexDisplayObject = PopUpManager.createPopUp(Application.application as DisplayObject, PreviewPopup, true);
			PopUpManager.centerPopUp(popup);
			//(popup as PreviewPopup).galleryType = currentGallery.type;
			var obj : WebFileVO = new WebFileVO();
			obj.type = "image";
			obj.icon = this.data.toString();
			(popup as IDataRenderer).data = obj; */
			var req : URLRequest = new URLRequest(navUrl)
			var obj : URLVariables = new URLVariables();
			obj.id = data.id;
			obj.hmmtype = data.hmmtype;
			req.method = HTTPRequestMessage.GET_METHOD;
			
			obj.galleryid = Application.application.parameters.backid;
			req.data = obj;
			navigateToURL(req, "_self");
		}
		
	}
}