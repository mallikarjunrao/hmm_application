package model
{
	import de.polygonal.ds.TreeIterator;
	import de.polygonal.ds.TreeNode;
	
	import mx.collections.ArrayCollection;
	
	import vo.BaseVO;
	import vo.ChapterVO;
	import vo.GalleryVO;
	import vo.SubChapterVO;
	import vo.TagVO;
	import vo.WebFileVO;
	
	public class HmmDataModel
	{
		private static var _instance : HmmDataModel;
		private var _root : TreeNode;
		private var _iterator : TreeIterator;
		public static function getInstance() : HmmDataModel
		{
			if(_instance == null)
			{
				_instance = new HmmDataModel();
			}
			return _instance;
		}
		
		public function HmmDataModel()
		{
		}
		
		public function set data(value : ArrayCollection) : void
		{
			_root = new TreeNode("root", null);
			var prevChapterId : int = -1;
			var prevSubChapterId : int = -1;
			var prevGalleryId : int = -1;
			/* if(value.length > 0)
			{
				var tagvo : TagVO = value[0];
				prevChapterId = tagvo.tagid;
				prevGalleryId = tagvo.galleryid;
				prevSubChapterId = tagvo.subchapterid
			} */
			var chapterVO : ChapterVO;
			var subChapterVO : SubChapterVO;
			var galleryVO : GalleryVO;
			var contentVO : WebFileVO;
			var chapterTreeNode : TreeNode;
			var subChapterTreeNode : TreeNode;
			var galleryTreeNode : TreeNode;
			var contentTreeNode : TreeNode;
			for(var i : int = 0; i < value.length; i++)
			{
				var tagvo : TagVO = value[i];
				if(tagvo.tagid == prevChapterId)
				{
					if(tagvo.subchapterid == prevSubChapterId)
					{
						if(tagvo.galleryid == prevGalleryId)
						{
							contentVO = getContent(tagvo);
							contentTreeNode = new TreeNode(contentVO, galleryTreeNode);
						}else
						{
							galleryVO = getGallery(tagvo);
							galleryTreeNode = new TreeNode(galleryVO, subChapterTreeNode);
							contentVO = getContent(tagvo);
							contentTreeNode = new TreeNode(contentVO, galleryTreeNode);
							prevGalleryId = galleryVO.id;
						}
						
					}else
					{
						subChapterVO = getSubChapter(tagvo);
						subChapterTreeNode = new TreeNode(subChapterVO, chapterTreeNode);
						galleryVO = getGallery(tagvo);
						galleryTreeNode = new TreeNode(galleryVO, subChapterTreeNode);
						contentVO = getContent(tagvo);
						contentTreeNode = new TreeNode(contentVO, galleryTreeNode);
						prevSubChapterId = subChapterVO.id;
						prevGalleryId = galleryVO.id;
					}
					
					
				}else
				{
					chapterVO = getChapter(tagvo);
					chapterTreeNode = new TreeNode(chapterVO, _root);
					subChapterVO = getSubChapter(tagvo);
					subChapterTreeNode = new TreeNode(subChapterVO, chapterTreeNode);
					galleryVO = getGallery(tagvo);
					galleryTreeNode = new TreeNode(galleryVO, subChapterTreeNode);
					contentVO = getContent(tagvo);
					contentTreeNode = new TreeNode(contentVO, galleryTreeNode);
					prevChapterId = chapterVO.id;
					prevGalleryId = galleryVO.id;
					prevSubChapterId = subChapterVO.id;
				}
			}
			
			_iterator = new TreeIterator(_root);
			
		}
		
		private function getChapter(tagvo : TagVO) : ChapterVO
		{
			var chapterVO : ChapterVO = new ChapterVO();
			chapterVO.id = tagvo.tagid;
			chapterVO.access = tagvo.chapteraccess;
			chapterVO.icon = "user_content/photos/flex_icon/"+tagvo.chapterimage;
			chapterVO.name = tagvo.chaptername;
			return chapterVO;
		}
		
		private function getSubChapter(tagvo : TagVO) : SubChapterVO
		{
			var subChapterVO : SubChapterVO = new SubChapterVO();
			subChapterVO.access = tagvo.subchapteraccess;
			subChapterVO.id = tagvo.subchapterid;
			subChapterVO.icon = tagvo.subchapterimage;
			subChapterVO.name = tagvo.subchaptername;
			return subChapterVO;
		}
		
		private function getGallery(tagvo : TagVO) : GalleryVO
		{
			var galleryVO : GalleryVO = new GalleryVO();
			galleryVO.id = tagvo.galleryid;
			galleryVO.name = tagvo.galleryname;
			galleryVO.access = tagvo.galleryaccess;
			galleryVO.icon = tagvo.galleryimage;
			return galleryVO;
		}
		
		private function getContent(tagvo : TagVO) : WebFileVO
		{
			var webfile : WebFileVO = new WebFileVO();
			webfile.id = tagvo.contentid
			webfile.icon = tagvo.contentfilename;
			webfile.type = tagvo.contentfiletype;
			return webfile;
		}
		
		public function test() : void
		{
			TreeIterator.preorder(_root, printNode);
		}
		
		private function printNode(node : TreeNode) : void
		{
			if(node.data != "root")
			{
				
				var d : BaseVO = node.data as BaseVO;
				trace("Class: "+d.classType+" Id:"+d.id);
			}
		}
		
		public function getChildren(value : Object) : Array
		{
			// case when its root
			if(value == null)
			{
				_iterator.start();		
			}else
			{
				for(_iterator.childStart(); _iterator.hasNext(); _iterator.nextChild())
				{
					if(_iterator.childData == value)
						break;
				}
				_iterator.down();			
			}
			var arr : Array = [];
			for(_iterator.childStart(); _iterator.childValid(); _iterator.nextChild())
			{
				arr.push(_iterator.childNode.data);
			}
			return arr;
		}

	}
}