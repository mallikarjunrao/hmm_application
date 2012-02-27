package model
{
	import com.adobe.serialization.json.JSON;
	
	import flash.utils.Dictionary;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.xml.SimpleXMLEncoder;
	
	import vo.ChapterVO;
	import vo.GalleryVO;
	import vo.SubChapterVO;
	import vo.WebFileVO;
	
	public class HmmChaptersModel extends WebFileSystemModel
	{
		private var fileMap : Dictionary;
		private static var instance : HmmChaptersModel;
		public static function getInstance() : HmmChaptersModel { return instance;}
		public static function setInstance(value : HmmChaptersModel): void{ instance = value;} 
		public var userId : String;
		public function HmmChaptersModel()
		{
			//TODO: implement function
			fileMap = new Dictionary();
			super();
		}
		
		override public function set data(root:Object):void 
		{
 			if(root.chapters)
			{
				userId = root.chapters.userid;	
				this.folders = getChapters(root.chapters.chapter);
				
			}
				
		}
		
		protected function getChapters( chapters : Object) : Array
		{
			var retChapters : Array = new Array();
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
					chapter.defaultTag = chapters[i].defaulttag;
					var subchapters :ArrayCollection;
					
					if(chapters[i].subchapters)
					{
						chapter.subchapters = getSubChapters(chapters[i].subchapters);
						
					}
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
					chapter.defaultTag = chapters.defaulttag;
					if(chapters.subchapters)
					{
						chapter.subchapters = getSubChapters(chapters.subchapters);
						 
					}
					retChapters.push(chapter);
			
			}
			return retChapters;
		}
		
		protected function getSubChapters(subChapters:Object) : Array
		{
			var retSubChapters : Array = new Array();
			if(subChapters.subchapter is ArrayCollection)
			{
				for(var i : int = 0; i < subChapters.subchapter.length; i++)
				{
					var chapter : SubChapterVO = new SubChapterVO();
					chapter.name = subChapters.subchapter[i].name;
					chapter.icon = subChapters.subchapter[i].icon;
					chapter.id = subChapters.subchapter[i].id;
					var subchapters :Array;
					if(subChapters.subchapter[i].tagid)
					{
						chapter.tagid = subChapters.subchapter[i].tagid;
					}
					chapter.access = subChapters.subchapter[i].access;
					chapter.tags = subChapters.subchapter[i].tags;
					chapter.description = subChapters.subchapter[i].description;
					if(subChapters.subchapter[i].galleries)
					{
						chapter.gallery = getGalleries(subChapters.subchapter[i].galleries.gallery);	
					}
					
					retSubChapters.push(chapter);
										
				}
				
				
			}else
			{
					chapter = new SubChapterVO();
					chapter.name = subChapters.subchapter.name;
					chapter.icon = subChapters.subchapter.icon;
					chapter.id = subChapters.subchapter.id;
					chapter.access = subChapters.subchapter.access;
					chapter.tags = subChapters.subchapter.tags;
					if(subChapters.subchapter.tagid)
					{
						chapter.tagid = subChapters.subchapter.tagid;
					}
					chapter.description = subChapters.subchapter.description;
					if(subChapters.subchapter.galleries)
					{
						chapter.gallery = getGalleries(subChapters.subchapter.galleries.gallery);	
					}
					retSubChapters.push(chapter);
			
			}
			return retSubChapters;
		}
		
		/* private function getAlbums(albums : Object) : Array
		{
			 var retAlbums : Array = new Array();
			if(albums is ArrayCollection)
			{
				
				for(var a : int = 0; a < albums.length; a++)
				{
					var album : AlbumVO = new AlbumVO();
					album.icon = albums[a].icon;
					album.name = albums[a].name;
					album.id = albums[a].id;
					if(albums[a].files)
					{
						album.files = getFiles(albums[a].files.file);	
					}
					album.writable = true;
					retAlbums.push(album);
				}
				
			}else
			{
				album  = new AlbumVO(); 
				album.icon = albums.icon;
				album.name = albums.name;
				album.id = albums.id;
				if(albums.files)
				{
					album.files = getFiles(albums.files.file);	
				}
				album.writable = true;
				retAlbums.push(album); 	
			}
			
			return retAlbums; 
			
		} */
		
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
		
		public function restoreDeletedItem(item : Object) : void
		{
			if(item is WebFileVO)
			{
				var gallery : GalleryVO = searchForGallery(item.galleryid);
				if(gallery)
					gallery.files.push(item);
			}else if(item is GalleryVO)
			{
				var subChapter : SubChapterVO = searchForSubChapter(item.subChapterId);
				if(subChapter) 
					subChapter.gallery.push(item);
			}else if(item is SubChapterVO)
			{
				var chapter : ChapterVO = searchForChapter(item.tagid);
				if(chapter)
					chapter.subchapters.push(item);
			}else if(item is ChapterVO)
			{
				folders.push(item);
			}
		}
		
		private function searchForGallery(id : int) : GalleryVO
		{
			for(var i : int = 0; i < folders.length; i++)
			{
				var chapter : ChapterVO = folders[i] as ChapterVO;
				var subchapters : Array = chapter.subchapters;
				for(var j : int =0; j < subchapters.length; j++)
				{
					var subChapter : SubChapterVO = subchapters[j] as SubChapterVO;
					var galleries : Array = subChapter.gallery;
					for(var k : int = 0; k < galleries.length; k++)
					{
						var gallery : GalleryVO = galleries[k] as GalleryVO;
						if(gallery.id == id)
						{
							return gallery;
						}
					}
				}
			}
			return null;
		}
		
		private function searchForSubChapter(id : int) : SubChapterVO
		{
			for(var i : int = 0; i < folders.length; i++)
			{
				var chapter : ChapterVO = folders[i] as ChapterVO;
				var subchapters : Array = chapter.subchapters;
				for(var j : int =0; j < subchapters.length; j++)
				{
					var subChapter : SubChapterVO = subchapters[j] as SubChapterVO;
					if(subChapter.id == id)
						return subChapter;
				}
			}
			return null;
		}
		
		private function searchForChapter(id : int) : ChapterVO
		{
			for(var i : int = 0; i < folders.length; i++)
			{
				var chapter : ChapterVO = folders[i] as ChapterVO;
				if(chapter.id == id)
					return chapter;
			}
			return null;
		}
		
		public function commitModelToServer() : void
		{
			var service : HTTPService = new HTTPService();
			service.url = "/customers/something";
			service.addEventListener(ResultEvent.RESULT, handleModelCommitResult);
			service.addEventListener(FaultEvent.FAULT, handleModelCommitFault);
			service.method = "Post";
			var objVal : String = JSON.encode(folders);
			var obj : Object = new Object();
			trace(objVal);
			obj.data = objVal;
			//service.contentType = HTTPService.RESULT_FORMAT_ARRAY;
			//service.contentType = HTTPService.CONTENT_TYPE_XML;
			//var x : XML = objectToXML(folders);
			//obj.xml = x.toString();
			service.send(obj);
		}
		
		protected function handleModelCommitFault(event : FaultEvent) : void
		{
			event.toString();
		}
		
		protected function handleModelCommitResult(event : ResultEvent) :void
		{
			event.toString();
		}
		
		
		
		
		
		public function getFileReference(id : String) : WebFileVO
		{
			return fileMap[id];
		}
		
		private function objToXml(obj : Object) : void
		{
			
		}
		
		public function getAllFiles() : ArrayCollection
		{
			var files : Array = new Array();
			for(var i : int = 0; i < folders.length; i++)
			{
				var subchapters : Array = (folders[i] as ChapterVO).subchapters as Array;
				for(var j : int = 0; j < subchapters.length; j++)
				{
					var galleries : Array = (subchapters[j] as SubChapterVO).gallery;
					for(var k : int = 0; k < galleries.length; k++)
					{
						if(galleries[k].type == "image")
						{
							files = files.concat((galleries[k] as GalleryVO).files);
						}
					}
					
				}
			}
			return new ArrayCollection(files);
		}
		
			
		
		
		private function objectToXML(obj:Object):XML {
                var qName:QName = new QName("chapters");
                var xmlDocument:XMLDocument = new XMLDocument();
                var simpleXMLEncoder:SimpleXMLEncoder = new SimpleXMLEncoder(xmlDocument);
                var xmlNode:XMLNode = simpleXMLEncoder.encodeValue(obj, qName, xmlDocument);
                 //trace(xmlDocument.toString());
                var xml:XML = new XML(xmlDocument.toString());
                 trace(xml.toXMLString());
                 
                return xml;
            }
		
		
	}
}