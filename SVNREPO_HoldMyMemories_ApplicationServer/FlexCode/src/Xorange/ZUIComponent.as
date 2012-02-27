package Xorange
{
	import Xorange.Vertex3D;
	
	import mx.core.UIComponent;

	public class ZUIComponent extends UIComponent
	{
		public var z : Number;
		public var target : Vertex3D;
		public function ZUIComponent()
		{
			//TODO: implement function
			target = new Vertex3D();
			z = 0;
			super();
		}
		
	}
}