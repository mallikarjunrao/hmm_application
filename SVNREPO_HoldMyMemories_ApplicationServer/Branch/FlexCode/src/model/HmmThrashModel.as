package model
{
	import vo.ChapterVO;
	import vo.GalleryVO;
	import vo.SubChapterVO;
	import vo.WebFileVO;
	
	public class HmmThrashModel extends HmmChaptersModel
	{
		
		private static var instance : HmmThrashModel;
		public static function getInstance() : HmmThrashModel { return instance;}
		public static function setInstance(value : HmmThrashModel): void{ instance = value;} 
		
		private var chapters : Array;
		private var subChapters : Array;
		private var galleries : Array;
		private var contents : Array;
		public function HmmThrashModel()
		{
			super();
		}
		
		override public function set data(root:Object):void 
		{
 			if(root)
			{
				if(root.chapters && root.chapters.chapter)
					chapters = getChapters(root.chapters.chapter);
				else
					chapters = [];
				if(root.subchapters && root.subchapters.subchapter)	
					subChapters = getSubChapters(root.subchapters);
				else
					subChapters = [];
				if(root.galleries && root.galleries.gallery)	
					galleries = getGalleries(root.galleries.gallery);
				else
					galleries = [];
				if(root.contents && root.contents.content)
					contents = getFiles(root.contents.content, null);
				else
					contents = [];
				mergeData();
			}
				
		}
		
		private function mergeData() : void
		{
			for(var i : int =0; i < galleries.length; i++)
			{
				for(var j : int = 0; j< contents.length; j++)
				{
					var content : WebFileVO = contents[j] as WebFileVO;
					if(content.galleryid == galleries[i].id)
					{
						var obj : Object = contents.splice(j, 1);
						var gallery : GalleryVO = galleries[i] as GalleryVO;
						gallery.files.push(obj);
						j--;
					}
				}
			}
			
			for(i = 0; i < subChapters.length; i++)
			{
				for( j = 0; j< galleries.length; j++)
				{
					gallery = galleries[j] as GalleryVO;
					if(gallery.subChapterId == subChapters[i].id)
					{
						obj = galleries.splice(j, 1);
						var subchapter : SubChapterVO = subChapters[i] as SubChapterVO;
						subchapter.gallery.push(obj);
						j--;
					}
				}
			}
			
			for(i = 0; i < chapters.length; i++)
			{
				for(j = 0; j< subChapters.length; j++)
				{
					var subChapter : SubChapterVO = subChapters[j] as SubChapterVO;
					if(subChapter.tagid == chapters[i].id)
					{
						obj = subChapters.splice(j, 1);
						var chapter : ChapterVO = chapters[i] as ChapterVO;
						chapter.subchapters.push(obj);
						j--;
					}
				}
			}
			
			var merged : Array = new Array();
			merged = merged.concat(chapters);
			merged = merged.concat(subChapters);
			merged = merged.concat(galleries);
			merged = merged.concat(contents);
			
			folders = merged;
		}
		
		/* private function getChapters(chapters : Object) : Array
		{
			var retChapter : Array = new Array();
			if(chapters is ArrayCollection)
			{
				for(var i : int = 0; i < chapters.length; i++)
				{
					var chapter : ChapterVO = new ChapterVO();
					chapter.name = chapters[i].name;
					chapter.icon = chapters[i].icon;
					chapter.access = chapters[i].access;
					chapter.id = chapters[i].id;
					chapter.tags = chapters[i].tags;
					chapter.description = chapters[i].description;
					var subchapters :ArrayCollection;
					retChapters.push(chapter);
										
				}
				
				
			}else
			{
					chapter = new ChapterVO();
					chapter.name = chapters.name; 
					chapter.icon = chapters.icon;
					chapter.id = chapters.id;
					chapter.access = chapters.access;
					chapter.tags = chapters.tags;
					chapter.description = chapters.description;
					if(chapters.subchapters)
					{
						chapter.subchapters = getSubChapters(chapters.subchapters);
						 
					}
					retChapters.push(chapter);
			
			}
			return retChapter;
		} */
		
		public function addDeletedItem(item : Object) : void
		{
			if(item is WebFileVO)
			{
				contents.push(item);
			}else if(item is GalleryVO)
			{
				galleries.push(item);	
			}else if(item is SubChapterVO)
			{
				subChapters.push(item);	
			}else if(item is ChapterVO)
			{
				chapters.push(item);
			}
			mergeData();
			
		}
		
		public function restoreItem(item : Object) : Object
		{
			var idx : int;
			var delObj : Object;
			if(item is WebFileVO)
			{
				idx  = contents.indexOf(item);
				delObj = contents.splice(idx, 1);
			}else if(item is GalleryVO)
			{
				idx  = galleries.indexOf(item);
				delObj = galleries.splice(idx, 1);	
			}else if(item is SubChapterVO)
			{
				idx  = subChapters.indexOf(item);
				delObj = subChapters.splice(idx, 1);	
			}else if(item is ChapterVO)
			{
				idx  = chapters.indexOf(item);
				delObj = chapters.splice(idx, 1);
			}
			mergeData();
			return delObj[0];
		}
		
		public function deleteItem(item : Object) : void
		{
			var idx : int;
			var delObj : Object;
			if(item is WebFileVO)
			{
				idx  = contents.indexOf(item);
				delObj = contents.splice(idx, 1);
			}else if(item is GalleryVO)
			{
				idx  = galleries.indexOf(item);
				delObj = galleries.splice(idx, 1);	
			}else if(item is SubChapterVO)
			{
				idx  = subChapters.indexOf(item);
				delObj = subChapters.splice(idx, 1);	
			}else if(item is ChapterVO)
			{
				idx  = chapters.indexOf(item);
				delObj = chapters.splice(idx, 1);
			}	
			mergeData();
		}
		
		public function clear() : void
		{
			contents = new Array();
			chapters = new Array();
			subChapters = new Array();
			galleries = new Array();
			mergeData();
		}

	}
}