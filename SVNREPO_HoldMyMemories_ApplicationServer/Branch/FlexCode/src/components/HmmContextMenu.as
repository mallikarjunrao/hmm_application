package components
{
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import vo.BaseVO;
	import vo.ChapterVO;
	import vo.GalleryVO;
	import vo.SubChapterVO;
	import vo.WebFileVO;
	
	public class HmmContextMenu extends EventDispatcher implements IHmmContextMenuTarget
	{
		protected var contextMenu : ContextMenu;
		protected var targetList : Object;
		protected var isContextMenuCall : Boolean;
		protected var rollOverIndex : int;
		protected var popup : IFlexDisplayObject;
		private var isExport : Boolean = false;
		public function set target(tg : ChaptersView) : void
		{
			targetList = tg;
		}
		
		public function get target() : ChaptersView
		{
			return targetList as ChaptersView;
		}
		
		public function HmmContextMenu()
		{
			contextMenu = new ContextMenu();
			super();
			
		}
		
		public function createMenu() : ContextMenu
		{
			contextMenu.hideBuiltInItems();
			clearMenus();
			var item : ContextMenuItem = new ContextMenuItem("Export to a friend");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleExportSelected);
			contextMenu.customItems.push(item);
			
			item = new ContextMenuItem("Share with a friend");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleShareSelected);
			contextMenu.customItems.push(item);
			
			contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, handleMenuSelected);
			return null;
		}
		
		protected function handleMenuSelected( event : Event) : void
		{
			if(!target || target.rollOverIndex == -1)
			{
				return;
			}
			try{
			var ac : ArrayCollection = target.dataProvider as ArrayCollection;
			var selection : BaseVO = ac.getItemAt(target.rollOverIndex) as BaseVO;
			target.selectedItem = selection;
			}
			catch(e : RangeError)
			{
				return;
			}	
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
			isExport = true;
			loadData()
			//var ctrl : ExportControl = createExpPopup(true);
			//ctrl.title = "Export to a friend.";
			//ctrl.successMessage = "Export was successful. The content will be imported to your friend's account once your friend approves this request";
			//ctrl.serviceUrl = "/export/exporter/";
			//ctrl.isExport = true;
		}
		
		private function createExpPopup(export : Boolean,title : String, successMessage : String, serviceUrl : String) :  void//ExportControl
		{
			//var popUp : IFlexDisplayObject = PopUpManager.createPopUp(Application.application as DisplayObject, ExportControl, true);
			var popUp : ExportControl = PopUpManager.createPopUp(Application.application as DisplayObject, ExportControl, true) as ExportControl;
			if(isContextMenuCall)
			{
				var ac : ArrayCollection = target.dataProvider as ArrayCollection;
				var treeData : BaseVO = ac[target.selectedIndex] as BaseVO;
				ExportControl(popUp).treeData = treeData;	
			}else
			{
				popUp.treeData = target.selectedItem as BaseVO;
				//ExportControl(popUp).treeData = target.selectedItem as BaseVO;
			}
			
			/* popUp.width = Application.application.stage.width*2/3;
			popUp.height = Application.application.stage.height*2/3; */
			popUp.width = Application.application.stage.width -20;
			popUp.height = Application.application.stage.height;
			//popUp.title = title;
			popUp.successMessage = successMessage;
			popUp.serviceUrl = serviceUrl;
			popUp.isExport = export;
			PopUpManager.centerPopUp(popUp);
			//return popUp as ExportControl;
		}
		
		private function handleShareSelected(event  : Event) : void
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
			isExport = false;
			loadData()
			//var ctrl : ExportControl = createExpPopup(false,"Share with a friend.","Share was successful. Your friend(s) would receive an email in this regard.","/share/addShare/");
			/* ctrl.title = "Share with a friend.";
			ctrl.successMessage = "Share was successful. Your friend(s) would receive an email in this regard.";
			ctrl.serviceUrl = "/share/addShare/"; */
			//ctrl.isExport = false;
		}
		
		private  var loading : LoadingDataPopup;
		
		private function loadData() : void
		{
			loading = PopUpManager.createPopUp(target,LoadingDataPopup,true) as LoadingDataPopup;
			loading.width = 200;
			loading.height = 100;
			PopUpManager.centerPopUp(loading);
			
			if(target.selectedItem is ChapterVO)
			{
				var chp : ChapterVO = target.selectedItem as ChapterVO;
				var chapterService : HTTPService = new HTTPService();
				chapterService.url = "/load_data/loadalldatachapterlevel/"+chp.id;
				chapterService.addEventListener(ResultEvent.RESULT,handleSubChapterListResult);
				chapterService.addEventListener(FaultEvent.FAULT,handleSubChapterListFault);
				chapterService.send();	
			}
			else if(target.selectedItem is SubChapterVO)
			{
				var sub : SubChapterVO = target.selectedItem as SubChapterVO;
				var subchapterService : HTTPService = new HTTPService();
				subchapterService.url = "/load_data/loadalldatasubchapterlevel/"+sub.id;
				subchapterService.addEventListener(ResultEvent.RESULT,handleGalleryListResult);
				subchapterService.addEventListener(FaultEvent.FAULT,handleGalleryListFault);
				subchapterService.send();
			}
			else
			{
				var gall : GalleryVO = target.selectedItem as GalleryVO;
				var galleryService : HTTPService = new HTTPService();
				galleryService.url = "/load_data/loadalldatagallerylevel/"+gall.id;
				galleryService.addEventListener(ResultEvent.RESULT,handleContentListResult);
				galleryService.addEventListener(FaultEvent.FAULT,handleContentListFault);
				galleryService.send();
			}
		}
			
		protected function clearMenus() : void
		{
			contextMenu.customItems = new Array();
		}
		
		protected function setWindowModal() : void
		{
			popup = PopUpManager.createPopUp(target, Canvas, true);
			popup.width = 0;
			popup.height = 0;
			
		}
		
		protected function removeModalWindow() : void
		{
			PopUpManager.removePopUp(popup);
		}
		

		protected function handleSetPermissions(event : Event) : void
		{
			if(target.selectedItem == null)
			{
				Alert.show("Please select an item first.!!!", "Item Selection Error");
				return;
			}
			else
			{
			var popup : IFlexDisplayObject = PopUpManager.createPopUp(target, SetPermissionsPopup, true);
			SetPermissionsPopup(popup).selectedVO = target.selectedItem as BaseVO;
			SetPermissionsPopup(popup).selectedItem = target.selectedItem;
			SetPermissionsPopup(popup).targetList = target;
			PopUpManager.centerPopUp(popup);
				
			}
		}
		
		private function handleSubChapterListResult(event : ResultEvent) : void
		{
			var retSubChapters : Array = new Array();
				if(event.result.subChapters)
				{
					if(event.result.subChapters.subchapter is ArrayCollection)
					{
						for(var i : int = 0; i < event.result.subChapters.subchapter.length; i++)
						{
							var subchapter : SubChapterVO = new SubChapterVO();
							subchapter.name = event.result.subChapters.subchapter[i].name;
							subchapter.icon = event.result.subChapters.subchapter[i].icon;
							subchapter.id = event.result.subChapters.subchapter[i].id;
							if(event.result.subChapters.subchapter[i].tagid)
							{
								subchapter.tagid = event.result.subChapters.subchapter[i].tagid;
							}
							subchapter.access = event.result.subChapters.subchapter[i].access;
							subchapter.tags = event.result.subChapters.subchapter[i].tags;
							subchapter.description = event.result.subChapters.subchapter[i].description;
							if(event.result.subChapters.subchapter[i].galleries)
							{
								subchapter.gallery = getGalleries(event.result.subChapters.subchapter[i].galleries.gallery);	
							}
							retSubChapters.push(subchapter);
												
						}
						
						
					}
					else
					{
							var subchapter : SubChapterVO = new SubChapterVO();
							subchapter.name = event.result.subChapters.subchapter.name;
							subchapter.icon = event.result.subChapters.subchapter.icon;
							subchapter.id = event.result.subChapters.subchapter.id;
							subchapter.access = event.result.subChapters.subchapter.access;
							subchapter.tags = event.result.subChapters.subchapter.tags;
							if(event.result.subChapters.subchapter.tagid)
							{
								subchapter.tagid = event.result.subChapters.subchapter.tagid;
							}
							subchapter.description = event.result.subChapters.subchapter.description;
							if(event.result.subChapters.subchapter.galleries)
							{
								subchapter.gallery = getGalleries(event.result.subChapters.subchapter.galleries.gallery);	
							}
							retSubChapters.push(subchapter);
					
					}
				}
				(target.selectedItem as ChapterVO).subchapters = retSubChapters;
				loadingDataFinished()
		}
		
		
		private function handleSubChapterListFault(fault : FaultEvent) : void
		{
			  PopUpManager.removePopUp(loading);
			Alert.show("Unable to load contents! \n Please try again.");
		}
		
		private function handleGalleryListResult(event : ResultEvent) : void
		{
			var retGalleries : Array = new Array();
				if(event.result.galleries)
				{
					if(event.result.galleries.gallery is ArrayCollection)
					{
						
						for(var i : int = 0; i < event.result.galleries.gallery.length; i++)
						{
							var gallery : GalleryVO = new GalleryVO();
							gallery.type = event.result.galleries.gallery[i].type;
							// check if there is atleast one album
							gallery.files = new Array();
							if(event.result.galleries.gallery[i].subchapterid)
							{
								gallery.subChapterId = event.result.galleries.gallery[i].subchapterid;
							}
							gallery.name = event.result.galleries.gallery[i].name;
							gallery.id = event.result.galleries.gallery[i].id;
							gallery.icon = event.result.galleries.gallery[i].icon;
							gallery.access = event.result.galleries.gallery[i].access;
							gallery.description = event.result.galleries.gallery[i].description;
							gallery.tags = event.result.galleries.gallery[i].tags;
							if(event.result.galleries.gallery[i].files)
							{
								gallery.files = getFiles(event.result.galleries.gallery[i].files.file, gallery.type);	
							}else
							{
								gallery.files = new Array();
							}
							gallery.writable = true;
							retGalleries.push(gallery);
						}
					}
					else
					{
						var gallery : GalleryVO = new GalleryVO();
						gallery.name = event.result.galleries.gallery.name;
						gallery.icon = event.result.galleries.gallery.icon;
						gallery.id = event.result.galleries.gallery.id;
						gallery.type = event.result.galleries.gallery.type;
						gallery.description = event.result.galleries.gallery.description;
						gallery.tags = event.result.galleries.gallery.tags;
						if(event.result.galleries.gallery.subchapterid)
						{
							gallery.subChapterId = event.result.galleries.gallery.subchapterid;
						}
						gallery.files = new Array
						gallery.access = event.result.galleries.gallery.access;
						gallery.writable = true;
						if(event.result.galleries.files)
					    {
							gallery.files = getFiles(event.result.galleries.files.file, gallery.type);	
						}else
						{
							gallery.files = new Array();
						}
						retGalleries.push(gallery);
					}
				}
				(target.selectedItem as SubChapterVO).gallery = retGalleries; 
				loadingDataFinished()
		}
		
		private function handleGalleryListFault(fault : FaultEvent) : void
		{
			 PopUpManager.removePopUp(loading);
			Alert.show("Unable to load contents! \n Please try again.");
		}
		
		private function handleContentListResult(event : ResultEvent) : void
		{
			var retFiles : Array = new Array();
				if(event.result.files)
				{
					if(event.result.files.file is ArrayCollection)
					{
						
						
						for(var f : int = 0; f < event.result.files.file.length; f++)
						{
							var file : WebFileVO = new WebFileVO();
							file.icon = event.result.files.file[f].icon;
							file.name = event.result.files.file[f].name;
							file.id = event.result.files.file[f].id;
							file.access = event.result.files.file[f].access;
							file.tags = event.result.files.file[f].tags;
							if(event.result.files.file[f].galleryid)
							{
								file.galleryid = event.result.files.file[f].galleryid; 
							}
							file.description = event.result.files.file[f].description;
							file.creationDate = new Date(event.result.files.file[f].creationdate);
							file.type = event.result.files.file[f].type;
							retFiles.push(file);
							//fileMap[files[f].id] = file;
						} 
					}else
					{
						    file = new WebFileVO();
						    file.id = event.result.files.file.id;
						    file.access = event.result.files.file.access;
							file.icon = event.result.files.file.icon as String;
							file.name = event.result.files.file.name as String;
							if(event.result.files.file.galleryid)
							{
								file.galleryid = event.result.files.file.galleryid; 
							}
							file.tags = event.result.files.file.tags;
							file.description = event.result.files.file.description;
							file.creationDate = new Date(event.result.files.file.creationdate);
							file.type = event.result.files.file.type;
							retFiles.push(file);
							//fileMap[files.id] = file;
					}	
				}
				
				(target.selectedItem as GalleryVO).files = retFiles; 
				loadingDataFinished()
		}
		
		private function handleContentListFault(fault : FaultEvent) : void
		{
			PopUpManager.removePopUp(loading);
			Alert.show("Unable to load contents! \n Please try again.");
		}
		
		protected function getFiles(files : Object, type : String) : Array
		{
			var retFiles : Array = new Array();
			if(files)
			{
				if(files is ArrayCollection)
				{
					
					
					for(var f : int = 0; f < files.length; f++)
					{
						var file : WebFileVO = new WebFileVO();
						file.icon = files[f].icon;
						file.name = files[f].name;
						file.id = files[f].id;
						file.access = files[f].access;
						file.tags = files[f].tags;
						if(files[f].galleryid)
						{
							file.galleryid = files[f].galleryid; 
						}
						file.description = files[f].description;
						file.creationDate = new Date(files[f].creationdate);
						file.type = files[f].type;
						retFiles.push(file);
						//fileMap[files[f].id] = file;
					} 
				}else
				{
					    file = new WebFileVO();
					    file.id = files.id;
					    file.access = files.access;
						file.icon = files.icon as String;
						file.name = files.name as String;
						if(files.galleryid)
						{
							file.galleryid = files.galleryid; 
						}
						file.tags = files.tags;
						file.description = files.description;
						file.creationDate = new Date(files.creationdate);
						file.type = files.type;
						retFiles.push(file);
						//fileMap[files.id] = file;
				}	
			}
			
			return retFiles;
		}
		
		protected function getGalleries(galleries : Object) : Array
		{
			var retGalleries : Array = new Array();
			if(galleries is ArrayCollection)
			{
				
				for(var i : int = 0; i < galleries.length; i++)
				{
					var gallery : GalleryVO = new GalleryVO();
					gallery.type = galleries[i].type;
					// check if there is atleast one album
					if(galleries[i].files)
					{
						gallery.files = getFiles(galleries[i].files.file, gallery.type);	
					}else
					{
						gallery.files = new Array();
					}
					if(galleries[i].subchapterid)
					{
						gallery.subChapterId = galleries[i].subchapterid;
					}
					gallery.name = galleries[i].name;
					gallery.id = galleries[i].id;
					gallery.icon = galleries[i].icon;
					gallery.access = galleries[i].access;
					gallery.description = galleries[i].description;
					gallery.tags = galleries[i].tags;
					gallery.writable = true;
					retGalleries.push(gallery);
				}
			}else
			{
				gallery = new GalleryVO();
				gallery.name = galleries.name;
				gallery.icon = galleries.icon;
				gallery.id = galleries.id;
				gallery.type = galleries.type;
				gallery.description = galleries.description;
				gallery.tags = galleries.tags;
				if(galleries.subchapterid)
				{
					gallery.subChapterId = galleries.subchapterid;
				}
				if(galleries.files)
				{
					gallery.files = getFiles(galleries.files.file, gallery.type);	
				}else
				{
					gallery.files = new Array
				}
				
				gallery.access = galleries.access;
				gallery.writable = true;
				retGalleries.push(gallery);
			}
			
			return retGalleries;
		}
		
		private function loadingDataFinished() : void
		{
			
			if(isExport)
			{
				createExpPopup(true,"Export to a friend.","Export was successful. The content will be imported to your friend's account once your friend approves this request",target.proxyurl+"/export_moments/exporter/");
			    PopUpManager.removePopUp(loading);
			}
			else
			{
				createExpPopup(false,"Share with a friend.","Share was successful. Your friend(s) would receive an email in this regard.",target.proxyurl+"/share_moments/addShare/");
				PopUpManager.removePopUp(loading);				
			}
		}
		
				
		
		
		
		
	}
}