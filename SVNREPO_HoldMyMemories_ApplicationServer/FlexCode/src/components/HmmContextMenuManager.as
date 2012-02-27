package components
{
	import flash.ui.ContextMenu;
	
	public class HmmContextMenuManager
	{
		
		private static var instance : HmmContextMenuManager = new HmmContextMenuManager();
		private var contextMenus : Array;
		private var contextButtons : Array
		private var _view : ChaptersView;
		public function HmmContextMenuManager()
		{
			contextMenus = new Array();
			contextButtons = new Array();
		}
		
		public function set view( vw : ChaptersView) : void
		{
			var menu : HmmContextMenu = new HmmRootContextMenu();
			contextMenus[HmmContextMenuTypes.ROOT_MENU] = menu.createMenu();
			contextButtons[HmmContextMenuTypes.ROOT_MENU] = (menu as HmmRootContextMenu).getButtonBarData();
			menu.target = vw;
			menu = new HmmSubChapterContextMenu();
			contextMenus[HmmContextMenuTypes.SUBCHAPTER_MENU] = menu.createMenu();
			contextButtons[HmmContextMenuTypes.SUBCHAPTER_MENU] = (menu as HmmSubChapterContextMenu).getButtonBarData();
			menu.target = vw;
			menu = new HmmChaptersContextMenu();
			contextMenus[HmmContextMenuTypes.CHAPTER_MENU] = menu.createMenu();
			contextButtons[HmmContextMenuTypes.CHAPTER_MENU] = (menu as HmmChaptersContextMenu).getButtonBarData();
			menu.target = vw;
			menu = new HmmGalleryContextMenu();
			contextMenus[HmmContextMenuTypes.GALLERY_MENU] = menu.createMenu();
			contextButtons[HmmContextMenuTypes.GALLERY_MENU] = (menu as HmmGalleryContextMenu).getButtonBarData();
			menu.target = vw;
			
			
		}
		
		public function set tagEdit( edit : BatchEditTags) : void
		{
			var menu : HmmContextMenu = new HmmEditTagContextMenu();
			contextMenus[HmmContextMenuTypes.EDIT_TAGS] = menu.createMenu();
			(menu as HmmEditTagContextMenu).targetValue = edit;
			edit.contextMenu = contextMenus[HmmContextMenuTypes.EDIT_TAGS];
		}
		
		
		public static function getInstance() : HmmContextMenuManager
		{
			if(instance)
				return instance;
			else
				instance = new HmmContextMenuManager();
			
			return instance;
		}
		
		public function getContextMenu(menuName : int) : ContextMenu
		{
			if(menuName > HmmContextMenuTypes.GALLERY_MENU)
				return null;
			else
			{
				
				return contextMenus[menuName];
			}
				
		}
		
		public function getContextButtons(menuName : int) : Array
		{
			if(menuName > HmmContextMenuTypes.GALLERY_MENU)
				return null;
			else
			{
				
				return contextButtons[menuName];
			}
				
		}

	}
}