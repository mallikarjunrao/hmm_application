package events
{
	import PhotoBookComponents.ResizableCanvas;
	
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class ImageEvent extends Event
	{
		public static const DELETE : String = "delete";
		public static const ROTATION :  String = "rotation";
		public static const SIZE : String = "size";
		public static const BRODCASTIMAGEHANDLE : String = "broadcast";
		public static const REMOVEIMAGEHANDLE : String = "removehandle";
		public static const POSITION : String = "position";
		public var positionXY : Point;
		public var name : String;
		public var angle : Number;
		public var child : ResizableCanvas;
		public var transformPosition : Point;
		public var matrix : Matrix;
		public function ImageEvent(type : String,targetName : String = null,child : ResizableCanvas = null, rotationAngle : Number = 0,xy : Point = null,transformXY : Point = null, matrix : Matrix = null)
		{
			super(type);
			name = targetName;
			angle = rotationAngle;
			this.child = child;
			positionXY = xy;
			transformPosition = transformXY;
			this.matrix = matrix;
			
		}

	}
}