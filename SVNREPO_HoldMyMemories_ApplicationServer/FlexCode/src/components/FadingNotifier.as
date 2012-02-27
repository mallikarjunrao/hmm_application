package components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.IFlexDisplayObject;
	import mx.effects.Fade;
	import mx.events.EffectEvent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	
	public class FadingNotifier
	{
		private static var label : Label = new Label();
		private static var fadeOut : Fade = new Fade();
		private static var fadeIn : Fade = new Fade();
		private static var popup : IFlexDisplayObject;
		private static var count : int;
		public function FadingNotifier()
		{
		}
		
		public static function addNotifier(parent : Container) : void
		{
			fadeIn.duration = 1300;
			fadeIn.alphaFrom = 0;
			fadeIn.alphaTo = 1;
			fadeIn.addEventListener(EffectEvent.EFFECT_END, handleEffectEnd);
			
			fadeOut.duration = 1300;
			fadeOut.alphaFrom = 1;
			fadeOut.alphaTo = 0;
			fadeOut.addEventListener(EffectEvent.EFFECT_END, handleEffectEnd);
			
			parent.addChild(label);
			label.filters = [];
			label.visible = false;
			label.setStyle("color", 0xffee00);
			label.setStyle("showEffect", fadeIn); 
			label.setStyle("hideEffect", fadeOut); 
			label.setStyle("fontSize", 14);
			label.setStyle("fontFamily", "Arial");
			label.width = 400;
		}
		
		private static function handleEffectEnd(event : Event) : void
		{
			if(event.target == fadeIn)
				label.visible = false;
			
			
		}
		
		public static function showMessage(message : String) : void
		{
			label.text = message;
			label.visible = true;
		}
		
		public static function setBusyState() : void
		{
			if(!popup)
			{
				popup = PopUpManager.createPopUp(Application.application as DisplayObject, Canvas, true);
				popup.height = 0;
				popup.width = 0;
				CursorManager.setBusyCursor();	
			}
			count++;
		}
		
		public static function removeBusyState() : void
		{
			count--;
			if(count ==0)
			{
				PopUpManager.removePopUp(popup);
				popup = null;
				CursorManager.removeBusyCursor();	
			}
			
		}
		

	}
}