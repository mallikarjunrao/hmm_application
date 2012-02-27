package
{
	
	import com.CoverFlowEvent;
	import com.dougmccune.containers.CoverFlowContainer;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
  
  public class RegularCoverFlow extends CoverFlowContainer
  {
    private var _dataProvider:ArrayCollection;
    
    public function RegularCoverFlow()
    {
      this.setStyle("horizontalGap", 40);
      this.reflectionEnabled = true;
      this.addEventListener(CoverFlowEvent.CHILD_SELECTION_CHANGE, handleSelectionChanged);
    }
    
    private function handleSelectionChanged(event : CoverFlowEvent) : void
    {
    	trace("event working "+event.extra);
    	var prevVideoComp : MyVideo = this.getChildAt(int(event.extra)) as MyVideo;
    	if(prevVideoComp && prevVideoComp.isPlaying)
    	{
    		prevVideoComp.stop();	
    	}
    }
    
    public function set dataProvider(_dataProvider:ArrayCollection):void
    {
      this._dataProvider = _dataProvider;
      this._dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, updateItems);
      updateItems();
    }
    
    public function get dataProvider():ArrayCollection
    {
      return _dataProvider;
    }
    
    // this could be more efficient
    private function updateItems(event:CollectionEvent=null):void
    {
      this.removeAllChildren();
      
      for each (var i:Object in dataProvider)
      {
      	
      	var img : ImgRenderer = new ImgRenderer(i.icon);
      	this.addChild(img);
      }
    }
  }
}