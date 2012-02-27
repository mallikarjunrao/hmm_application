package components
{
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TitleWindow;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	public class HmmEditTagContextMenu extends HmmContextMenu
	{
		
		public function HmmEditTagContextMenu()
		{
			//TODO: implement function
			super();
		}
		
		public function set targetValue(value : Object ) : void
		{
			targetList = value;
		}
		
		override public function createMenu():ContextMenu
		{
			super.createMenu();
			clearMenus();
			var item : ContextMenuItem = new ContextMenuItem("Add to all");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleTagAll);
			contextMenu.customItems.push(item);
			
			item = new ContextMenuItem("Add to Selected");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleTagSelected);
			contextMenu.customItems.push(item);
			
			return contextMenu;
		}
		
		private function handleTagAll(event : ContextMenuEvent) : void
		{
			var popup : IFlexDisplayObject = PopUpManager.createPopUp(targetList as DisplayObject, EditTagsPopup, true);
			(popup as TitleWindow).data = targetList.dataProvider.source;
			(popup as EditTagsPopup).update = update;
			PopUpManager.centerPopUp(popup);
		}
		
		private function handleTagSelected(event : ContextMenuEvent) : void
		{
			var popup : IFlexDisplayObject = PopUpManager.createPopUp(targetList as DisplayObject, EditTagsPopup, true);
			(popup as TitleWindow).data = targetList.tagList.selectedItems;
			PopUpManager.centerPopUp(popup);
			(popup as EditTagsPopup).update = update;
		}
		
		private function update() : void
		{
			targetList.dataProvider = new ArrayCollection(targetList.dataProvider.source);	
		}
	}
}