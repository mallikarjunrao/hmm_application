package
{
  import com.CoverFlowEvent;
  import com.TimeFlyByContainer;
  
  import flash.display.GradientType;
  import flash.display.Graphics;
  import flash.display.InterpolationMethod;
  import flash.display.SpreadMethod;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.geom.Matrix;
  import flash.utils.Timer;
  
  import mx.collections.ArrayCollection;
  import mx.events.CollectionEvent;
  
  public class TimeFlyByCoverflow extends TimeFlyByContainer
  {
    private var _dataProvider:ArrayCollection;
    private var _timer : Timer;
    private var _isPlaying : Boolean;
    public function TimeFlyByCoverflow()
    {
    	super();
      this.setStyle("horizontalGap", 40);
      this.reflectionEnabled = true;
      _timer = new Timer(1500);
      this.addEventListener(CoverFlowEvent.CHILD_SELECTION_CHANGE, handleSelectionChanged);
      _timer.addEventListener(TimerEvent.TIMER, handleTimerEvent);
      _isPlaying = false;
    }
    
    private function handleTimerEvent(event : TimerEvent) : void
    {
    		var children : Array = getChildren();
    		var plane : MyRenderer = children[selectedIndex] as MyRenderer;
    		plane.stop();
    		var evt : CoverFlowEvent = new CoverFlowEvent(CoverFlowEvent.CHILD_SELECTION_CHANGE);
    		if(selectedIndex == (children.length -1))
    		{
    			selectedIndex = 0;
    			_timer.stop();
    			_isPlaying = false;
    		} else
    		{
    			selectedIndex = selectedIndex+1;	
    		}
    		
			evt.extra = selectedIndex;
			this.dispatchEvent(evt);
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		var type:String = GradientType.RADIAL;
		var colors:Array = [0xFFFFFF, 0x000000];
		var alphas:Array = [1, 0];
		var ratios:Array = [0, 255];
		var spreadMethod:String = SpreadMethod.PAD;
		var interp:String = InterpolationMethod.LINEAR_RGB;
		var focalPtRatio:Number = 0;
		
		var matrix:Matrix = new Matrix();
		var boxWidth:Number = 150;
		var boxHeight:Number = 150;
		var boxRotation:Number = Math.PI/2;
		var g : Graphics = graphics;
		g.clear();
		var tx : Number = unscaledWidth*2/3-150/2;
		var ty : Number = unscaledHeight*1/3-150/2;
		
		matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);
		g.beginGradientFill(type, 
		                            colors,
		                            alphas,
		                            ratios, 
		                            matrix, 
		                            spreadMethod, 
		                            interp, 
		                            focalPtRatio);
		g.drawRect(tx, ty, 150, 75);
		g.endFill();
		g.beginGradientFill(GradientType.LINEAR, 
		                            colors,
		                            alphas,
		                            ratios, 
		                            matrix, 
		                            spreadMethod 
		                            );
		g.drawRect(0, ty+75, unscaledWidth, unscaledHeight-ty);
		g.endFill();
	}
    
    private function handleSelectionChanged(event : CoverFlowEvent) : void
    {
    	trace("event working "+event.extra);
    	var prevVideoComp : MyRenderer = this.getChildAt(int(event.extra)) as MyRenderer;
    	if(prevVideoComp && prevVideoComp.isPlaying)
    	{
    		prevVideoComp.stop();	
    	}
    }
    
    override protected function containerRollOver(event : MouseEvent) : void
    {
    	if(_isPlaying)
    		_timer.stop();
    }
    
    override protected function containerRollOut(event : MouseEvent) : void
    {
    	if(_isPlaying)
    	_timer.start();	
    }
    
    public function set dataProvider(_dataProvider:ArrayCollection):void
    {
    	var children : Array = this.getChildren();
    	
		var plane : MyRenderer = children[selectedIndex] as MyRenderer;
		if(plane)
		plane.stop();
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
      	var child : MyRenderer = new MyRenderer(i.icon, i.type);
      	child.addEventListener(MouseEvent.MOUSE_OVER,  containerRollOver);
      	child.addEventListener(MouseEvent.MOUSE_OUT,  containerRollOut);
        this.addChild(child);
      }
    }
    
    public function play() : void
    {
    	_isPlaying = true;
    	
    	_timer.start();	
    }
  }
}