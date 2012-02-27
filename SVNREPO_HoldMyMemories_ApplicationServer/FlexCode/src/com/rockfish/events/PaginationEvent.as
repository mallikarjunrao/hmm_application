package com.rockfish.events
{
	import com.rockfish.renderers.PaginationButton;
	
	import flash.events.Event;

	public class PaginationEvent extends Event
	{
		public static const PAGE_NAV:String = "pageNav";
		
		public var pageButton:PaginationButton;
		
		public function PaginationEvent(type:String, page:PaginationButton, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			pageButton = page;
		}		
	}
}