package components {
    
     import flash.display.Graphics;
     import flash.events.Event;
     import flash.geom.Point;
     import flash.geom.Rectangle;
     import flash.media.SoundMixer;
     import flash.utils.ByteArray;
     
     import mx.core.UIComponent;
     import mx.effects.Dissolve;
     import mx.events.EffectEvent;
     
    
    [Style(name="audioLineColor",type="Number",format="Color",inherit="no")]
    [Style(name="audioFillColor",type="Number",format="Color",inherit="no")]
     public class Visualization extends UIComponent {
         
         public var type:String = "line"; // line, wave, bars
          public var channel:String="mono"; // mono, left, right, stereo
          public var bars:uint = 256;
          
          
          //private var min:uint = 0;
          //private var max:uint = 255;
          private var gain:uint = 1;
          
          
         private var display:UIComponent = new UIComponent();
          private var spectrumData:ByteArray = new ByteArray();
          private var rc:Number = 0; // relativeCenter
          private var rp:Number = 0; // relativePixel
          public var peak:Number = 0;
          private var layers : Array;
          private var effects : Array;
          private var fade : Dissolve;
          public function Visualization() {
               addEventListener(Event.ENTER_FRAME, enterFrameListener);
           		layer = new Array();
           		for(var i : int = 0; i < 5; i++)
           		{
           			fade = new Dissolve();
	           		fade.alphaFrom = 1;
	           		fade.alphaTo = 0;
	           		fade.duration = 1500;
	           		fade.addEventListener(EffectEvent.EFFECT_END, handleEffectEnd);	
           		}
           		
           }
           
           private function handleEffectEnd(event : EffectEvent) : void
           {
           		var fd : Dissolve = event.target as Dissolve;
           		layers.push(fd.target);
           }
        
        
           override protected function createChildren():void {
              for(var i : int = 0; i < 5; i++)
              {
              	var comp : UIComponent = new UIComponent();
              	comp.width = this.measuredWidth;
              	comp.height = this.measuredHeight;
              	this.addChild(comp);
              	layers.push(comp);
              }
               
           }
           
           override protected function updateDisplayList(w:Number, h:Number):void {
               super.updateDisplayList(w, h);
               
              
           }
           
          private function enterFrameListener(e:Event):void {
              var rect:Rectangle = bitmapData.rect
               SoundMixer.computeSpectrum(spectrumData, true, 0);
            
        }
        
        private function drawSpectrum(comp : UIComponent) : void
        {
        	var g : Graphics = comp.g;
        	g.lineStyle(1, 0xffffff)
        	g.clear();
        	var center : Point = new Point();
        	center.x = comp.width/2;
        	center.y = comp.height/2;
        	var angle : Number = Math.PI/spectrumData.length;
        	g.drawCircle(center.x, center.y, radius);
        	var arc : Number = Math.sin(angle)*radius;
        	for(var i : int =0; i < spectrumData.length; i++)
        	{
        		
        	}
        }
        
        private function toMono():void {
            spectrumData.position = 0;
            if(spectrumData.length==2048) {
                var leftData:ByteArray = new ByteArray();
                   var rightData:ByteArray = new ByteArray();
                   spectrumData.readBytes(leftData, 0, 1024);
                   spectrumData.readBytes(rightData, 0, 1024);
                   spectrumData = new ByteArray();
                   for (var i:uint = 0; i < 256 ; i++) {
                       spectrumData.writeFloat((leftData.readFloat()+rightData.readFloat())/2);
                   }
                   spectrumData.position = 0;
               }
        }
        
       
        
        
        
      }
}