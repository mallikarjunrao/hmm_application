package vo
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class ImageVo
	{
		public var position : Point;
		public var rotation : Number;
		public var file : String;
		public var background : Boolean = false;
		public var index : int;
		public var parentIndex : int;
		public var id : int;
		public var name : String;
		public var width : Number;
		public var height : Number;
		public var path : String;
		public var transformPosition : Point;
		public var matrix : Matrix;
		/* public var a : Number;
		public var b : Number;
		public var c : Number;
		public var d : Number;
		public var tx : Number;
		public var ty : Number; */
		
		public function ImageVo()
		{
			transformPosition = new Point(0,0);
			matrix = new Matrix();
			//a = b = c = d = tx = ty = 0;
		}

	}
}