package events
{
	import flash.events.Event;

	public class CoverFlowEvent extends Event
	{
		public var extra : Object;
		public static const NAVIGATE_TO : String = "navigateTo";
		
		public function CoverFlowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			//TODO: implement function
			super(type, bubbles, cancelable);
		}
		
	}
}