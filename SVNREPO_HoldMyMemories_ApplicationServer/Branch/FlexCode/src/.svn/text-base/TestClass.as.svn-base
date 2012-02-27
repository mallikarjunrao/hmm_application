package
{
	import Xorange.ZUIComponent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.effects.AnimateProperty;
	import mx.effects.easing.Quadratic;

	public class TestClass extends UIComponent
	{
		private var _animate : AnimateProperty;
		private var _childComponents : Array;
		private var _focalLength : Number;
		private var _camera : ZUIComponent;
		private var _dataprovider : ArrayCollection;
		private var _dataField : String;
		private var _origin : Point;
		private var _previousCameraZ : Number = 0;
		public function TestClass()
		{
			_animate = new AnimateProperty();
			_animate.duration = 500;
			_animate.easingFunction = Quadratic.easeOut;
			_childComponents = new Array();
			_focalLength = 10;
			_camera = new ZUIComponent();
			_origin = new Point(this.width/2, this.height/2);
			super();
		}
		
		private function initCamera() : void
		{
			_camera.x = 0;
			_camera.y = 0;
			_camera.z = 0;
			//Camera.target = new Object();
			_camera.target.x = -100;
			_camera.target.y = 0;
			_camera.target.z = 100;
		}
		
		private function animateCamera() : void
		{
			
		}
		
		public function CameraTransform():void
		{
			if(_camera == null)
				return;
			//Camera.z = Camera.z + 1.5*event.delta;
			var delta : Number = Number(Number(_camera.z) - _previousCameraZ);
			_previousCameraZ = _camera.z;
			if(_camera.z >163)
				_camera.z = 163;
			if(_camera.z <0)
				_camera.z = 0;
				var scaleRatio:Number = _focalLength/(_focalLength + _camera.z);
			
			if(_camera.y<0)
			{	
				_camera.y += 0.5*scaleRatio*delta;
			}
			else 
			{
				_camera.y -= 0.5*scaleRatio*delta;
			}
			// Check camera Y bounds
			if(_camera.y > 2)
				_camera.y = 2;
			if(_camera.y < -2)
				_camera.y = -2;
			
			trace("x: "+_camera.x+" y: "+_camera.y+" z: "+_camera.z);
			
		}
		
		private function viewTransform(comp : ZUIComponent) : void
		{
			
		}
		
		private function projectionTransform(comp: ZUIComponent) : void
		{
			// make an object to act as the 2D point on the screen
			// develop a scale ratio based on focal length and the
			// z value of this point
			var scaleRatio:Number = _focalLength/(_focalLength + comp.z);
			// appropriately scale each x and y position of the 3D point based
			// on the scale ratio to determine the point in 2D and assign it to the chart.
			//VertexBuffer[index].chart.x = pointBuf.x * scaleRatio + _origin.x;
			//VertexBuffer[index].chart.y = pointBuf.y * scaleRatio + _origin.y;
			
			comp.x = comp.x * scaleRatio + _origin.x;
			comp.y = comp.y * scaleRatio + _origin.y;
			
			
			// Assign the scaling to the chart scales.					
			//VertexBuffer[index].chart.scaleX = Math.abs(scaleRatio)/2;
			//VertexBuffer[index].chart.scaleY = Math.abs(scaleRatio)/2;
			comp.scaleX = Math.abs(scaleRatio)/2;
			comp.scaleY = Math.abs(scaleRatio)/2;
			// Bound the minimum scaling 
			if(comp.scaleX < 0.1)
				comp.scaleX = 0.1;
			if(comp.scaleY<0.1)
				comp.scaleY = 0.1;
		} 
		
		public function set dataField(field : String) : void
		{
			_dataField = field;
		}
		
		public function set dataProvider( dataArray : ArrayCollection) : void
		{
			_dataprovider = dataArray;
			invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_dataprovider == null)
				return;
			for(var i : int = 0; i < _dataprovider.length; i++)
			{
				var dataVal : Object = _dataprovider[i];
				if(_dataField == null)
				{
					var img : Image = new Image();
					img.source = dataVal;
				}else
				{
					var img : Image = new Image();
					img.source = dataVal[_dataField];
				}
				(img as Image).load();
				img.addEventListener(MouseEvent.CLICK, handleItemClick);
				img.width = 200/Math.abs((_dataprovider.length - i*0.8));
				img.height = 200/(Math.abs(_dataprovider.length - i*0.8));
				img.x = 20*i;
				img.y = (this.height - img.height)/2;
				this.addChild(img);
			}
			_origin = new Point(this.width/2, this.height/2);
			
			
			
		}
		
		private function handleItemClick(event : MouseEvent) : void
		{
			if(this.getChildIndex(event.currentTarget as DisplayObject) < _dataprovider.length - 1)
			{
				//do something
				trace("doing something");
			}else
			{
				return;
			}
		}
		
		
	}
}