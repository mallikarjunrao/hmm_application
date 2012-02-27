package renderers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.containers.VBox;
	import mx.controls.Image;
	
	import vo.GalleryItem;

	public class GalleryItemRenderer extends VBox
	{
		var box : VBox = new VBox();
								
		public function GalleryItemRenderer()
		{
			//TODO: implement function
			super();
		}
		
		override public function set data(value:Object):void
		{
			
			super.data = value;
			
			switch(value.type)
			{
				case GalleryItem.AUDIO:
								
								break;
				case GalleryItem.PICTURE:
								var loader : URLLoader = new URLLoader();
								box.percentHeight = 100;
								box.percentHeight = 100;
								
								loader.addEventListener(Event.COMPLETE, handleLoadComp);
								loader.load(new URLRequest(value.icon));
								break;
				case GalleryItem.VIDEO:
								
								break;
			}
		}
		
		private function handleLoadComp(event : Event) : void
		{
			if(event.currentTarget)
			{
				var img : Image = new Image();
				img.data = (event.currentTarget as URLLoader).data;
				this.addChild(img);
			}
				
			
		}
		
	}
}