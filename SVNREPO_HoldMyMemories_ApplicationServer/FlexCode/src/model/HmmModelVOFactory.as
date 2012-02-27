package model
{
	import vo.AlbumVO;
	import vo.BaseVO;
	import vo.GalleryVO;
	
	public class HmmModelVOFactory
	{
		public function HmmModelVOFactory()
		{
			
			private var instance : HmmModelVOFactory = new HmmModelVOFactory();
			
			public static function getInstance() : HmmModelVOFactory;
			{
				if(instance)
					return instance;
				else
					instance = new HmmModelVOFactory();
			}
			
			public function createVO(classType : String) : BaseVO
			{
				switch(classType)
				{
					case HmmVOTypes.ALBUM_VO:
								return new AlbumVO();
					case HmmVOTypes.BASE_VO:
								return new BaseVO();
					case HmmVOTypes.GALLERY_VO:
								return new GalleryVO();
					case HmmVOTypes.SUBCHAPTER_VO:
								return new 
				}
			}
		}

	}
}