package components
{
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import model.HmmChaptersModel;
	import model.HmmThrashModel;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import vo.AudioGalleryVO;
	import vo.GalleryVO;
	import vo.PhotoGalleryVO;
	import vo.SubChapterVO;
	import vo.VideoGalleryVO;
	import vo.WebFileVO;
	
	public class HmmChaptersContextMenu extends HmmContextMenu
	{
		private var newSubChapter : SubChapterVO;
		private var clipBoardSubChapter : SubChapterVO;
		public function HmmChaptersContextMenu()
		{
			//TODO: implement function
			super();
		}
		
		override public function createMenu():ContextMenu
		{
			super.createMenu();
			var item : ContextMenuItem = new ContextMenuItem("New Sub Chapter");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleCreateSubChapter);
			contextMenu.customItems.push(item);
			
			item = new ContextMenuItem("Delete Sub Chapter");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleDeleteSubChapter);
			contextMenu.customItems.push(item);
			
			
			/* item = new ContextMenuItem("Paste Sub Chapter");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handlePasteSubChapter);
			contextMenu.customItems.push(item);
			
			item  = new ContextMenuItem("Cut Chapter");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleCutSubChapter);
			contextMenu.customItems.push(item);
			
			item = new ContextMenuItem("Copy Chapter");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleCopySubChapter);
			contextMenu.customItems.push(item);*/
			
			/* item  = new ContextMenuItem("Hide Chapter");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleHideSubChapter);
			contextMenu.customItems.push(item); 
			
			item  = new ContextMenuItem("Unhide Chapter");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleUnhideSubChapter);
			contextMenu.customItems.push(item); */
			
			 item  = new ContextMenuItem("Set Permissions");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleSetPermissions);
			contextMenu.customItems.push(item); 
			
			return contextMenu;
		}
		
		private function handleUnhideSubChapter(event : ContextMenuEvent) : void
		{
			if(target.selectedItem == null)
			{
				Alert.show("Please select a Sub Chapter first!!!");
			}else
			{
				var obj : Object = new Object();
				obj.id = target.selectedItem.id;
				var service : HTTPService = new HTTPService();
				service.addEventListener(FaultEvent.FAULT, handleFault);
				service.addEventListener(ResultEvent.RESULT, handleUnhideResult);
				service.url = "/sub_chapter/unhide/";
				service.send(obj);
			}
		}
		
		
		
		private function handleUnhideResult(event : ResultEvent) : void
		{
			//Add some code to show that the folder is viisble to all.
			var itemRenderer : IListItemRenderer =  target.itemToItemRenderer(target.selectedItem);
			var obj : SubChapterVO = itemRenderer.data as SubChapterVO;
			obj.access = "public";
			for(var j : int = 0; j < obj.gallery.length; j++)
			{
				var gal : GalleryVO = obj.gallery[j] as GalleryVO;
				gal.access = "public";
				for(var k : int = 0;k<  gal.files.length; k++)
				{
					var file : WebFileVO = gal.files[k] as WebFileVO;
					file.access = "public";
				}
			}
			
			itemRenderer.data = obj;
			trace("Folder visible to all id: "+ target.selectedItem.id);
		}
		
		private function handleHideSubChapter(event : ContextMenuEvent) : void
		{
			if(target.selectedItem == null)
			{
				Alert.show("Please select a Sub Chapter first!!!");
			}else
			{
				var obj : Object = new Object();
				obj.id = target.selectedItem.id;
				trace("Hiding chapter");
				var service : HTTPService = new HTTPService();
				service.addEventListener(FaultEvent.FAULT, handleFault);
				service.addEventListener(ResultEvent.RESULT, handleHideResult);
				service.url = "/sub_chapter/hide/";
				service.send(obj);
			}
		}
		
		private function handleFault(event : FaultEvent) : void
		{
			trace(event.toString());
		}
		
		private function handleHideResult(event : ResultEvent) : void
		{
			trace("Hiding ....");
			var itemRenderer : IListItemRenderer =  target.itemToItemRenderer(target.selectedItem);
			var obj : SubChapterVO = itemRenderer.data as SubChapterVO;
			obj.access = "private";
			for(var j : int = 0; j < obj.gallery.length; j++)
			{
				var gal : GalleryVO = obj.gallery[j] as GalleryVO;
				gal.access = "private";
				for(var k : int = 0;k<  gal.files.length; k++)
				{
					var file : WebFileVO = gal.files[k] as WebFileVO;
					file.access = "private";
				}
			}
			itemRenderer.data = obj;
			trace(event.toString());
		}
		
		private function handleSetChapterPermissions(event : ContextMenuEvent) : void
		{
			
			if(target.selectedItem == null)
			{
				Alert.show("Please select a Chapter first!!!");
			}else
			{
				var popup : IFlexDisplayObject = PopUpManager.createPopUp(target, SetPermissionsPopup, true);
				var ac : ArrayCollection = new ArrayCollection();
				for(var i : int =0; i < 10; i++)
				{
					var item : Object = new Object();
					item.username = "User "+i.toString();
					item.allowed = false;
					ac.addItem(item);
				}
				
				PopUpManager.centerPopUp(popup);
				/* (popup as SetPermissionsPopup).friends.dataProvider = ac;
				(popup as SetPermissionsPopup).level = target.level;	 */
			}
			 
		}
		
		private function handleCreateSubChapter(event : ContextMenuEvent) : void
		{
			newSubChapter = new SubChapterVO();
			var dp : ArrayCollection = target.dataProvider as ArrayCollection;
			var cnt : int  = 0;
			for(var i : int = 0; i< dp.length; i++)
			{
				var name : String = dp.getItemAt(i).name ; 
				if(name.search("New") >= 0 && name.search("Chapter") >= 0 && name.search("Sub") >=0)
					cnt++;
				
			} 
			if(cnt != 0)
				newSubChapter.name = "New Sub Chapter "+(cnt);
			else
				newSubChapter.name = "New Sub Chapter ";
			if(target.proxyurl)
				newSubChapter.icon = target.proxyurl+"/user_content/photos/icon_thumbnails/folder_img.png";
			else
			  	 newSubChapter.icon = "/user_content/photos/icon_thumbnails/folder_img.png";
			var createChapterService : HTTPService = new HTTPService();
			//var output : String = JSON.encode(newChapter);
			var obj : Object = new Object();
			obj.tagid = target.currentChapter.id;
			obj.userId = HmmChaptersModel.getInstance().userId;
			obj.name = newSubChapter.name;
			obj.image = newSubChapter.icon;
			// Add service string
			createChapterService.url = "/sub_chapter/create";
			createChapterService.addEventListener(ResultEvent.RESULT, handleCreateResult);
			createChapterService.addEventListener(FaultEvent.FAULT, handleFault);
			createChapterService.contentType = HTTPService.RESULT_FORMAT_OBJECT;
			createChapterService.send(obj);
			FadingNotifier.setBusyState();
		}
		
		
		private function handleCreateResult(event : ResultEvent) : void
		{
			trace(event.toString());
			newSubChapter.id = int(event.result.subchapterid);
			newSubChapter.flag = true;
			var gallery : GalleryVO = new PhotoGalleryVO();
			gallery.id = event.result.photoid;
			newSubChapter.gallery.push(gallery);
			gallery.access = "semiprivate";
			newSubChapter.access = "semiprivate";
			gallery.writable = true;
			if(target.proxyurl)
				gallery.icon = target.proxyurl+gallery.icon;
			gallery = new VideoGalleryVO();
			gallery.id = event.result.videoid;
			newSubChapter.gallery.push(gallery);
			gallery.access = "semiprivate";
			gallery.writable = true;
			if(target.proxyurl)
				gallery.icon = target.proxyurl+gallery.icon;
			gallery = new AudioGalleryVO();
			gallery.id = event.result.audioid;
			gallery.access = "semiprivate";
			gallery.writable = true;
			if(target.proxyurl)
				gallery.icon = target.proxyurl+gallery.icon;
			newSubChapter.gallery.push(gallery);
			var datap : ArrayCollection = target.dataProvider as ArrayCollection;
			if(datap)
			{
				datap.addItem(newSubChapter);
			} else
			{
				datap = new ArrayCollection();
				datap.addItem(newSubChapter);
				target.dataProvider = datap;
			}	 
			
			FadingNotifier.removeBusyState();
		}
		
		
		
		
		
		private function handleDeleteSubChapter(event : ContextMenuEvent) : void
		{
			
			
			if(target.selectedItem == null)
			{
				Alert.show("Please select a Chapter first!!!");
				return;
			}
			Alert.show("Are you sure you want to delete the Sub-Chapter "+target.selectedItem.name+" ?", "Confirm Delete", Alert.YES | Alert.CANCEL, null, deleteSubChapter);
			
			
		}
		
		private function deleteSubChapter(event : CloseEvent) : void
		{
			if(event.detail == Alert.YES) 
			{
				var obj : Object = new Object();
				obj.id = target.selectedItem.id;
				var service : HTTPService = new HTTPService();
				service.addEventListener(FaultEvent.FAULT, handleFault);
				service.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
				service.addEventListener(ResultEvent.RESULT, handleDeleteResult);
				service.url = "/sub_chapter/destroy/";
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
			if(event.result != -1)
			{
				var dp : ArrayCollection = target.dataProvider as ArrayCollection;
				var delObj : Object;
				
				delObj = dp.removeItemAt(target.selectedIndex);
				try
				{
					HmmThrashModel.getInstance().addDeletedItem(delObj);
				}
				catch(ex : Error)
				{
					trace("Trash model not loaded.")
				}
			}
			FadingNotifier.removeBusyState();
		}
		
		private function handlePasteSubChapter(event : ContextMenuEvent) : void
		{
			if(clipBoardSubChapter == null)
				Alert.show("Copy a subchapter first!!!!");
			else
			{
				newSubChapter = new SubChapterVO();
				newSubChapter.name = clipBoardSubChapter.name;
				for(var i : int = 0; i < newSubChapter.gallery.length; i++)
				{
					var srcGallery : GalleryVO = clipBoardSubChapter.gallery[i] as GalleryVO;
					var destGallery : GalleryVO = new GalleryVO();
					for(var j : int =0; j < srcGallery.files.length; j++)
					{
						var sourceVO : WebFileVO = srcGallery.files[j] as WebFileVO;
						var destVO : WebFileVO = new WebFileVO();
						destVO.icon = sourceVO.icon;
						destVO.name = sourceVO.name;
						destGallery.files.push(destVO);
					}
					newSubChapter.gallery.push(destGallery);
						
				}
				
				var createChapterService : HTTPService = new HTTPService();
				//var output : String = JSON.encode(newChapter);
				var obj : Object = new Object();
				obj.tagid = target.currentFolder.id;
				obj.userId = HmmChaptersModel.getInstance().userId;
				obj.name = newSubChapter.name;
				obj.image = newSubChapter.icon;
				// Add service string
				createChapterService.url = "/sub_chapter/create";
				createChapterService.addEventListener(ResultEvent.RESULT, handleCreateResult);
				createChapterService.addEventListener(FaultEvent.FAULT, handleFault);
				createChapterService.contentType = HTTPService.RESULT_FORMAT_OBJECT;
				createChapterService.send(obj);
				CursorManager.showCursor();
			}
		}
		
		private function handleCutSubChapter(event : ContextMenuEvent) : void
		{
			var evt : HmmContextMenuEvents = new HmmContextMenuEvents(HmmContextMenuEvents.CUT_CHAPTER);
			dispatchEvent(evt);
			trace("Cut Chapter");
		}
		
		private function handleCopySubChapter(event : ContextMenuEvent) : void
		{
			var evt : HmmContextMenuEvents = new HmmContextMenuEvents(HmmContextMenuEvents.PASTE_CHAPTER);
			dispatchEvent(evt);
			trace("Paste Chapter");
		}
		
		public function getButtonBarData() : Array
		{
			 var buttonData : Array = new Array();
			//delete
			/*var newChap : Object = new Object();
			newChap.data = handleDeleteSubChapter;
			newChap.icon = IconClasses.deleteMouseOver;
			newChap.toolTip = "Delete Sub-Chapter";
			buttonData.push(newChap);
			// new chapter
			newChap = new Object();
			newChap.data = handleCreateSubChapter;
			newChap.icon = IconClasses.newChapterMouseOver;
			newChap.toolTip = "Create Sub-Chapter";
			buttonData.push(newChap);
			// hide chapter
			 newChap = new Object();
			newChap.data = handleHideSubChapter;
			newChap.icon = IconClasses.hideChapterMouseOver;
			newChap.toolTip = "Hide Sub-Chapter";
			buttonData.push(newChap);
			// Unhide chapter
			newChap = new Object();
			newChap.data = handleHideSubChapter;
			newChap.icon = IconClasses.hideChapterMouseOver;
			newChap.toolTip = "Unhide Sub-Chapter";
			buttonData.push(newChap); 
			//Set Permissions
			newChap = new Object();
			newChap.data = handleSetPermissions;
			newChap.icon = IconClasses.permissionsMouseOver;
			newChap.toolTip = "Set Sub-Chapter Permissions";
			buttonData.push(newChap); */
			return buttonData;
		}
		
	}
}