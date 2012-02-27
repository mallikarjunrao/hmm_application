package model
{
	import mx.collections.ArrayCollection;
	
	import vo.ImageVo;
	
	public class PageModel
	{
		public var images : ArrayCollection;
		private static var instance : PageModel;
		public var backgroundImage : ImageVo;
		public var photoBookPage : ImageVo;
		
		public function PageModel()
		{
			images = new ArrayCollection();
            backgroundImage = new ImageVo();   		
		}
		
		public static function getInstance() : PageModel
		{
			if(instance = null)
			{
				instance = new PageModel();
				return instance;
			}
			else
				return instance;
			
		}
		
	}
}