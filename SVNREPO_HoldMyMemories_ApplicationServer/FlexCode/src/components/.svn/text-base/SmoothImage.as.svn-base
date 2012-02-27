package components 
{
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.events.Event;
    
    import mx.controls.Image;
    import mx.core.IFlexDisplayObject;
    import mx.core.mx_internal;
    import mx.managers.PopUpManager;
    
    use namespace mx_internal;
    
    /**
     * SmoothImage
     *
     * Automatically turns smoothing on after image has loaded
     *
     * @author Ben Longoria
     */
     
    public class SmoothImage extends Image {
        
        [Embed(source="assets/busy.swf")]
        private var loader : Class; 
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
        }
    }
}