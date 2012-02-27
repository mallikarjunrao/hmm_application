package vo
{
	public class AudioGalleryVO extends GalleryVO
	{
		public function AudioGalleryVO()
		{
			//TODO: implement function
			super();
			classType = "galleryVO";
			icon = "/user_content/photos/icon_thumbnails/audio.png";
			name = "Audio Gallery";
			type = GalleryTypes.AUDIO;
		}
		
	}
}