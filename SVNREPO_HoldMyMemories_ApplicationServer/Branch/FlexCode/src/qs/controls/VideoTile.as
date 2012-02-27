package qs.controls
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.utils.*;
	
	import mx.controls.Button;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.effects.*;
	import mx.events.FlexEvent;
	

	[Style(name="borderColor", type="Number", inherit="no")]
	[Style(name="borderAlpha", type="Number", inherit="no")]
	[Style(name="borderWidth", type="Number", inherit="no")]
	[Event("loaded")]

	public class VideoTile extends UIComponent implements IDataRenderer
	{
		private static var _nextId:int = 0;
		private var _id:int;
		
		private var _loaded:Boolean = false;
		private var _imageWidth:Number = 100;
		private var _imageHeight:Number = 100;
		private const BORDER_WIDTH:Number = 1;
		private var _border:Shape;
		private var _url : String;
		private var button : Button;

       

		public function VideoTile()
		{
			super();
			_id= _nextId++;

			_border = new Shape();
			button = new Button();
			addChild(_border);
			loadComplete(null);
		}
		
		private function handleCreationComplete(event : FlexEvent) : void
		{
			//_loader.load(new URLRequest(url));
			//this.autoPlay = false;
			
		}
		
		[Bindable] public var progress:Number = 0;
		public function get loaded():Boolean
		{
			return _loaded;
		}
		
		private function loadComplete(e:Event):void
		{
			_loaded = true;
			_imageWidth = 100//button.measuredWidth;
			_imageHeight = 100//button.measuredHeight;
			
			invalidateSize();
			invalidateDisplayList();
			invalidateSize();
			dispatchEvent(new Event("loaded"));	
				
		}
		
		private var _publicAlpha:Number = 1;
		private var _fadeValue:Number = 1;
		private var _data:Object;
		
		
		
		public function get imageBounds():Rectangle
		{
			var unscaledWidth:Number = this.unscaledWidth - 2;
			var unscaledHeight:Number = this.unscaledHeight - 2;
			var sX:Number = unscaledWidth/_imageWidth;
			var sY:Number = unscaledHeight/_imageHeight;
			var scale:Number = Math.min(sX,sY);
			var tX:Number = 1 + unscaledWidth/2 - (_imageWidth/2)*scale;
			var tY:Number = 1 + unscaledHeight/2 - (_imageHeight/2)*scale;
			
			return new Rectangle(tX,tY,_imageWidth*scale,_imageHeight*scale);
			_loader.x = tX;
			_loader.y = tY;
		}
		
		public function set data(value:Object):void
		{
			_loaded = false;
			progress= 0;
			_data = value;
			_url = String((_data is String)? _data:_data.thumb);
			//_loader.load(new URLRequest(url));
			//this.autoPlay = false;
			
			
			this.addEventListener(Event.COMPLETE,loadComplete);	
			this.addEventListener(ProgressEvent.PROGRESS,updateProgress);	
			
			invalidateDisplayList();
			invalidateSize();
		}
		
		public function get data():Object { return _data;}
		
		public function set fadeValue(value:Number):void
		{
			_fadeValue = value;
			super.alpha = _publicAlpha*_fadeValue;
		}
		public function get fadeValue():Number {return _fadeValue;}

		private function updateProgress(e:ProgressEvent):void
		{
			progress = e.bytesLoaded / e.bytesTotal;
			trace(progress.toString());
		}
		override public function set alpha(value:Number):void
		{
			_publicAlpha = value;
			super.alpha = _publicAlpha*_fadeValue;
		}
		

		override protected function measure():void
		{
			measuredWidth = _imageWidth+2;
			measuredHeight = _imageHeight+2;
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
				
			var g:Graphics = _border.graphics;
			g.clear();

			if(_loaded == false)
				return;
			
			var borderColor:* = getStyle("borderColor");
			var borderAlpha:* = getStyle("borderAlpha");
			var borderWidth:* = getStyle("borderWidth");
			
			if(isNaN(borderColor) || borderColor == null)
				borderColor = 0xBBBBBB;
			if(isNaN(borderAlpha) || borderAlpha == null)
				borderAlpha = 1;
			if(isNaN(borderWidth) || borderWidth == null)
				borderWidth = BORDER_WIDTH;				
				
			unscaledWidth -= 2;
			unscaledHeight -= 2;
			var sX:Number = unscaledWidth/_imageWidth;
			var sY:Number = unscaledHeight/_imageHeight;
			var scale:Number = Math.min(sX,sY);
			var tX:Number = 1 + unscaledWidth/2 - (_imageWidth/2)*scale;
			var tY:Number = 1 + unscaledHeight/2 - (_imageHeight/2)*scale;

			button.width = _imageWidth*scale;
			button.height = _imageHeight*scale;
			button.x = tX;
			button.y = tY;
							
			g.lineStyle(borderWidth,borderColor,borderAlpha,false,"normal",CapsStyle.NONE,JointStyle.MITER);
			g.moveTo(tX+borderWidth/2,tY+borderWidth/2);
			g.lineTo(tX+button.width-borderWidth/2,tY+borderWidth/2);
			g.lineTo(tX+button.width-borderWidth/2,tY+button.height-borderWidth/2);
			g.lineTo(tX+borderWidth/2,tY+button.height-borderWidth/2);
			g.lineTo(tX+borderWidth/2,tY+borderWidth/2);

		}
		
	}
}