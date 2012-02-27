package renderers
{
	import events.SlideShowEvent;
	
	import flash.events.Event;
	
	public class GallerySelectionRenderer extends CustomTreeItemRenderer
	{
		[Bindable]
		private var checkBoxVisible : Boolean = false;
		[Bindable]
		private var isEventListenerAdded : Boolean = false;
		
		public function GallerySelectionRenderer()
		{
			//TODO: implement function
			super();
			
		}
		
		private function handleUnCheck(event : Event) : void
		{
			checkBox.selected = false;
			isEventListenerAdded = false;
			invalidateDisplayList();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			isEventListenerAdded = false;
			if(checkBox)
			{
				checkBox.visible =false;
				checkBox.addEventListener(Event.CHANGE, handleCheckboxChanged);
				if(data)
				{
					 if(data.@type != "content")
					{
						checkBox = null;
					}
					else
					{ 
						checkBox.visible = true;
					}
				}
			}	
				
		}
		
		private function handleCheckboxChanged(event : Event) : void
		{
			trace(event.currentTarget);
			trace(this.parentDocument);
			 if(event.target.selected)
			 {
				this.parentDocument.dispatchEvent(new SlideShowEvent(SlideShowEvent.CHECKBOXCHECKED,data));
				if(!isEventListenerAdded)
				{
					this.parentDocument.addEventListener("uncheck",handleUnCheck);
					isEventListenerAdded = true;
				}
			 }
			else
			 this.parentDocument.dispatchEvent(new SlideShowEvent(SlideShowEvent.CHECKBOXUNCHECKED,data));
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value.@type == "content")
			{
				
			}
		}		
		
	}
}