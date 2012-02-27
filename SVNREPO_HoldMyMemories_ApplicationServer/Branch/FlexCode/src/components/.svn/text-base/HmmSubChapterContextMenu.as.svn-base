package components
{
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import model.HmmChaptersModel;
	import model.HmmThrashModel;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.events.CloseEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import vo.AudioGalleryVO;
	import vo.GalleryVO;
	import vo.PhotoGalleryVO;
	import vo.VideoGalleryVO;
	
	public class HmmSubChapterContextMenu extends HmmContextMenu
	{
		private var newGallery : GalleryVO;
		private var currentDeletedGallery : GalleryVO;
		public function HmmSubChapterContextMenu()
		{
			//TODO: implement function
			super();
		}
		
		override public function createMenu():ContextMenu
		{
			super.createMenu();
			var item : ContextMenuItem = new ContextMenuItem("New Audio Gallery");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleCreateNewAudioGallery);
			contextMenu.customItems.push(item);
			
			item = new ContextMenuItem("New Video Gallery");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleNewVideoGallery);
			contextMenu.customItems.push(item);
			
			
			item = new ContextMenuItem("New Photo Gallery");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleNewPhotoGallery);
			contextMenu.customItems.push(item);
			
			item  = new ContextMenuItem("Delete Gallery");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleDeleteGallery);
			contextMenu.customItems.push(item);
			
			item  = new ContextMenuItem("Set Permissions");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleSetPermissions);
			contextMenu.customItems.push(item);
			
			/* item = new ContextMenuItem("Hide Gallery");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleHideGallery);
			return contextMenu;
			
			item = new ContextMenuItem("UnHide Gallery");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleUnHideGallery); */
			return contextMenu;
		}
		
		private function handleHideGallery(event : Event) : void
		{
			if(target.selectedItem == null)
			{
				Alert.show("Please select a Sub Chapter first!!!");
			}else
			{
				var obj : Object = new Object();
				obj.id = target.selectedItem.id;
				trace("Hiding Gallery");
				var service : HTTPService = new HTTPService();
				service.addEventListener(FaultEvent.FAULT, handleFault);
				service.addEventListener(ResultEvent.RESULT, handleHideResult);
				service.url = "/galleries/hide/";
				service.send(obj);
			}
		}
		
		private function handleHideResult(event : ResultEvent) : void
		{
			trace("Hiding ....");
			var itemRenderer : IListItemRenderer =  target.itemToItemRenderer(target.selectedItem);
			var obj : Object = itemRenderer.data;
			obj.access = "private";
			itemRenderer.data = obj;
			trace(event.toString());
		}
		
		private function handleUnHideGallery(event : Event) : void
		{
			if(target.selectedItem == null)
			{
				Alert.show("Please select a Sub Chapter first!!!");
			}else
			{
				var obj : Object = new Object();
				obj.id = target.selectedItem.id;
				trace("Hiding Gallery");
				var service : HTTPService = new HTTPService();
				service.addEventListener(FaultEvent.FAULT, handleFault);
				service.addEventListener(ResultEvent.RESULT, handleUnHideResult);
				service.url = "/galleries/unhide/";
				service.send(obj);
			}
		}
		
		private function handleUnHideResult(event : ResultEvent) : void
		{
			trace("Hiding ....");
			var itemRenderer : IListItemRenderer =  target.itemToItemRenderer(target.selectedItem);
			var obj : Object = itemRenderer.data;
			obj.access = "public";
			itemRenderer.data = obj;
			trace(event.toString());
		}
		
		private function handleCreateNewAudioGallery(event : ContextMenuEvent) : void
		{
			newGallery = new AudioGalleryVO();
			newGallery.name = "Audio Gallery"; 
			var createGalleryService : HTTPService = new HTTPService();
			//var output : String = JSON.encode(newChapter);
			var obj : Object = new Object();
			obj.subchapter_id = target.currentSubChapter.id;
			obj.userId = HmmChaptersModel.getInstance().userId;
			obj.name = newGallery.name;
			obj.image = newGallery.icon;
			obj.type = "audio";
			obj.id = -1;
			newGallery.access = "semiprivate";
			// Add service string
			createGalleryService.url = "/galleries/createGallery/";
			createGalleryService.addEventListener(ResultEvent.RESULT, handleCreateResult);
			createGalleryService.addEventListener(FaultEvent.FAULT, handleFault);
			createGalleryService.contentType = HTTPService.RESULT_FORMAT_OBJECT;
			createGalleryService.send(obj);
			FadingNotifier.setBusyState();
		}
		
		
		private function handleNewVideoGallery(event : ContextMenuEvent) : void
		{
			newGallery = new VideoGalleryVO();
			newGallery.name = "Video Gallery";
			newGallery.access = "semiprivate"; 
			var createGalleryService : HTTPService = new HTTPService();
			//var output : String = JSON.encode(newChapter);
			var obj : Object = new Object();
			obj.subchapter_id = target.currentSubChapter.id;
			obj.userId = HmmChaptersModel.getInstance().userId;
			obj.name = newGallery.name;
			obj.image = newGallery.icon;
			obj.type = "video";
			// Add service string
			createGalleryService.url = "/galleries/createGallery";
			createGalleryService.addEventListener(ResultEvent.RESULT, handleCreateResult);
			createGalleryService.addEventListener(FaultEvent.FAULT, handleFault);
			createGalleryService.contentType = HTTPService.RESULT_FORMAT_OBJECT;
			createGalleryService.send(obj);
			FadingNotifier.setBusyState();
		}
		
		private function handleNewPhotoGallery(event : ContextMenuEvent) : void
		{
			newGallery = new PhotoGalleryVO();
			newGallery.name = "Photo Gallery";
			newGallery.type = "image"; 
			newGallery.access = "semiprivate";
			var createGalleryService : HTTPService = new HTTPService();
			//var output : String = JSON.encode(newChapter);
			var obj : Object = new Object();
			obj.subchapter_id = target.currentSubChapter.id;
			obj.userId = HmmChaptersModel.getInstance().userId;
			obj.name = newGallery.name;
			obj.image = newGallery.icon;
			obj.type = "image";
			// Add service string
			createGalleryService.url = "/galleries/createGallery";
			createGalleryService.addEventListener(ResultEvent.RESULT, handleCreateResult);
			createGalleryService.addEventListener(FaultEvent.FAULT, handleFault);
			createGalleryService.contentType = HTTPService.RESULT_FORMAT_OBJECT;
			createGalleryService.send(obj);
			FadingNotifier.setBusyState();
		}
		
		private function handleFault(event : FaultEvent) : void
		{
			Alert.show(event.fault.toString());
			FadingNotifier.removeBusyState();
		}
		
		private function handleCreateResult(event : ResultEvent) : void
		{
			trace(event.toString());
			newGallery.id = event.result as int;
			newGallery.flag = true;
			newGallery.writable = true;
			if(target.proxyurl)
				newGallery.icon = target.proxyurl+newGallery.icon;
			var datap : ArrayCollection = target.dataProvider as ArrayCollection;
			if(datap)
			{
				datap.addItem(newGallery);
			}	
			FadingNotifier.removeBusyState()
		}
		
		private function handleDeleteGallery(event : ContextMenuEvent) : void
		{
			
			
			if(target.selectedItem == null)
			{
				Alert.show("Please select a gallery first");
				return;
			}
			Alert.show("Are you sure you want to delete the gallery "+target.selectedItem.name+" ?", "Confirm Delete", Alert.YES | Alert.CANCEL, null,deleteGallery);
			
		}
		
		
		private function deleteGallery(event : CloseEvent) : void
		{
			if(event.detail == Alert.YES)
			{
				var obj : Object = new Object();
				obj.id =  this.targetList.selectedItem.id;;
				var service : HTTPService = new HTTPService();
				service.url = "/galleries/remove/";
				service.addEventListener(ResultEvent.RESULT, handleDeleteResult);
				service.addEventListener(FaultEvent.FAULT, handleFault);
				service.send(obj);
				FadingNotifier.setBusyState();
			}else
			{
				target.selectedItem = null;
				target.selectedIndex = -1;
			}
			
		}
		
		private function handleDeleteResult(event : ResultEvent) : void
		{
			trace("The gallery is deleted successfully");
			var ac : ArrayCollection = targetList.dataProvider as ArrayCollection;
			var delObj : Object;
				delObj = ac.removeItemAt(target.selectedIndex);	
			try
			{
				HmmThrashModel.getInstance().addDeletedItem(delObj);
			}
			catch(ex : Error)
			{
				trace("Trash model not loaded");
			}
			FadingNotifier.removeBusyState();
		}
		
		public function getButtonBarData() : Array
		{
			var buttonData : Array = new Array();
			//delete
			/* var newChap : Object = new Object();
			newChap.data = handleDeleteGallery;
			newChap.icon = IconClasses.deleteMouseOver;
			newChap.toolTip = "Delete Gallery";
			buttonData.push(newChap);
			// new photo gallery
			newChap = new Object();
			newChap.data = handleNewPhotoGallery;
			newChap.icon = IconClasses.newChapterMouseOver;
			newChap.toolTip = "New Photo Gallery";
			buttonData.push(newChap);
			// new video gallery
			newChap = new Object();
			newChap.data = handleNewVideoGallery;
			newChap.icon = IconClasses.newChapterMouseOver;
			newChap.toolTip = "New Video Gallery";
			buttonData.push(newChap);
			// new audio gallery
			newChap = new Object();
			newChap.data = handleCreateNewAudioGallery;
			newChap.icon = IconClasses.newChapterMouseOver;
			newChap.toolTip = "New Audio Gallery";
			buttonData.push(newChap);
			// hide chapter
			newChap = new Object();
			newChap.data = handleHideGallery;
			newChap.icon = IconClasses.hideChapterMouseOver;
			newChap.toolTip = "Hide Gallery";
			buttonData.push(newChap);
			// Unhide chapter
			newChap = new Object();
			newChap.data = handleHideGallery;
			newChap.icon = IconClasses.hideChapterMouseOver;
			newChap.toolTip = "Unhide Gallery";
			buttonData.push(newChap); 
			//Set Permissions
			newChap = new Object();
			newChap.data = handleSetPermissions;
			newChap.icon = IconClasses.permissionsMouseOver;
			newChap.toolTip = "Set Gallery Permissions";
			buttonData.push(newChap); */
			return buttonData;
		}
	}
}