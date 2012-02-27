package renderers
{
	import events.SlideShowEvent;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextLineMetrics;
	
	import mx.controls.CheckBox;
	import mx.controls.Tree;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	import mx.core.IFlexDisplayObject;
	import mx.core.SpriteAsset;

	public class FriendsTreeItemRenderer extends TreeItemRenderer
	{
		
		private var iconName : String;
		private var iconUrl : String;
		[Bindable]
		private var selection : Boolean;
		[Bindable]
		private var xml : XML;
		private var listOwner : Tree;
		protected var checkBox : CheckBox;
		
		public function FriendsTreeItemRenderer()
		{
			super();
		}
		
		// Override the set method for the data property
        // to set the font color and style of each node.        
        override public function set data(value:Object):void {
            super.data = value;
            
            iconName = value.@label;
            iconUrl = value.@icon;
            if(value.@select == "true")
            	selection = true;
            else
            	selection = false;
           toolTip = selection.toString();
            /* if(TreeListData(super.listData).hasChildren)
            {
                setStyle("color", 0xff0000);
                setStyle("fontWeight", 'bold');
            }
            else
            {
                setStyle("color", 0x000000);
                setStyle("fontWeight", 'normal');
            }   */
        }
        
         override protected function commitProperties():void
        {
      
        	super.commitProperties();
        	 if (icon)
			{
				removeChild(DisplayObject(icon));
				icon = null;
			}
			if (disclosureIcon)
			{
				disclosureIcon.removeEventListener(MouseEvent.MOUSE_DOWN, 
				      							   disclosureMouseDownHandler);
				removeChild(DisplayObject(disclosureIcon));
				disclosureIcon = null;
			} 
	
			if (data != null)
			{
				var _listData : TreeListData = TreeListData(listData)
				listOwner = Tree(_listData.owner);
				
				if (_listData.disclosureIcon)
				{
					var disclosureIconClass:Class = _listData.disclosureIcon;
					var disclosureInstance:* = new disclosureIconClass();
					
					// If not already an interactive object, then we'll wrap 
					// in one so we can dispatch mouse events.
					if (!(disclosureInstance is InteractiveObject))
					{
						var wrapper:SpriteAsset= new SpriteAsset();
						wrapper.addChild(disclosureInstance as DisplayObject);
						disclosureIcon = wrapper as IFlexDisplayObject;
					}
					else
					{
						disclosureIcon = disclosureInstance;
					}
	
					addChild(disclosureIcon as DisplayObject);
					disclosureIcon.addEventListener(MouseEvent.MOUSE_DOWN,
													disclosureMouseDownHandler);
				}
				
				 if (_listData.icon)
				{
					/* var iconClass:Class = IconUtility.getClass(this, iconUrl, 64,64);
					icon = new iconClass();
					addChild(DisplayObject(icon)); */
					icon = null;
				} 
				
				label.text = _listData.label;
				label.multiline = listOwner.variableRowHeight;
				label.wordWrap = listOwner.wordWrap;
			}
			else
			{
				label.text = " ";
				toolTip = null;
			}
			if(checkBox ==null)
			{
				checkBox = new CheckBox();
				
				this.addChild(checkBox);
				checkBox.setStyle("themeColor", "#ff6633");	
				checkBox.addEventListener(MouseEvent.CLICK, handleCheckBoxClicked);
			}
			checkBox.selected = selection;
			
        	invalidateDisplayList();
        	
        } 
        
        private function handleCheckBoxClicked(event : Event) : void
        {
        	event.stopImmediatePropagation();
        	event.stopPropagation();
        	data.@select = checkBox.selected;
        	var dataxml : XML = data as XML;
        	setChildren(dataxml.children(), checkBox.selected);
        	var evt : Event = new Event("change");
        	//EventDispatcher(this.parentDocument).dispatchEvent(evt);
        	if(checkBox.selected)
        		this.parentDocument.dispatchEvent(new SlideShowEvent(SlideShowEvent.CHECKBOXCHECKED,data as Object));
        	else
        		this.parentDocument.dispatchEvent(new SlideShowEvent(SlideShowEvent.CHECKBOXUNCHECKED,data as Object));	
        	disclosureMouseDownHandler(evt);
        	disclosureMouseDownHandler(evt);
        }
        
        private function setChildren(list :XMLList, value : Boolean) : void
        {
        	if(list == null)
        		return;
       		var item:XML;
        	for each(item in list) {
               
                item.@select = value;
                 trace("item: " + item.@label + "select: "+item.@select);
                setChildren(item.children(), value);
            }

        }
        
        private function disclosureMouseDownHandler(event : Event) : void
        {
        	event.stopPropagation();
			var _listData : TreeListData = TreeListData(listData)
			 var item:Object = _listData.item;
                if (listOwner.dataDescriptor.isBranch(item)) {
                    listOwner.expandItem(item, !listOwner.isItemOpen(item), true);
                }
        }
     
        // Override the updateDisplayList() method 
        // to set the text for each tree node.      
        override protected function updateDisplayList(unscaledWidth:Number, 
            unscaledHeight:Number):void {
            	super.updateDisplayList(unscaledWidth, unscaledHeight);
            	if(checkBox)
            	{
            		var lineMetrics : TextLineMetrics = label.getLineMetrics(0); 
            		var startx : Number;//icon.x + icon.measuredWidth;
            		if(disclosureIcon)
            		 startx = disclosureIcon.x + disclosureIcon.width + 2;
            		else
            		 startx = 4; 
            		checkBox.x = startx + 4;
            		startx += checkBox.width + 4;
            		label.x = startx + 15;
            		//startx += label.width + 4;
            		checkBox.y =  (unscaledHeight - checkBox.height - 8);
            		label.setActualSize(unscaledWidth - startx, measuredHeight);
       						
            	}
            if(super.data)
            {
                if(TreeListData(super.listData).hasChildren)
                {
                    var tmp:XMLList = 
                        new XMLList(TreeListData(super.listData).item);
                    var myStr:int = tmp[0].children().length();
                    super.label.text =  TreeListData(super.listData).label + 
                        "(" + myStr + ")";
                }
            }
        }
		
	}
}