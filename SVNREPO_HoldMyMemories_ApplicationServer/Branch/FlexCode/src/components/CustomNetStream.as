package components {
    import flash.net.NetConnection;
    import flash.net.NetStream;
 
    public class CustomNetStream extends NetStream {
        public function CustomNetStream(nc:NetConnection) {
            super(nc);
        }
 
        public function onMetaData(infoObject:Object):void {
            trace("metadata");
        }
 
        public function onCuePoint(infoObject:Object):void {
            trace("cue point");
        }
    }
}
      