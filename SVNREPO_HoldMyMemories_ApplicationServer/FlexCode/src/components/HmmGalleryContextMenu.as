package components
{
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import helpers.DebugAlert;
	
	import model.HmmThrashModel;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.IDataRenderer;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import vo.WebFileVO;
	
	public class HmmGalleryContextMenu extends HmmContextMenu implements IHmmContextMenuTarget
	{
		public function HmmGalleryContextMenu()
		{
			//TODO: implement function
			super();
		}
		
		override public function createMenu():ContextMenu
		{
			super.createMenu();
			super.clearMenus();
			
			var item : ContextMenuItem = new ContextMenuItem("Export to a friend");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleExportSelected);
			contextMenu.customItems.push(item);
			
			item = new ContextMenuItem("Share with a friend");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleShareSelected);
			contextMenu.customItems.push(item);
			
			/* var rotateItemLeft : ContextMenuItem = new ContextMenuItem("Rotate left");
			rotateItemLeft.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleRotateLeft);
			contextMenu.customItems.push(rotateItemLeft);
			
			var rotateItemRight : ContextMenuItem = new ContextMenuItem("Rotate right");
			rotateItemRight.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleRotateRight);
			contextMenu.customItems.push(rotateItemRight); */
			
			var item : ContextMenuItem = new ContextMenuItem("Set as Chapter Icon");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleSetChapterIcon);
			contextMenu.customItems.push(item);
			
			item = new ContextMenuItem("Set as Sub Chapter Icon");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleSetSubChapterIcon);
			contextMenu.customItems.push(item);
			
			item = new ContextMenuItem("Set Gallery Icon");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleGalleryIcon);
			contextMenu.customItems.push(item);
			
			item = new ContextMenuItem("Delete Item");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleDeleteGalleryItem);
			contextMenu.customItems.push(item);
			
			item = new ContextMenuItem("Preview Item");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handlePreviewGalleryItem);
			contextMenu.customItems.push(item);
			
			/* item = new ContextMenuItem("Set Item Description");
			//item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleDeleteGalleryItem);
			contextMenu.customItems.push(item); */
			
			item = new ContextMenuItem("Set Permissions");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleSetPermissions);
			contextMenu.customItems.push(item);
			return contextMenu;
			
		}
		
		private function handleRotateLeft(event : Event) : void
		{
			
		}
		
		private function handleRotateRight(event : Event) : void
		{
			
		}
		
		private function handleExportSelected(event : Event) : void 
		 {
			 if(event == null)
				isContextMenuCall = false;
			else
				isContextMenuCall = true;
			if((!isContextMenuCall && target.selectedItem == null) || (isContextMenuCall && target.rollOverIndex == -1))
			{
				Alert.show("Please select something first!!!");
				return;
			}
			
			
			
			createExpPopup(true,"Export to a friend.","Export was successful. The content will be imported to your friend's account once your friend approves this request",target.proxyurl+"/export_moments/exporter/");
			//var ctrl : ExportControl = createExpPopup(true);
			//ctrl.title = "Export to a friend.";
			//ctrl.successMessage = "Export was successful. The content will be imported to your friend's account once your friend approves this request";
			//ctrl.serviceUrl = "/export/exporter/";
			//ctrl.isExport = true; *
		} 
		private function createExpPopup(export : Boolean,title : String, successMessage : String, serviceUrl : String) :  void//ExportControl
		{
			var popUp : MomentExport = PopUpManager.createPopUp(Application.application as DisplayObject, MomentExport, true) as MomentExport;
			popUp.selectedItem = target.selectedItem as WebFileVO;
			// popUp.width = Application.application.stage.width*2/3;
			//popUp.height = Application.application.stage.height*2/3; 
			//popUp.width = 645;//Application.application.stage.width*2/3;
			popUp.isExport = export; 
		    popUp.width = Application.application.stage.width;
			popUp.height = Application.application.stage.height*2/3;
			 //popUp.height = Application.application.stage.height;
			//popUp.title = title;
			popUp.successMessage = successMessage;
			popUp.serviceUrl = serviceUrl; 
			//popUp.isExport = export;
			//PopUpManager.centerPopUp(popUp);
			//return popUp as ExportControl;
		}
		private function handleShareSelected(event  : Event) : void
	    {
			 createExpPopup(false,"Share with a friend.","Share was successful. Your friend(s) would receive an email in this regard.",target.proxyurl+"/share_moments/addShare/");
			//var ctrl : ExportControl = createExpPopup(false,"Share with a friend.","Share was successful. Your friend(s) would receive an email in this regard.","/share/addShare/");
			/* ctrl.title = "Share with a friend.";
			ctrl.successMessage = "Share was successful. Your friend(s) would receive an email in this regard.";
			ctrl.serviceUrl = "/share/addShare/"; */
			//ctrl.isExport = false; 
		} 
		private function handleGalleryIcon(event : ContextMenuEvent) : void
		{
			if(target.selectedItem == null )
			{
				Alert.show("Please select an icon first");
			}else if((target.selectedItem as WebFileVO).type == "audio")
			{
				Alert.show("Operation not permitted for audio gallery.", "Message");
			}else
			{
				var proxy : String;
				if(Application.application.parameters.hasOwnProperty("proxy"))
				{
					proxy = Application.application.parameters.proxy;
				}
				else
				{
					proxy = "csrv";
				}
				var setThumbNail : HTTPService = new HTTPService();
				//setThumbNail.url = "/"+proxy+"/galleries/setThumbnail/";
				setThumbNail.url = target.proxyurl+"/manage_icon/set_gallery_icon/";
				setThumbNail.addEventListener(ResultEvent.RESULT, handleGalleryIconResult);
				setThumbNail.addEventListener(FaultEvent.FAULT, handleFault);
				
				var obj : Object = new Object;
				obj.id = target.currentGallery.id;
				obj.itemId = target.selectedItem.id;
				setThumbNail.send(obj);
				FadingNotifier.setBusyState();
				CursorManager.setBusyCursor();
			}
		}
		
		private function handleGalleryIconResult(event : ResultEvent) : void
		{
			DebugAlert.show(event.result.toString());
			var url : String = target.currentGallery.icon;
			var exploded : Array = url.split("/");
			if(exploded.length > 0)
			{
				exploded[exploded.length-2] = "icon_thumbnails";
				exploded[exploded.length-1] = event.result;
			}
			target.currentGallery.icon = exploded.join("/");
			trace("icon updated");
			FadingNotifier.removeBusyState();
			CursorManager.removeBusyCursor();
		}
		
		private function handleSetChapterIcon(event : ContextMenuEvent) : void
		{
			if(target.selectedItem == null)
			{
				Alert.show("Please select an icon first");
			}else
			{
				
				var proxy : String; 
				if(Application.application.parameters.hasOwnProperty("proxy"))
				{
					proxy = Application.application.parameters.proxy;
				}
				else
				{
					proxy = "csrv";
				}
				var setThumbNail : HTTPService = new HTTPService();
				//setThumbNail.url = "/"+proxy+"/tags/setThumbnail/";
				setThumbNail.url = target.proxyurl+"/manage_icon/set_chapter_icon/";
				setThumbNail.addEventListener(ResultEvent.RESULT, handleUpdateChapterIcon);
				setThumbNail.addEventListener(FaultEvent.FAULT, handleFault);
				
				var obj : Object = new Object;
				obj.id = target.currentChapter.id;
				obj.itemId = target.selectedItem.id;
				setThumbNail.send(obj);
				FadingNotifier.setBusyState();
				CursorManager.setBusyCursor();
			}
		}
		
		private function handleUpdateChapterIcon(event : ResultEvent) : void
		{
			DebugAlert.show(event.result.toString());
			var url : String = target.currentChapter.icon;
			var exploded : Array = url.split("/");
			if(exploded.length > 0)
			{
				exploded[exploded.length-2] = "icon_thumbnails";
				exploded[exploded.length-1] = event.result;
			}
			target.currentChapter.icon = exploded.join("/");
			FadingNotifier.removeBusyState();
			CursorManager.removeBusyCursor();
			trace("icon updated");
		}
		
		
		private function handleSetSubChapterIcon(event : ContextMenuEvent) : void
		{
			if(target.selectedItem == null)
			{
				Alert.show("Please select an icon first");
			}else
			{
				var proxy : String;
				if(Application.application.parameters.hasOwnProperty("proxy"))
				{
					proxy = Application.application.parameters.proxy;
				}
				else
				{
					proxy = "csrv";
				}
				var setThumbNail : HTTPService = new HTTPService();
				//setThumbNail.url = "/"+proxy+"/sub_chapter/setThumbnail/";
				setThumbNail.url = target.proxyurl+"/manage_icon/set_subchapter_icon/";
				setThumbNail.addEventListener(ResultEvent.RESULT, handleUpdateSubChapterIcon);
				setThumbNail.addEventListener(FaultEvent.FAULT, handleFault);
				
				var obj : Object = new Object;
				obj.id = target.currentSubChapter.id;
				obj.itemId = target.selectedItem.id;
				setThumbNail.send(obj);
				FadingNotifier.setBusyState();
				CursorManager.setBusyCursor();
			}
		}
		
		private function handleUpdateSubChapterIcon(event : ResultEvent) : void
		{
			DebugAlert.show(event.result.toString());
			var url : String = target.currentSubChapter.icon;
			var exploded : Array = url.split("/");
			if(exploded.length > 0)
			{
				exploded[exploded.length-2] = "icon_thumbnails";
				exploded[exploded.length-1] = event.result;
			}
			target.currentSubChapter.icon = exploded.join("/");
			FadingNotifier.removeBusyState();
			CursorManager.removeBusyCursor();
			trace("icon updated");
		}
		
		private function handleDeleteGalleryItem(event : ContextMenuEvent) : void
		{
			
			if(target.selectedItem == null)
			{
				Alert.show("Please select an icon first");
				return;
			}
				
			Alert.show("Are you sure you want to delete the item "+target.selectedItem.name+" ?", "Confirm Delete", Alert.YES | Alert.CANCEL, null, deleteGalleryItem);
		}
		
		private function deleteGalleryItem(event : CloseEvent) : void
		{
			if(event.detail == Alert.YES)
			{
				var obj : Object = new Object();
				obj.id = target.selectedItem.id;	
				var service : HTTPService = new HTTPService();
				service.addEventListener(FaultEvent.FAULT, handleFault);
				service.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
				service.addEventListener(ResultEvent.RESULT, handleDeleteResult);
				service.url = "/user_content/delete/";
				service.send(obj);
				setWindowModal();
				CursorManager.setBusyCursor();
			}else
			{
				target.selectedItem = null;
				target.selectedIndex = -1;
			}
			
		}
		
		private function handleDeleteResult(event : ResultEvent) : void
		{
			var delObj : Object;
			var ac : ArrayCollection = target.dataProvider as ArrayCollection;
			
			
			delObj = ac.removeItemAt(target.selectedIndex);
			try
			{
				HmmThrashModel.getInstance().addDeletedItem(delObj);
			}
			catch(ex : Error)
			{
				trace("Trash model not loaded");
			}
			removeModalWindow();
			CursorManager.removeBusyCursor();	
		}
		
		private function handleFault(event : FaultEvent) : void
		{
			DebugAlert.show(event.toString());
			trace(event.toString());	
		}
		
		private function handlePreviewGalleryItem(event : ContextMenuEvent) : void
		{
			var popup : IFlexDisplayObject = PopUpManager.createPopUp(target, PreviewPopup, true);
			
			PopUpManager.centerPopUp(popup);
			(popup as PreviewPopup).galleryType = target.currentGallery.type;
			(popup as PreviewPopup).selectedIndex = target.selectedIndex;
			(popup as IDataRenderer).data = target.selectedItem;
			(popup as PreviewPopup).contentAC = target.dataProvider as ArrayCollection;
			
		}
		
		
		
		public function getButtonBarData() : Array
		{
			var buttonData : Array = new Array();
			//delete
			/* var newChap : Object = new Object();
			newChap.data = handleDeleteGalleryItem;
			newChap.toolTip = "Delete Item";
			newChap.icon = IconClasses.deleteMouseOver;
			buttonData.push(newChap);
			// new chapter
			newChap = new Object();
			newChap.data = handleSetChapterIcon;
			newChap.toolTip = "Set Chapter Icon";
			newChap.icon = IconClasses.newChapterMouseOver;
			buttonData.push(newChap);
			// hide chapter
			newChap = new Object();
			newChap.data = handleSetSubChapterIcon;
			newChap.toolTip = "Set Sub-Chapter Icon";
			newChap.icon = IconClasses.hideChapterMouseOver;
			buttonData.push(newChap);
			// Unhide chapter
			newChap = new Object();
			newChap.data = handleGalleryIcon;
			newChap.toolTip = "Set Gallery Icon";
			newChap.icon = IconClasses.hideChapterMouseOver;
			buttonData.push(newChap);
			//Set Permissions
			newChap = new Object();
			newChap.data = handleSetPermissions;
			newChap.toolTip = "Preview Item";
			newChap.icon = IconClasses.permissionsMouseOver;
			buttonData.push(newChap); */
			return buttonData;
		}
		
		
	}
}