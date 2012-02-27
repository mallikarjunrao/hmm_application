package vo
{
	public class ChapterVO extends BaseVO
	{
		public var subchapters : Array; 
		public var writable : Boolean = false;
		public var hidden : Boolean;
		public var defaultTag : String;
		
		public function ChapterVO()
		{
			//TODO: implement function
			super();
			classType = "chapterVO";
			icon = "user_content/photos/icon_thumbnails/folder_img.png";
			subchapters = [];
			
		}
		
	}
}