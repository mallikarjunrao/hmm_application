package qs.ipeControls
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import mx.controls.Label;
	import mx.controls.TextInput;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.managers.IFocusManagerContainer;
	import mx.validators.StringValidator;
	
	import qs.ipeControls.classes.IPEBase;

/* [Event(name="change", type="flash.events.Event")] */
[Event(name="enter", type="mx.events.FlexEvent")]
[Event(name="textInput", type="flash.events.TextEvent")]
[Event(name="checkName", type="flash.events.Event")]
public class IPETextInput extends IPEBase implements IDropInListItemRenderer
{
	public function IPETextInput():void
	{
		super();
		nonEditableControl = new Label();
		nonEditableControl.setStyle("color", 0xFFFFFFFF);
		editableControl = new TextInput();;
		nonEditableControl.addEventListener(MouseEvent.CLICK, handleFocusIn);
		 validator = new StringValidator();
		validator.minLength = 1;
		validator.source = editableControl;
		validator.property = "text";
		validator.triggerEvent = KeyboardEvent.KEY_UP;
		facadeEvents(editableControl,"enter","textInput","valueCommit");
		
	}
	
	private function handleFocusIn(event : Event) : void
	{
		dispatchEvent(new Event("checkName"));
	}
	
	override protected function commitEditedValue():void
	{
		Label(nonEditableControl).text = TextInput(editableControl).text;
	}

	
	public function get textInput():TextInput {return TextInput(editableControl);}
	public function get label():Label {return Label(nonEditableControl);}
	
	public function get condenseWhite():Boolean {return textInput.condenseWhite;}
	public function set condenseWhite(value:Boolean):void {textInput.condenseWhite = value;}
	public function set text(value:String):void
	{
		TextInput(editableControl).text = value;
		Label(nonEditableControl).text = value;
	}		
	public function get text():String { return textInput.text }
	public function get imeMode():String { return textInput.imeMode }
	public function set imeMode(value:String):void { textInput.imeMode = value;}
	public function get length():int { return textInput.length; }
	public function get listData():BaseListData { return textInput.listData; }
	public function set listData(value:BaseListData):void 
	{ 
		textInput.listData = value;
		label.listData = value;
	}
	public function get maxChars():int { return textInput.maxChars; }
	public function set maxChars(value:int):void { textInput.maxChars = value; }
	
	public function get restrict():String { return textInput.restrict; }
	public function set restrict(value:String):void { textInput.restrict = value;}		
	
	public function get selectionBeginIndex():int { return textInput.selectionBeginIndex; }
	public function set selectionBeginIndex(value:int):void { textInput.selectionBeginIndex = value;}

	public function get selectionEndIndex():int { return textInput.selectionEndIndex; }
	public function set selectionEndIndex(value:int):void { textInput.selectionEndIndex = value;}
	public var validator : StringValidator;
	public function setSelection(beginIndex:int, endIndex:int):void { textInput.setSelection(beginIndex,endIndex); }
}
}