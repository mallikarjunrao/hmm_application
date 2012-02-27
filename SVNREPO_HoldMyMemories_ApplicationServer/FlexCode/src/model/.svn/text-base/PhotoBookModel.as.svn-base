package model
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	import vo.ImageVo;
	
	public class PhotoBookModel
	{
		private static var instance : PhotoBookModel;
		public var photoBookImages : ArrayCollection;
		public var isEditable : Boolean = false;
		
		public function PhotoBookModel()
		{
			photoBookImages = new ArrayCollection();
		}
		
		public static function getInstance() : PhotoBookModel
		{
			if(instance == null)
			{
				instance = new PhotoBookModel();
				return instance;
			}
			else
			 return instance;
		}
		
		public function updatePosition(name : String, position : Point, transformPostion : Point) : void
		{
			var indexArray : Array = name.split("$");
			var images : ArrayCollection = (photoBookImages[indexArray[0]]as PageModel).images;
			for(var i : int = 0; i < images.length; i++)
			{
				if((images[i]as ImageVo).name == name)
				{
					((photoBookImages[indexArray[0]] as PageModel).images[i] as ImageVo).position = position;
					((photoBookImages[indexArray[0]] as PageModel).images[i] as ImageVo).transformPosition = transformPostion;
					break;		
				}
			}
			//(photoBookImages[parentIndex].images[index] as ImageVo).position = position;
			//PageModel.getInstance().updatePosition(fiel,parentIndex,position);
		}
		
		public function updateSize(name : String, width : Number, height : Number) : void
		{
			var indexArray : Array = name.split("$");
			var images : ArrayCollection = (photoBookImages[indexArray[0]]as PageModel).images;
			for(var i : int = 0; i < images.length; i++)
			{
				if((images[i]as ImageVo).name == name)
				{
					((photoBookImages[indexArray[0]] as PageModel).images[i] as ImageVo).width = width;
					((photoBookImages[indexArray[0]] as PageModel).images[i] as ImageVo).height = height;
					break;		
				}
			}
		}
		
		public function updateMatrix(name : String, matrix : Matrix) : void
		{
			var indexArray : Array = name.split("$");
			var images : ArrayCollection = (photoBookImages[indexArray[0]]as PageModel).images;
			for(var i : int = 0; i < images.length; i++)
			{
				if((images[i]as ImageVo).name == name)
				{
					((photoBookImages[indexArray[0]] as PageModel).images[i] as ImageVo).matrix = matrix;
					break;		
				}
			}	
		}
		
		public function updateRotation(name : String, angle : Number) : void
		{
			var indexArray : Array = name.split("$");
			var images : ArrayCollection = (photoBookImages[indexArray[0]]as PageModel).images;
			for(var i : int = 0; i < images.length; i++)
			{
				if((images[i]as ImageVo).name == name)
				{
					((photoBookImages[indexArray[0]] as PageModel).images[i] as ImageVo).rotation = angle;
					break;		
				}
			}
			
			//PageModel.getInstance().updateRotation(file,parentIndex,angle);
		}
		
		public function getRotation(index : int, parentIndex : int) : Number
		{
			var rotation : Number = (photoBookImages[parentIndex].images[index] as ImageVo).rotation;
			return rotation;
		}
		
		public function deleteItem(parentIndex : int, name : String) : void
		{
			var images : ArrayCollection = (photoBookImages[parentIndex] as PageModel).images;
			for(var i = 0; i < images.length; i++)
			{
				if((images[i] as ImageVo).name == name)
				{
				  (photoBookImages[parentIndex] as PageModel).images.removeItemAt(i);
				  break;
				}
			} 
			
		}
		
		public function addItem(position : int, image : ImageVo) : void
		{
			(photoBookImages[position] as PageModel).images.addItem(image);
		}
		
		public function set model(obj : Object) : void
		{
			var list : ArrayCollection;
			if(obj.img is ArrayCollection)
	              list = obj.img as ArrayCollection;
	        else
	        {
	        	list = new ArrayCollection();
	        	list.addItem(obj.img);
	        }
	        var i : int = 0;
	        for(var i : int = 0; i < list.length; i++)
	        {
	        	var pageModel : PageModel = new PageModel();
	        	var images : ArrayCollection;
	        	var imageVo : ImageVo = new ImageVo();
	        	imageVo.background = true;
	        	imageVo.file = list[i].backgroundImage.file;
	        	imageVo.rotation  = 0;
	        	imageVo.index = 0;
	        	imageVo.parentIndex = i;
	        	imageVo.position = new Point(0,0);
	        	//PageModel.getInstance().images.addItem(imageVo);
	        	pageModel.backgroundImage = imageVo;
	        	var photoBookPage : ImageVo = new ImageVo();
	        	photoBookPage.background = false;
	        	photoBookPage.file = list[i].photobook.file;
	        	photoBookPage.rotation  = 0;
	        	photoBookPage.index = 0;
	        	photoBookPage.parentIndex = i;
	        	photoBookPage.position = new Point(0,0);
	        	pageModel.photoBookPage = photoBookPage;
	        	//pageModel.images.addItem(imageVo);
	        	if(list[i].childImage is ArrayCollection)
                   images = list[i].childImage as ArrayCollection;
                else
                {
                	images = new ArrayCollection();
                	images.addItem(list[i].childImage);
                }
                for(var j : int = 0; j < images.length; j++)
                {
                	var imageVo : ImageVo = new ImageVo();
                	imageVo.file = images[j].file;
                	imageVo.index = j+1;
                	imageVo.parentIndex = i;
                	imageVo.position = new Point(images[j].x, images[j].y);
                	imageVo.rotation = images[j].rotation;
                	imageVo.height = images[j].height;
                	imageVo.width = images[j].width;
                	imageVo.path  = images[j].path;
                	imageVo.matrix.a = images[j].a;
                	imageVo.matrix.b = images[j].b;
                	imageVo.matrix.c = images[j].c;
                	imageVo.matrix.d = images[j].d;
                	imageVo.matrix.tx = images[j].tx;
                	imageVo.matrix.ty = images[j].ty;
                	imageVo.transformPosition = new Point(images[j].transformX,images[j].transformY);
                	//PageModel.getInstance().images.addItem(imageVo);
                	pageModel.images.addItem(imageVo);
                }   
                photoBookImages.addItem(pageModel);
               // i++;  	        	
	        }
	        		
		}
		
		public function get modelXml() : XML
		{
			var images:XML = <images></images>;
            var title : XML = <title/>;
            title.@file = "/titleImages/myfamilyalbum.png";
            images.appendChild(title);
            for(var i : int = 0; i < photoBookImages.length; i++)
			{
					
				var page : PageModel = photoBookImages[i] as PageModel;
                var img : XML = <img></img>;
				var backgroundPageImage : ImageVo = page.backgroundImage;
				var backgroundImage : XML = <backgroundImage/>;
				backgroundImage.@file = backgroundPageImage.file;
				img.appendChild(backgroundImage);
				var photoBookPage : XML = <photobook/>
				photoBookPage.@file = page.photoBookPage.file;
				img.appendChild(photoBookPage);
				for(var j : int = 0; j < page.images.length; j++)
				{
					var pageChildImage : ImageVo = page.images[j] as ImageVo;
					var childImage :  XML = <childImage/>;
					childImage.@file = pageChildImage.file;
					childImage.@x = pageChildImage.position.x;
					childImage.@y = pageChildImage.position.y;
					childImage.@background = pageChildImage.background;
					childImage.@id = pageChildImage.id;
					childImage.@height = pageChildImage.height;
					childImage.@width = pageChildImage.width;
					childImage.@rotation = pageChildImage.rotation;
					childImage.@path = pageChildImage.path;
					childImage.@transformX = pageChildImage.transformPosition.x;
					childImage.@transformY = pageChildImage.transformPosition.y;
					/* childImage.@a = pageChildImage.a;
					childImage.@b = pageChildImage.b;
					childImage.@c = pageChildImage.c;
					childImage.@d = pageChildImage.d;
					childImage.@tx = pageChildImage.tx;
					childImage.@ty = pageChildImage.ty; */
					childImage.@a = pageChildImage.matrix.a;
					childImage.@b = pageChildImage.matrix.b;
					childImage.@c = pageChildImage.matrix.c;
					childImage.@d = pageChildImage.matrix.d;
					childImage.@tx = pageChildImage.matrix.tx;
					childImage.@ty = pageChildImage.matrix.ty;
					img.appendChild(childImage);
				}
				images.appendChild(img);	
		 	}
		 	
		 	return images;
		}
	}
}