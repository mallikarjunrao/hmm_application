package components
{
	import flash.events.Event;
	
	import vo.WebFolderVO;
	

	public class HmmContextMenuEvents extends Event
	{
		public static const CREATE_CHAPTER : String = "createChapter";
		public static const DELETE_CHAPTER : String = "deleteChapter";
		public static const CUT_CHAPTER : String = "cutChapter";
		public static const COPY_CHAPTER : String = "copyChapter";
		public static const PASTE_CHAPTER : String = "pasteChapter";
		public static const HIDE_CHAPTER : String = "hideChapter";
		public static const UNHIDE_CHAPTER : String = "unhideChapter";
		public var chapter : WebFolderVO;
		public function HmmContextMenuEvents(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			
			//TODO: implement function
			super(type, bubbles, cancelable);
		}
		
	}
}