package  PhotoBookComponents
{
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.events.Event;
    
    import mx.core.IFlexDisplayObject;
    import mx.core.mx_internal;
    
    use namespace mx_internal;
    
    /**
     * SmoothImage
     *
     * Automatically turns smoothing on after image has loaded
     *
     * @author Ben Longoria
     */
     
    public class SmoothImage extends CustomImage {
        
        private var progressIndicator : IFlexDisplayObject;
        public function SmoothImage():void {
            super();
            //progressIndicator = PopUpManager.createPopUp(this,loader);
            //PopUpManager.centerPopUp(progressIndicator);
        } 
        
        
        
        /**
         * @private
         */
        override mx_internal function contentLoaderInfo_completeEventHandler(event:Event):void {
            var smoothLoader:Loader = event.target.loader as Loader;
            var smoothImage:Bitmap = smoothLoader.content as Bitmap;
            smoothImage.smoothing = true;
            //PopUpManager.removePopUp(progressIndicator);
            super.contentLoaderInfo_completeEventHandler(event);
            this.invalidateDisplayList();
        } 
        
        override protected function updateDisplayList (unscaledWidth : Number, unscaledHeight : Number) : void
        {
            super.updateDisplayList (unscaledWidth, unscaledHeight);

            // checks if the image is a bitmap
            if (content is Bitmap)
            {
                var bitmap : Bitmap = content as Bitmap;

                if (bitmap != null && bitmap.smoothing == false)
                {
                    bitmap.smoothing = true;
                }
            }
        }
        
        public function resizeIt(maxH:Number,maxW:Number) {
			if(super.conten is Bitmap)
			{  
				var bitmapContent : Bitmap = super.conten as Bitmap;
				var r:Number;//ratio
				r = bitmapContent.height/bitmapContent.width;//b.height/b.width;//calculation ratio to which resize takes place
	
				if (bitmapContent.width>maxW) {
					bitmapContent.width = maxW;
					bitmapContent.height = Math.round(bitmapContent.width*r);
	
				}
				if (bitmapContent.height>maxH) {
					bitmapContent.height = maxH;
					bitmapContent.width = Math.round(bitmapContent.height/r);
	
				}
			}
		}
        
        
    }
}