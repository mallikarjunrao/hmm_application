package helpers
{
	import flash.display.Sprite;
	
	import mx.controls.Alert;
	
	

	public class DebugAlert 
	{
		public static var debug : Boolean;
		public function DebugAlert()
		{
			//TODO: implement function
			super();
		}
		
		public static function show(text:String = "", title:String = "", flags:uint = 0x4, parent:Sprite = null, closeHandler:Function = null,
		 iconClass:Class = null, defaultButtonFlag:uint = 0x4): void
		{
			if(debug)
				Alert.show(text, title, flags, parent, closeHandler, iconClass, defaultButtonFlag);
			
		}
	}
}