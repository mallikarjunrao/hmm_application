package components
{
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import model.HmmChaptersModel;
	import model.HmmThrashModel;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.events.CloseEvent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import vo.AudioGalleryVO;
	import vo.ChapterVO;
	import vo.GalleryVO;
	import vo.PhotoGalleryVO;
	import vo.SubChapterVO;
	import vo.VideoGalleryVO;
	import vo.WebFileVO;
	
	public class HmmRootContextMenu extends HmmContextMenu 
	{
		
		public function HmmRootContextMenu()
		{
			//TODO: implement function
			super();
		}
	
		override public function createMenu():ContextMenu
		{
			super.createMenu();
			var item : ContextMenuItem = new ContextMenuItem("New Chapter");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleCreateChapter);
			contextMenu.customItems.push(item);
			
			item = new ContextMenuItem("Delete Chapter");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleDeleteChapter);
			contextMenu.customItems.push(item);
			
			item  = new ContextMenuItem("Set Permissions");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleSetPermissions);
			contextMenu.customItems.push(item);
			
			return contextMenu;
		}
		
		private function handleCreateChapter(event : ContextMenuEvent) : void
		{
			
			target.newChapter = createChapter();
			setWindowModal();
			CursorManager.setBusyCursor();
		}
		
	private function createChapter() : ChapterVO
	{
		var newChapter : ChapterVO = new ChapterVO();
		var dp : ArrayCollection = target.dataProvider as ArrayCollection;
		var cnt : int = 0;
		for(var i : int = 0; i< dp.length; i++)
		{
			var name : String = dp.getItemAt(i).name ; 
			if(name.search("New") >= 0 && name.search("Chapter") >= 0)
				cnt++;
			
		} 
		if(cnt != 0)
			newChapter.name = "New Chapter "+(cnt);
		else
			 newChapter.name = "New Chapter ";
		if(target.proxyurl)
		{
			newChapter.icon = target.proxyurl+"/user_content/photos/icon_thumbnails/folder_img.png";
		}
		else
		{
			newChapter.icon = "http://12.156.60.97/user_content/photos/icon_thumbnails/folder_img.png";
		}
		var createChapterService : HTTPService = new HTTPService();
		createChapterService.url = "/tags/create";
		createChapterService.addEventListener(ResultEvent.RESULT, handleServiceResult);
		createChapterService.addEventListener(FaultEvent.FAULT, handleServiceFault);
		createChapterService.contentType = HTTPService.RESULT_FORMAT_OBJECT;
		var obj : Object = new Object();
		
		
		
		obj.userId = HmmChaptersModel.getInstance().userId;
		obj.name = newChapter.name;
		createChapterService.send(obj);
		return newChapter;
	}
	
	private function handleServiceResult(event : ResultEvent) : void
	{
		trace(event.toString());
		var datap : ArrayCollection = target.dataProvider as ArrayCollection;
		datap.addItem(target.newChapter);
		target.newChapter.id = event.result.chapterid;
		target.newChapter.flag = true;
		var sub : SubChapterVO = new SubChapterVO();
		sub.id = event.result.subchapterid;
		target.newChapter.subchapters.push(sub);
		sub.access = "semiprivate";
		if(target.proxyurl)
			sub.icon = target.proxyurl+sub.icon; 
		target.newChapter.access = "semiprivate";
		var gallery : GalleryVO = new PhotoGalleryVO();
		gallery.id = event.result.photoid;
		gallery.access = "semiprivate";
		if(target.proxyurl)
			gallery.icon = target.proxyurl+gallery.icon;
		sub.gallery.push(gallery);
		gallery.writable = true;
		gallery = new VideoGalleryVO();
		gallery.id = event.result.videoid;
		sub.gallery.push(gallery);
		if(target.proxyurl)
			gallery.icon = target.proxyurl+gallery.icon;
		gallery.access = "semiprivate";
		gallery.writable = true;
		gallery = new AudioGalleryVO();
		gallery.id = event.result.audioid;
		sub.gallery.push(gallery);
		gallery.access = "semiprivate";
		gallery.writable = true;
		if(target.proxyurl)
			gallery.icon = target.proxyurl+gallery.icon;
		//target.newChapter.subchapters[0].id = event.result.subchapterid;	
		removeModalWindow();
		CursorManager.removeBusyCursor();
		//target.selectedItem = null;
	}
	
	private function handleServiceFault(event : FaultEvent) : void
	{
		trace(event.toString());
	}
	
	private function handleDeleteChapter(event : ContextMenuEvent) : void
	{
		if(event == null)
			isContextMenuCall = false;
		else
			isContextMenuCall = true;
		if(target.selectedItem == null)
		{
			Alert.show("Please select a Chapter first!!!");
			return;
		}else if(target.selectedIndex == 0)
		{
			Alert.show("Cannot delete uncategorized chapter");
			return;
		}
		
			var name : String = target.selectedItem.name;
			Alert.show("Are you sure you want to delete "+name+" ?", "Confirm delete", Alert.OK  | Alert.CANCEL, null, deleteChapter);
		
		
		
	}	
		private function deleteChapter(event : CloseEvent) : void
		{
			if(event.detail == Alert.OK)
			{
				
				
					var obj : Object = new Object();
					obj.id = target.selectedItem.id;
					var service : HTTPService = new HTTPService();
					service.addEventListener(FaultEvent.FAULT, handleDeleteFault);
					service.addEventListener(ResultEvent.RESULT, handleDeleteResult);
					service.url = "/tags/remove/";
					service.send(obj);
				popup = PopUpManager.createPopUp(target, Canvas, true);
				popup.width = 0;
				popup.height = 0;
				CursorManager.setBusyCursor();
			}else
			{
				rollOverIndex = -1;
				target.selectedItem = null;
			}
			
		}
		
		private function handleDeleteFault(event : FaultEvent) : void
		{
			trace(event.toString());
		}
		
		private function handleDeleteResult(event : ResultEvent) : void
		{
			trace("Deleting chapter from the current Model id:"+event.result);
			var ac : ArrayCollection = target.dataProvider as ArrayCollection;
			var delObj : Object;
			delObj = ac.removeItemAt(target.selectedIndex);
			try
			{
				HmmThrashModel.getInstance().addDeletedItem(delObj);
			}
			catch(ex : Error)
			{
				trace("Trash model not loaded.");
			}
			PopUpManager.removePopUp(popup);
			CursorManager.removeBusyCursor();	
		}
		
		private function handleHideChapter(event : ContextMenuEvent) : void
		{
			if(target.selectedItem == null)
			{
				Alert.show("Please select a Chapter first!!!");
			}else 
			{
				var obj : Object = new Object();
				obj.id = target.selectedItem.id;
				trace("Hiding chapter");
				var service : HTTPService = new HTTPService();
				service.addEventListener(FaultEvent.FAULT, handleHideFault);
				service.addEventListener(ResultEvent.RESULT, handleHideResult);
				service.url = "/tags/hide/";
				service.send(obj);
				setWindowModal();
				CursorManager.setBusyCursor();
			}
			
			
		}
		
		private function handleHideFault(event : FaultEvent) : void
		{
			trace(event.toString());
		}
		
		private function handleHideResult(event : ResultEvent) : void
		{
			var itemRenderer : IListItemRenderer =  target.itemToItemRenderer(target.selectedItem);
			var obj : ChapterVO = itemRenderer.data as ChapterVO;
			obj.access = "private";
			for(var i : int = 0; i < obj.subchapters.length; i++)
			{
				var sub : SubChapterVO = obj.subchapters[i] as  SubChapterVO;
				sub.access = "private";
				for(var j : int = 0; j < sub.gallery.length; j++)
				{
					var gal : GalleryVO = sub.gallery[j] as GalleryVO;
					gal.access = "private";
					for(var k : int = 0; k< gal.files.length; k++)
					{
						var file : WebFileVO = gal.files[k] as WebFileVO;
						file.access = "private";
					}
				}
			}
			itemRenderer.data = obj;
			trace("Hiding ....");
			FadingNotifier.showMessage("Item Successfully Hidden!!!");
			removeModalWindow();
			CursorManager.removeBusyCursor();
			trace(event.toString());
		}
		
		private function handleUnhideChapter(event : ContextMenuEvent) : void
		{
			if(target.selectedItem == null)
			{
				Alert.show("Please select a Chapter first!!!");
			}else if(target.selectedIndex == 0)
			{
				Alert.show("Cannot delete uncategorized chapter");
			}else
			{
				var obj : Object = new Object();
				obj.id = target.selectedItem.id;
				var service : HTTPService = new HTTPService();
				service.addEventListener(FaultEvent.FAULT, handleDeleteFault);
				service.addEventListener(ResultEvent.RESULT, handleUnhideResult);
				service.url = "/tags/unhide/";
				service.send(obj);
				setWindowModal();
				CursorManager.setBusyCursor();
				
			}
		}
		
		private function handleUnhideResult(event : ResultEvent) : void
		{
			//Add some code to show that the folder is viisble to all.
			var itemRenderer : IListItemRenderer =  target.itemToItemRenderer(target.selectedItem);
			var obj : ChapterVO = itemRenderer.data as ChapterVO;
			for(var i : int = 0; i < obj.subchapters.length; i++)
			{
				var sub : SubChapterVO = obj.subchapters[i] as  SubChapterVO;
				sub.access = "public";
				for(var j : int = 0; j < sub.gallery.length; j++)
				{
					var gal : GalleryVO = sub.gallery[j] as GalleryVO;
					gal.access = "public";
					for(var k : int = 0;k<  gal.files.length; k++)
					{
						var file : WebFileVO = gal.files[k] as WebFileVO;
						file.access = "public";
					}
				}
			}
			obj.access = "public";
			itemRenderer.data = obj;
			removeModalWindow();
			CursorManager.removeBusyCursor();
			FadingNotifier.showMessage("Item is Public Now!!!");
			trace("Folder visible to all id: "+ target.selectedItem.id);
		}
		
		
		
		public function getButtonBarData() : Array
		{
			 var buttonData : Array = new Array();
			//delete
			/*var newChap : Object = new Object();
			newChap.data = handleDeleteChapter;
			newChap.icon = IconClasses.deleteMouseOver;
			newChap.toolTip = "Delete Chapter";
			buttonData.push(newChap);
			// new chapter
			newChap = new Object();
			newChap.data = handleCreateChapter;
			newChap.icon = IconClasses.newChapterMouseOver;
			newChap.toolTip = "Create Chapter";
			buttonData.push(newChap);
			
			//Set Permissions
			newChap = new Object();
			newChap.data = handleSetPermissions;
			newChap.icon = IconClasses.permissionsMouseOver;
			newChap.toolTip = "Set Chapter Permissions";
			buttonData.push(newChap); */
			return buttonData;
		}
		
		
	}
}