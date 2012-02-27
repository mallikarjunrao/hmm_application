package model
{
	import mx.collections.ArrayCollection;
	
	public  class SlideShowCreatorModel
	{
		private static var instance : SlideShowCreatorModel;
		public var selectedImages : ArrayCollection;
		public function SlideShowCreatorModel()
		{
			super();
			selectedImages = new ArrayCollection();
		}
		
		public static function  getInstance() : SlideShowCreatorModel
		{
			if(instance == null)
			 instance = new SlideShowCreatorModel();
			
		    return instance;	 
		}
		
		public function set setSelectedImages(images : ArrayCollection) : void
		{
			selectedImages = images;
		}
		
		public function get getSelectedImages() : ArrayCollection
		{
			return selectedImages;
		}
		
		/* public function set setHmmModel(hmmmodel : ArrayCollection) : void
		{
			
		}
		
		public function get getHmmModel() : ArrayCollection
		{
			
		}
 */
	}
}