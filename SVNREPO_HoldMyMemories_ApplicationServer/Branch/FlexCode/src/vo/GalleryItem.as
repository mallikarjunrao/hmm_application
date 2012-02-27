package vo
{
	public class GalleryItem
	{
		[Bindable]
		public var icon : String;
		[Bindable]
		public var label : String;
		public var type : String;
		public static const VIDEO : String = "video";
		public static const PICTURE : String = "picture";
		public static const AUDIO : String = "audio";
		public function GalleryItem()
		{
			super();
		}

	}
}