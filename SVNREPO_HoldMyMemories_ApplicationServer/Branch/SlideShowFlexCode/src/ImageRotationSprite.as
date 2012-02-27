package
{
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.Number3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.Plane;
	import org.papervision3d.scenes.MovieScene3D;
	
	public class ImageRotationSprite extends UIComponent
	{
			private var scene : MovieScene3D;
			private var plane : DisplayObject3D;
			private var paperSprite : Sprite;
			private var backGroundSprite : Sprite;
			private var camera : Camera3D;
			private var red : Number;
			private var blue : Number;
			private var green : Number;
			private var bitmapArray : Array;
			private var _imageToLoadIndex : int;
			private var _transition : Transitions;
			private var _frameNameToAdd : Function;
			private var _frameNameToRemove : Function;
			private var _direction : String;
			private var _loadCount : int = 0;
			private var _deepthMax : Number = 1000;
			private var _speed : Number = 40;
			private var _blurTime : int = 300;
			private var _sptopPosition : int = 40;
			
		public function ImageRotationSprite()
		{
			camera = new Camera3D();
			camera.zoom = 1;
			camera.rotationZ = 45;
			
			camera.extra =
			{
				goPosition: new DisplayObject3D(),
				goTarget:   new DisplayObject3D(),
				goRotation : new DisplayObject3D()
			};
		    var camGoto : DisplayObject3D = new DisplayObject3D();
		    camGoto.z = -100;
		    
		    camera.extra.goPosition.copyPosition( camGoto );
		    camGoto.rotationZ = Math.PI;
		    camera.extra.goRotation = camGoto;
			backGroundSprite = new Sprite();
			backGroundSprite.cacheAsBitmap = true;
			paperSprite = new Sprite();
			paperSprite.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage );
			paperSprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			scene = new MovieScene3D(paperSprite);
			addChild(paperSprite);
			_imageToLoadIndex = 0;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			addChild(backGroundSprite);
			addChild(paperSprite);
			
		}
		
		private function handleAddedToStage(event : Event) : void
		{
			paperSprite.stage.quality = StageQuality.BEST;
			
				
		}
		
		override protected function commitProperties():void
		{
			 bitmapArray = new Array();
			
			for(var i : int = 1; i < 13; i++)
			{
				var bmfm : BitmapFileMaterial;
				//if(i < 10)
					bmfm = new BitmapFileMaterial("bob/image"+i+".jpg");
					//bmfm.addEventListener(FileLoadEvent.LOAD_COMPLETE, handleLoadComplete);
					bmfm.doubleSided = false;
					bmfm.smooth = true;
				/* else
				 	bmfm = new BitmapFileMaterial("photos/photo"+i+".jpg"); */
				bitmapArray.push(bmfm);
			} 
			
			camera.z = -100;
			 scene = new MovieScene3D(paperSprite);
			plane = new Plane(bitmapArray[2]);
			plane.z = _deepthMax;
			plane.rotationZ = 0;
			_transition = new Transitions(new Number3D(0,0,0), new Number3D(0,0,4*360));
			scene.addChild(plane);
			
			//moveFromScreen();
			//this.scene.renderCamera(camera); 
			//moveFromScreen();
			//_frameNameToRemove = "onEnterFrame";
			//_frameNameToAdd = "frontTOBackEnterFrame";
			/* timer = new Timer(10000);
			timer.addEventListener(TimerEvent.TIMER,repeatEnterFrames);
			timer.start(); */
			/* var bmfm : BitmapFileMaterial = new BitmapFileMaterial("photos/photo01.jpg");
			
			bmfm.addEventListener(FileLoadEvent.LOAD_COMPLETE, handleLoadComplete);
			bmfm.doubleSided = false;
			bmfm.smooth = true;
			scene = new MovieScene3D(paperSprite);
			plane = new Plane(bmfm);
			
			plane.z = 0;
			plane.extra =
			{
				
				goRotation : new DisplayObject3D()			
			};
			var planeRot : DisplayObject3D = new DisplayObject3D();
			planeRot.rotationZ = 4*360;
			plane.extra.goRotation = planeRot;
			scene.addChild(plane);
			plane.container.filters = [new GlowFilter(0xffffff,0.8,12,12, 5,1), new DropShadowFilter(), new ColorMatrixFilter()]; */
		}
		
		private function handleTimerMove(event : TimerEvent) : void
		{
			if(plane )
			{
				if(plane.x < 0)
				{
					plane.x += 5;
					
					//camera.x += 1;  
				}
				else
				  camera.z += 1;
			}
			//else
			 
			this.scene.renderCamera(camera);
		}
		private function handleLoadComplete(event : FileLoadEvent) : void
		{
			if(_loadCount == 12)
			{
				paperSprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			else
			{
				_loadCount++;
			}
			/* var bmpdata : BitmapFileMaterial = BitmapFileMaterial(event.currentTarget);
			bmpdata.bitmap.colorTransform(new Rectangle(0,0,bmpdata.bitmap.width, bmpdata.bitmap.height),
										new ColorTransform(0.5,0.5,0.5,1, 128,128,128));							
 */
			/* bmpdata.bitmapData.colorTransform(new Rectangle(0,0,bmfm.bitmap.width, bmfm.bitmap.height),
										new ColorTransform(0.5,1,0.5)); */
		}
			
		private var angle : int = 10;
		private var timer : Timer;
		private function onEnterFrame(event : Event) : void
		{
			camera.x = 0;
			camera.y = 0;
			/* var goPosition : DisplayObject3D = camera.extra.goPosition;
			var goRotation : DisplayObject3D = camera.extra.goRotation;
			camera.x -= (camera.x - goPosition.x) /32;
			camera.y -= (camera.y - goPosition.y) /32;
			camera.z -= (camera.z - goPosition.z) /10; */ 
			
			red += (0.3086- 1)/1024; // luminance contrast value for red
			
			green += (0.694 - 1)/1024; // luminance contrast value for green
			blue += (0.0820 - 1)/1024; // luminance contrast value for blue
			var cmf:ColorMatrixFilter = new ColorMatrixFilter([red, green, blue, 0, 0, red, green, blue, 0, 0, red, green, blue, 0, 0, 0, 0, 0, 1, 0]);
			if(plane)
			{
				if(plane.rotationZ < 4*360)
				{
					plane.rotationZ += _speed;//(plane.rotationZ - _transition.rotation.z) /20;
					angle += 40;
				}
				plane.z -= _speed;
				if(plane.z < -_sptopPosition)
				{
					_transition.rotation.z = 4*360;
					timer = new Timer(5000);
					timer.addEventListener(TimerEvent.TIMER,timerPause);
					paperSprite.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
					//paperSprite.removeEventListener(Event.ENTER_FRAME,_frameNameToRemove);
					
					//paperSprite.addEventListener(Event.ENTER_FRAME,_frameNameToAdd);
					timer.start();
					
				}
				plane.container.filters[2] = cmf;
				
			}
			this.scene.renderCamera(camera);
		}
		
		private function timerPause(event : TimerEvent) : void
		{
			timer.stop();
			timer = new Timer(10000);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			paperSprite.addEventListener(Event.ENTER_FRAME,frontTOBackEnterFrame);
			timer.start();	
		}
		
		private function onTimer(event : TimerEvent) : void
		{
			paperSprite.removeEventListener(Event.ENTER_FRAME,frontTOBackEnterFrame);
			camera.z = -100;
			paperSprite.addEventListener(Event.ENTER_FRAME,backToFrontEnterFrame);
			timer.stop();
		}
		
		private var alphaDef : Number = 1;
		private function frontTOBackEnterFrame(event : Event) : void
		{
			plane.z += _speed;
			//plane.container.filters = [new ColorMatrixFilter([1,1,1,alphaDef])]
			//var blurgfil : Blur = new BlurFilter();
			plane.container.alpha = alphaDef;
			camera.rotationX = 45;
			camera.lookAt(plane);
			this.scene.renderCamera(camera);
			if(alphaDef <= 0)
			{
				angle = 20;
				var _Z : Number = plane.z;
				paperSprite.removeEventListener(Event.ENTER_FRAME,frontTOBackEnterFrame);
				scene.removeChild(plane);
				plane = new Plane(bitmapArray[_imageToLoadIndex++]);
				plane.x = 0;
				plane.y = unscaledHeight/2;
				plane.z = _Z;
				plane.rotationZ = 0;
				scene.addChild(plane);
				paperSprite.addEventListener(Event.ENTER_FRAME,backToFrontEnterFrame);
				
			}
			alphaDef -= .01;
		}
		
		private function backToFrontEnterFrame(event : Event) : void
		{
			/* camera.x = 0;
			camera.y = 0; */
			var goPosition : DisplayObject3D = camera.extra.goPosition;
			var goRotation : DisplayObject3D = camera.extra.goRotation;
			/* camera.x -= (camera.x - goPosition.x) /32;
			camera.y -= (camera.y - goPosition.y) /32;
			camera.z -= (camera.z - goPosition.z) /32; */
			if(plane)
			{
				
				//(plane.rotationZ - plane.extra.goRotation.rotationZ)/32;
				trace(plane.rotationZ);
				if(angle <= 360)
				{
					plane.rotationZ = angle;
				}
				
				if(plane.z <= -_sptopPosition)
				{   
					paperSprite.removeEventListener(Event.ENTER_FRAME,backToFrontEnterFrame);
					timer = new Timer(_blurTime);
					alphaDef = 1;
					timer.addEventListener(TimerEvent.TIMER, blurTimer);
					timer.start();
					_frameNameToAdd = addImageLeftToRight;
					_direction = "right";
					
				}
				else
				 plane.z -= _speed;
			}
			this.scene.renderCamera(camera);
			
			/* camera.lookAt(plane); */
			angle += 10;
			
		}
		
		private function blurTimer(event : TimerEvent) : void
		{
			alphaDef = 1;
			paperSprite.addEventListener(Event.ENTER_FRAME,applyBlurFilter);
			timer.stop();
			
		}
		private var blurX : int = 10;
		private var blurY : int = 10;
		private function applyBlurFilter(event : Event) : void
		{
			var blurfilter : BlurFilter = new BlurFilter(blurX,blurY);
			plane.container.alpha = alphaDef;
			if(alphaDef <= 0)
			{
				paperSprite.removeEventListener(Event.ENTER_FRAME,applyBlurFilter);
				//paperSprite.addEventListener(Event.ENTER_FRAME,_frameNameToAdd);
				_frameNameToAdd();
			}
			alphaDef -= .009;
		}
		
		private function addImageLeftToRight() : void
		{
			scene.removeChild(plane);
				plane = new Plane(bitmapArray[_imageToLoadIndex++]);
				plane.x = 0;
				plane.y = unscaledHeight/2;
				plane.z = 100;
				plane.rotationZ = 0;
				scene.addChild(plane);
				plane.x = - this.parent.width;
				plane.container.alpha = 0;
				alphaDef = 0;
				paperSprite.addEventListener(Event.ENTER_FRAME,leftToRightEnterFrame);
		}
		
		private function addImageRightToLeft() : void
		{
			scene.removeChild(plane);
			plane = new Plane(bitmapArray[_imageToLoadIndex++]);
			plane.x = 0;
			plane.y = unscaledHeight/2;
			plane.z = 100;
			plane.rotationZ = 0;
			scene.addChild(plane);
			plane.x = this.parent.width;
			alphaDef = 0;
			paperSprite.addEventListener(Event.ENTER_FRAME,rightToLeftEnterFrame);
		}
		private function leftToRightEnterFrame(event : Event) : void
		{
			this.scene.renderCamera(camera);
			if(plane.x < 0)
			{
			 plane.x += 10;
			}
			if(alphaDef <= 1)
			{
				plane.container.alpha = alphaDef;
				alphaDef += .01;
			}
			
			if(plane.x >= 0)
			{
				plane.z -= 5;
				if(plane.z <= -100)
				{
					paperSprite.removeEventListener(Event.ENTER_FRAME,leftToRightEnterFrame);
					timer = new Timer(_blurTime);
					timer.addEventListener(TimerEvent.TIMER,blurTimer);
					timer.start();
					_frameNameToAdd = addImageRightToLeft;
					
				}	
			}
		}
		
		private function fadeoutLeft(event : TimerEvent) : void
		{
			alphaDef = 1;
			paperSprite.addEventListener(Event.ENTER_FRAME,applyBlurFilter);
			timer.stop();
		}
		private function rightToLeftTimer(event : TimerEvent) : void
		{   
				plane.container.filters = [new BlurFilter(100,100,100)]
				scene.removeChild(plane);
				plane = new Plane(bitmapArray[_imageToLoadIndex++]);
				plane.x = 0;
				plane.y = unscaledHeight/2;
				plane.z = 100;
				plane.rotationZ = 0;
				scene.addChild(plane);
				plane.x = this.parent.width;
			paperSprite.addEventListener(Event.ENTER_FRAME,rightToLeftEnterFrame);
			timer.stop();
		}
		private function rightToLeftEnterFrame(event : Event) : void
		{
			this.scene.renderCamera(camera);
			if(plane.x > 0)
			 plane.x -= 10;
			if(alphaDef <= 1)
			{
				plane.container.alpha = alphaDef;
				alphaDef += .01;
			} 
			
			if(plane.x <= 0)
			{
				plane.z -= 5;
				if(plane.z <= -100)
				{
					paperSprite.removeEventListener(Event.ENTER_FRAME,rightToLeftEnterFrame);
					timer = new Timer(_blurTime);
					timer.addEventListener(TimerEvent.TIMER,blurTimer);
					timer.start();
					_frameNameToAdd = moveFromScreen;
					
				}	
			}
		}
		
		//private function moveFromScrenTime
		private function repeatEnterFrames(event : TimerEvent) : void
		{
			timer.stop();
			scene.removeChild(plane);
			plane = new Plane(bitmapArray[_imageToLoadIndex++]);
			//plane.x = 0;
			//plane.y = unscaledHeight/2;
			//plane.z = -1000;
			//plane.rotationZ = 0;
			scene.addChild(plane);
			//paperSprite.addEventListener(Event.ENTER_FRAME,moveFromScreen);
			moveFromScreen();
		}
		
		private function moveFromScreen() : void
		{
			scene.removeChild(plane);
			plane = new Plane(bitmapArray[_imageToLoadIndex++]);
			scene.addChild(plane);
			//plane.x = this.parent.width;
			//alphaDef = 0;
			plane.container.alpha = 0;
			 plane.container.scaleX = 2;
			plane.container.scaleY = 2;
			//camera.z = -1; 
			this.scene.renderCamera(camera);
			paperSprite.addEventListener(Event.ENTER_FRAME, moveFromScreenEvent);
			alphaDef = 0;
		}
		
		private function topToCenter() : void
		{
			scene.removeChild(plane);
			plane = new Plane(bitmapArray[_imageToLoadIndex++]);
			scene.addChild(plane);
			plane.y = this.parent.height/2;
			plane.rotationY = 0;
			//camera.z = -20;
			plane.rotationZ = -40; 
			camera.x = 0;
			camera.y = 0;
			plane.z = 0;
			this.scene.renderCamera(camera);
			paperSprite.addEventListener(Event.ENTER_FRAME, topToCenterEvent);
			alphaDef = 40;
		}
		private function topToCenterEvent(event : Event) : void
		{
			 if(alphaDef >= 0)
			{
				plane.rotationZ = alphaDef;
				alphaDef -= .25;
				
			}   
			 if( plane.y > 0)
			{
				plane.y -= 3;
			}
			else
			 {
			 	paperSprite.removeEventListener(Event.ENTER_FRAME, topToCenterEvent);
			 	timer = new Timer(_blurTime);
				timer.addEventListener(TimerEvent.TIMER,blurTimer);
				timer.start();
				_frameNameToAdd = buttomTOCenter;
			 } 
			this.scene.renderCamera(camera);
		}
		
		private function buttomTOCenter() : void
		{
			scene.removeChild(plane);
			plane = new Plane(bitmapArray[_imageToLoadIndex++]);
			scene.addChild(plane);
			plane.y = -this.parent.height/2;
			plane.rotationY = 0;
			camera.z = -20;
			plane.rotationZ = 40; 
			this.scene.renderCamera(camera);
			paperSprite.addEventListener(Event.ENTER_FRAME, buttomToCenterEvent);
			alphaDef = 40;
		}
		
		private function buttomToCenterEvent(event : Event) : void
		{
			  if(alphaDef >= 0)
			{
				plane.rotationZ = -alphaDef;
				alphaDef -= .25;
				
			}    
			   if( plane.y < 0)
			{
				plane.y += 3;
			} 
			else
			{
			  paperSprite.removeEventListener(Event.ENTER_FRAME, buttomToCenterEvent);
			  timer = new Timer(_blurTime);
				timer.addEventListener(TimerEvent.TIMER,blurTimer);
				timer.start();
				_frameNameToAdd = endSlideShow;
			}  
			this.scene.renderCamera(camera);
		}
		
		private function endSlideShow() : void
		{
			scene.removeChild(plane);
			plane = new Plane(bitmapArray[12-1]);
			scene.addChild(plane);
			//plane.y = -this.parent.height/2;
			plane.rotationY = 0;
			camera.z = -10;
			//plane.rotationZ = 40; 
			this.scene.renderCamera(camera);
		}
		
		
		private function moveFromScreenEvent(event : Event) : void
		{
			if(alphaDef <= 1)
			{
				alphaDef += .05;
				plane.container.alpha = alphaDef;
			}
			else
			{
				if(alphaDef < 10)
				{
					alphaDef += .1 ;
					camera.x= -alphaDef;
					plane.z += alphaDef;
				}
				else
				{
					paperSprite.removeEventListener(Event.ENTER_FRAME, moveFromScreenEvent);
					timer = new Timer(_blurTime);
					timer.addEventListener(TimerEvent.TIMER,blurTimer);
					timer.start();
					_frameNameToAdd = topToCenter;
				}
				//plane.z += alphaDef;
			}
			this.scene.renderCamera(camera);
		}

	}
}