package
{
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.Plane;
	import org.papervision3d.scenes.MovieScene3D;
	
	public class ImageRotationSpriteTweener extends UIComponent
	{
			private var scene : MovieScene3D;
			private var plane : DisplayObject3D;
			private var plane2 : DisplayObject3D;
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
			private var sound : Sound;
			private var mH : Number = 0.16402;
			private var bH : Number = -188.92916;
			private var mW : Number = 0.10361;
			private var bW : Number = -193.61;
			private var mSH : Number = 1.05839;
			private var bsH : Number = -764.19443;
			private var msW :  Number = 0.39743;
			private var bsW :  Number = -598.7104;
			private var duration : Number;
			private var repeatCount : int =0;
			private var tweenFuntions : Array;
			private var numImages : int = 18;
			private var myPlane : DisplayObject3D;
			private var familyPlane : DisplayObject3D;
			private var albumPlane : DisplayObject3D;
			private var momentsPlane : DisplayObject3D;
			private var memoriesPlane : DisplayObject3D;
			private var _count : int = 1;
			private var soundchannel : SoundChannel;
			private var endBitMap : BitmapFileMaterial;
			private var parentWidthHeight : Point;
			
			/*loading bar details*/
			private var t:TextField;
        	private var f:DropShadowFilter=new DropShadowFilter(2,45,0x000000,0.5)
        	private var pathfLogo:DisplayObject;
        	private var bar:Sprite=new Sprite();
        	private var barFrame:Sprite;
        	private var mainColor:uint=0x00AEEF;
        	private var _fractionLoaded : Number;
        	private var button : Button;
        	private var maxPlane : DisplayObject3D;
        	private var minPlane : DisplayObject3D;
        	private var soundVolume : SoundTransform;
        	private var titleArray : Array;
        	private var titlePlane : DisplayObject3D;
			private var titleError : Boolean = false;
			private var song : String;
			private var _delay : Number;
			private var alphaDuration : Number;
			private var alphaDelay : Number;
			
			[Embed(source="assets/maximize.jpg")] 
			private var MaximizeImage:Class;
			
			[Embed(source="assets/minimize.jpg")] 
			private var MinimizeImage:Class;

		public function ImageRotationSpriteTweener()
		{
			camera = new Camera3D();
			camera.zoom = 1;//.8;
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
			tweenFuntions = new Array();
			tweenFuntions.push(tweenImageStart);
			tweenFuntions.push(tweenImageFrontSecond);
			tweenFuntions.push(tweenImageLeftToCenter);
			tweenFuntions.push(tweenImageRightToCenter);
			tweenFuntions.push(tweenImageTopToCenter);
			tweenFuntions.push(tweenImageBottomCenter);
			//scene.interactive = true;
			//scene.container.buttonMode = true;
			scene.interactive = true;
			
			var httpservice : HTTPService = new HTTPService();
			httpservice.url = Application.application.parameters.xmlfile;//"/user_content/videos/EREHJ9qk.xml";
			httpservice.addEventListener(ResultEvent.RESULT,handleHttpResult);
			httpservice.addEventListener(FaultEvent.FAULT,handleHttpFault);
			httpservice.send();   
			
			
			
		}
		
		private function handleHttpResult(result : ResultEvent) : void
		{
			var images : ArrayCollection;
			if(result.result.images.img is ArrayCollection)
			 images = result.result.images.img as ArrayCollection;
			else
			 images = new ArrayCollection([result.result.images.img]); 
			bitmapArray = new Array();
			numImages = images.length + 1;
			 
			titleArray = new Array();
			try
			{
				 	var btmMy : BitmapFileMaterial = new BitmapFileMaterial(result.result.images.title.file);//("/titleImages/my.png")
				 	titleArray[0] = btmMy;
				
			}
			catch(exce : Error)
			{
				titleError = true;
			}
			
			try
			{
			  song = result.result.images.song.file;
			}
			catch(exception : Error)
			{
				Alert.show("Sorry unable to load song ! /n Please try to create the silde show again");
				//song = this.parentApplication.song;
			}
			
			var albumType : String = result.result.images.swf;
			switch(albumType)
			{
				case "babyAlbum":
				                 this.parentApplication.duration = 3; 
			                     this.parentApplication. delay = 5;
							     this.parentApplication.alphaDuration = 1;
								 this.parentApplication.alphaDelay = 7;
				                 break;
				case "familyAlbum":
				                  this.parentApplication.duration = 3;
								  this.parentApplication.delay = 5;
								  this.parentApplication.alphaDuration = 1;
								  this.parentApplication.alphaDelay = 7;
				                  break;
				case "heartAlbum":
				                 this.parentApplication.duration = 3;
								 this.parentApplication.delay = 5;
								 this.parentApplication.alphaDuration = 1;
								 this.parentApplication.alphaDelay = 7;
				                 break;
				case "shineAlbum":
				                this.parentApplication.duration = 1.5;
								this.parentApplication.delay = 2.5;
								this.parentApplication.alphaDuration = .5;
								this.parentApplication.alphaDelay = 3.5;
				                 break;                                                    
			}
			
			for(var i : int = 0; i < images.length; i++)
			{
				var bmfm : BitmapFileMaterial;
					bmfm = new BitmapFileMaterial(images[i].file);//("ResizedImage/image"+i+".jpg");
					if(i == 0)
						bmfm.addEventListener(FileLoadEvent.LOAD_COMPLETE, handleLoadComplete);
					bmfm.doubleSided = false;
					//bmfm.smooth = true;
				bitmapArray.push(bmfm);
			}  
			camera.z = -140;
		}
		
		private function handleHttpFault(fault : FaultEvent) : void
		{
			
		}
		
		private function handleResize(event : FullScreenEvent) : void
		{
			if(event.fullScreen)
			{
			   	
			}
			else
			{
				camera.z = -140;
				loopRenderCamera();
				button.label = "goFull";
				button.styleName = "fullScreen";
				button.y =  (this.parent.height/2 - 19);
				button.x = this.parent.width/2 - 19;
				
			}
		}
		
		
		protected function createAssets():void
        {
            //craate bar
            bar = new Sprite();
             bar.graphics.drawRoundRectComplex(0,0,300,15,12,0,0,12);
            bar.x = - bar.width/2;
            //bar.y = stage.height/2;// - bar.height/2;
            bar.filters = [f];
            paperSprite.addChild(bar);
            
            //create bar frame
            barFrame = new Sprite();
            barFrame.graphics.lineStyle(2,0xFFFFFF,1)
            barFrame.graphics.drawRoundRectComplex(0,0,300,15,12,0,0,12);
            barFrame.graphics.endFill();
           barFrame.x =  -barFrame.width/2;
           // barFrame.y = stage.height/2 - barFrame.height/2;
            barFrame.filters = [f];
            paperSprite.addChild(barFrame);
            
            //create text field to show percentage of loading
            t = new TextField();
            t.y = barFrame.y-27;
            t.filters=[f];
            addChild(t);
            //we can format our text
            var s:TextFormat=new TextFormat("Verdana",null,0xFFFFFF,null,null,null,null,null,"right");
            t.defaultTextFormat=s;
        }

		 protected function draw():void
        {
            t.text = int(_fractionLoaded*100).toString()+"%";
            //make objects below follow loading progress
            //positions are completely arbitrary
            //d tells us the x value of where the loading bar is at
            var d:Number=barFrame.x + barFrame.width * _fractionLoaded
            t.x = d - t.width - 25;
           // pathfLogo.x = d - pathfLogo.width;
            bar.graphics.beginFill(mainColor,1)
            bar.graphics.drawRoundRectComplex(0,0,bar.width * _fractionLoaded,15,12,0,0,12);
            bar.graphics.endFill();
            this.scene.renderCamera(camera);
        }

		
		override protected function createChildren():void
		{
			super.createChildren();
			//addChild(backGroundSprite);
			addChild(paperSprite);
			button = new Button();
			button.label = "goFull";
			button.width = 0;
			button.height = 0;
			button.x  += this.parent.width/2 - 19;
			button.y =  (this.parent.height/2 - 19);
			button.addEventListener(MouseEvent.CLICK, handleFullscreenClick);
			addChild(button);
			button.styleName = "fullScreen";
			button.buttonMode = true;
			button.useHandCursor = true;
			button.visible = false;
			
		}
		
		private function handleFullscreenClick(event : Event) : void
		{
				if(stage.displayState == StageDisplayState.NORMAL)
				{
					if(!titleError)
						titlePlane.y = 450; 
					camera.z = -110;
					loopRenderCamera();
					stage.displayState = StageDisplayState.FULL_SCREEN;
					/* this.parentApplication.width = stage.width;
					this.parentApplication.height = stage.height; */
					button.label = "goNormal";
					button.styleName = "normalScreen";
				    button.y = (this.parent.height/2 - 19);
				    button.x = (this.parent.width/2 - 19);
				    
				}		
				else
				{
					if(!titleError)
						titlePlane.y = 400;
					camera.z = -140;
					loopRenderCamera();
					/* this.parentApplication.width = parentWidthHeight.x;
					this.parentApplication.height = parentApplication.y; */
					stage.displayState = StageDisplayState.NORMAL;
					button.label = "goFull";
					button.styleName = "fullScreen";
					button.y =  (this.parent.height/2 - 19);
					button.x = this.parent.width/2 - 19;
					
				}
		}
		
		private function handleAddedToStage(event : Event) : void
		{
			paperSprite.stage.quality = StageQuality.BEST;
			stage.addEventListener(FullScreenEvent.FULL_SCREEN,handleResize);
			parentWidthHeight = new Point(this.parentApplication.width,this.parentApplication.height);
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			
			/* if(stage.height < stage.width)
				camera.z =(stage.height * mSH) + bsH;
			else
				camera.z =(stage.width * msW) + bsW; */
			//createAssets();
		}
		
		private function onEnterFrame(event : Event) : void
		{
			
		}
		
	  /* override protected function commitProperties():void
		{
			  bitmapArray = new Array();
			
			for(var i : int = 1; i < numImages-1; i++)
			{
				var bmfm : BitmapFileMaterial;
					bmfm = new BitmapFileMaterial("ResizedImage/image"+i+".jpg");
					if(i == 1)
						bmfm.addEventListener(FileLoadEvent.LOAD_COMPLETE, handleLoadComplete);
					bmfm.doubleSided = false;
					bmfm.smooth = true;
				bitmapArray.push(bmfm);
			}  
			if(this.parent.width < 800)
				camera.z = -150;//-140;//-105.608;////
			else
			    camera.z = -140;
			
		}    */
		
		private function handleLoadComplete(event : FileLoadEvent) : void
		{
			/* if((_count + 1) == numImages)
			{ */
			 //paperSprite.removeChild(bar);
			 //paperSprite.removeChild(barFrame);
			// removeChild(t);
			button.visible = true;
			duration = this.parentApplication.duration;
			_delay = this.parentApplication.delay;
			alphaDuration = this.parentApplication.alphaDuration;
			alphaDelay = this.parentApplication.alphaDelay;
			endBitMap = new BitmapFileMaterial("/titleImages/end.png");
			plane = new Plane(bitmapArray[_imageToLoadIndex]);
			//  if(plane.material.bitmap.width < plane.material.bitmap.height) 
		  	plane.z = (plane.material.bitmap.height * mH) + bH;
		  	plane.y = -28;
		  	//else
		    //plane.z = (plane.material.bitmap.width * mW) + bW;	  */
			//plane.z = (plane.material.bitmap.height * m) + b;
			//plane.x = -150;
			//plane.x = 0;			
 			//plane.container.alpha = 0;
			scene.addChild(plane);
			plane.container.filters = [new GlowFilter(0xFFFFFF)];
			plane.container.buttonMode = BlendMode.ADD;
			//plane.container.alpha = 0;
			this.scene.renderCamera(camera);
			sound = new Sound();
			sound.load(new URLRequest(song));
			soundchannel = sound.play();
			soundVolume = new SoundTransform();
			soundchannel.addEventListener(Event.SOUND_COMPLETE,handleSoundComplete)
			/* var myText : TextMaterial = new TextMaterial("My","TheNautiGal",70);
			var familyText : TextMaterial = new TextMaterial("Family","TheNautiGal",100);
			var albumText : TextMaterial = new TextMaterial("Album","TheNautiGal",70);
			var momentsText : TextMaterial = new TextMaterial("Today's Moments","Arial",20);
			var memoriesText : TextMaterial = new TextMaterial("Tomorrow's Memories","Arial",20); */
			/* memoriesPlane = new Plane(titleArray["tomorrowsmemories"]);//(memoriesText,memoriesText.width,memoriesText.height);
			memoriesPlane.x = this.parent.width*2;
			momentsPlane = new Plane(titleArray["todaysmoments"]);//(momentsText,momentsText.width,momentsText.height);
			momentsPlane.x = this.parent.width*2;
			momentsPlane.z = -40;
			memoriesPlane.z = -40; */
			/* scene.addChild(momentsPlane);
			scene.addChild(memoriesPlane); */
			/* myPlane = new Plane(titleArray["my"]);//(myText,myText.width,myText.height);
			myPlane.z = -200;
			myPlane.x = -10;
			familyPlane = new Plane(titleArray["family"]);//(familyText,familyText.width,familyText.height);
			familyPlane.z = -200;
			familyPlane.x = -10;
			albumPlane = new Plane(titleArray["album"]);//(albumText,albumText.width,albumText.height);
			albumPlane.z = -200;
			albumPlane.x = -10;
			scene.addChild(myPlane);
			scene.addChild(familyPlane);
			scene.addChild(albumPlane); */
			if(!titleError)
			{
				titlePlane = new Plane(titleArray[0]);
				titlePlane.x = this.parent.width * 5;
				titlePlane.z = -40;
				titlePlane.y = 400;
				scene.addChild(titlePlane);
			}
			scene.renderCamera(camera);
			if(!titleError)
				tweenText();
			else
			 startTimer();	
				
			/* }
			else
			{
			 _count++;
			 _fractionLoaded = _count/bitmapArray.length;
			 draw();
			} */
			//tweenImageStart();
		}
		
		
		/* private function handleMaximize(event : InteractiveScene3DEvent) : void
		{
			minPlane.visible = true;
			maxPlane.visible = false;
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		 */
		/* private function handleMinimize(event : InteractiveScene3DEvent) : void
		{
			maxPlane.visible = true;
			minPlane.visible = false;
			stage.displayState = StageDisplayState.NORMAL;
		} */
	
		private function tweenText() : void
		{
			/* Tweener.addTween(myPlane,{z : -60,x : 480,y : 150,onUpdate : loopRenderCamera, time : duration,transition : Equations.easeOutElastic});
			Tweener.addTween(familyPlane,{z : -60,x : 460,y : 40,onUpdate : loopRenderCamera, time : duration,delay : duration -2 ,transition : Equations.easeOutElastic});
			Tweener.addTween(albumPlane,{z : -60,x : 460,y : -40,onUpdate : loopRenderCamera, time : duration,delay : duration-4,onComplete : applyGlowFilter,transition : Equations.easeOutElastic});
			Tweener.addTween(momentsPlane,{x : 550,y : -150,onUpdate : loopRenderCamera,time : duration,delay : duration -1,transition : Equations.easeInOutQuart});
			Tweener.addTween(memoriesPlane,{x : 600,y : -170,onUpdate : loopRenderCamera,time : duration,delay : duration,transition : Equations.easeInOutQuart,onComplete : startTimer}); */
			Tweener.addTween(titlePlane,{x : -150,onUpdate : loopRenderCamera,time : duration,transition : Equations.easeInOutQuart,onComplete : applyGlowFilter});
	
		}
		
		private function applyGlowFilter() : void
		{
		  titlePlane.container.filters = [new GlowFilter(0XFF0000,3,50,50,1,1)];
		  scene.renderCamera(camera);	
		  startTimer();
		}
		
		private function startTimer() : void
		{
			var timer : Timer = new Timer(2000,1);
			timer.addEventListener(TimerEvent.TIMER,startTransitions);
			timer.start();
		}
		
		private function startTransitions(event : TimerEvent) : void
		{
			if(!titleError)
				Tweener.addTween(plane.container,{alpha : 0,time : alphaDuration,onUpdate : loopRenderCamera});
			else
				Tweener.addTween(plane.container,{alpha : 0,time : alphaDuration,onUpdate : loopRenderCamera,onComplete :tweenImageStart });
				
			/* var mySprite :  Sprite = myPlane.container;
			//myPlane.container.alpha = 0;
			Tweener.addTween(mySprite,{alpha : 0,time : 2});
			var familySprite : Sprite = familyPlane.container;
			Tweener.addTween(familySprite,{alpha : 0,time : 2});
			var albumSprite : Sprite = albumPlane.container;
			Tweener.addTween(albumSprite,{alpha : 0,time : 2});
			var momentsSprite : Sprite = momentsPlane.container;
			Tweener.addTween(momentsSprite,{alpha : 0,time : 2});
			var memoriesSprite : Sprite = memoriesPlane.container;
			Tweener.addTween(memoriesSprite,{alpha : 0,time : 2,onComplete :tweenImageStart }); */
			if(!titleError)
			{
				var titleSprite : Sprite = titlePlane.container;
				Tweener.addTween(titleSprite,{alpha : 0,time : alphaDuration,onUpdate : loopRenderCamera,onComplete :tweenImageStart });
			} 
			 
		}
		
		private function tweenImageStart() : void
		{
		  
		  	if((_imageToLoadIndex + 1) < bitmapArray.length -1)
		  	{
		  		scene.removeChild(plane);
		  		plane = new Plane(bitmapArray[++_imageToLoadIndex]);
				plane.z = 1000;//(plane.material.bitmap.height * m) + b;
				//plane.x = 100;
				//plane.y = 0;
				scene.addChild(plane);
				plane.container.buttonMode = BlendMode.ADD;
		  	}
		  	else
		  	{
		  	  slideShowEnd();
		  	  return;
		  	}	
		  	/* plane = new Plane(bitmapArray[++_imageToLoadIndex]);
		  	plane.z = 1000;
		  	scene.addChild(plane);
		  	plane.container.alpha = 0; */
		  
		  var obj : Object = new Object();
		   //  if(plane.material.bitmap.width < plane.material.bitmap.height) 
		  obj.z = (plane.material.bitmap.height * mH) + bH;
		 /* else
		    obj.z = (plane.material.bitmap.width * mW) + bW;	 */  
		  //obj.z = 120;
		  obj.time = duration;
		  obj.rotationZ = 2*360;
		  obj.onUpdate = loopRenderCamera;
		  obj.onComplete = tweenImageBack;
		  var plane_alpha : Sprite = plane.container;
		  camera.lookAt(plane);
		  Tweener.addTween(plane,obj);
		  Tweener.addTween(plane_alpha,{alpha : 1,time : alphaDuration});
		  	
		}
		
		private function loopRenderCamera() : void
		{
			this.scene.renderCamera(camera);
		}
		
		private function tweenImageBack() : void
		{
		  var obj : Object = new Object();
		  obj.z = 1000;
		  obj.time = duration;
		  obj.transition = Equations.easeInExpo;
		  obj.rotationZ = 2*360;
		  obj.onUpdate = loopRenderCamera;
		  obj.delay = 2;
		  obj.onComplete = tweenImageFrontSecond;
		  Tweener.addTween(plane,obj);
		  Tweener.addTween(plane.container,{alpha : 0,time : alphaDuration,delay : alphaDelay});	
		}
		
		private function removePlane() : void
		{
			scene.removeChild(plane);
		}
		
		private function tweenImageFrontSecond() : void
		{ 
			//scene.removeChild(plane);
			if((_imageToLoadIndex + 1) < bitmapArray.length)
		  		scene.removeChild(plane);
		  	else
		  	{
		  	  slideShowEnd();
		  	  return;
		  	}	
			plane = new Plane(bitmapArray[++_imageToLoadIndex]);
			plane.z = 1000;
			var obj : Object = new Object();
			obj.time = duration;
			obj.transition = Equations.easeOutExpo;
			obj.rotationZ = 360;
			obj.onUpdate = loopRenderCamera;
			obj.onComplete = tweenImageBackSecond;
			 // if(plane.material.bitmap.width < plane.material.bitmap.height) 
		  	obj.z = (plane.material.bitmap.height * mH) + bH;
		  	/*else
		    obj.z = (plane.material.bitmap.width * mW) + bW; */	 
		    //obj.z = -95;
			scene.addChild(plane);
			plane.container.buttonMode = BlendMode.ADD;
			plane.container.alpha = 0;
			Tweener.addTween(plane,obj);
			Tweener.addTween(plane.container,{alpha : 1,time : alphaDuration});
			
		}
		
		private function tweenImageBackSecond() : void
		{
		  var obj : Object = new Object();
		  obj.z = 1000;
		  obj.time = duration;
		  obj.transition = Equations.easeInExpo;
		  obj.rotationZ = 2*360;
		  obj.onUpdate = loopRenderCamera;
		  obj.delay = _delay;
		  obj.onComplete = tweenImageLeftToCenter;
		  Tweener.addTween(plane,obj);
		  Tweener.addTween(plane.container,{alpha : 0,time : alphaDuration,delay : alphaDelay});
		}
		
		private function tweenImageLeftToCenter() : void
		{
			if((_imageToLoadIndex + 1) < bitmapArray.length)
		  		scene.removeChild(plane);
		  	else
		  	{
		  	  slideShowEnd();
		  	  return;
		  	}	
			plane = new Plane(bitmapArray[++_imageToLoadIndex]);
			plane.z = 1000;
			plane.x = -this.parent.width * 5;
			var obj : Object = new Object();
			obj.time = duration;
			//obj.rotationZ = 360;
			obj.onUpdate = loopRenderCamera;
			obj.x = 0;
			obj.onComplete = leftCenterPopUp;
			scene.addChild(plane,"leftplane");
			plane.container.buttonMode = BlendMode.ADD;
			plane.container.alpha = 0;
			Tweener.addTween(plane,obj);
			Tweener.addTween(plane.container,{alpha : 1,time : 3});	
		}
		
		private function leftCenterPopUp() : void
		{
			var obj : Object = new Object();
			obj.time = duration;
			obj.transition = Equations.easeOutExpo;;
			obj.onUpdate = loopRenderCamera;
			//if(plane.material.bitmap.width < plane.material.bitmap.height) 
		  	obj.z = (plane.material.bitmap.height * mH) + bH;
		    //else
		    // obj.z = (plane.material.bitmap.width * mW) + bW;	
			Tweener.addTween(plane,obj);
			//Tweener.addTween(plane.container,{alpha : 1,time : 3,delay : 5});
			var obj1 = new Object();
			obj1.time = duration;
			obj1.delay = _delay;
			obj1.onUpdate = loopRenderCamera;
			obj1.x = this.parent.width*2;
			obj1.rotationZ = 2*360;
			obj1.transition = Equations.easeInOutCirc;
			Tweener.addTween(plane,obj1);
			Tweener.addTween(plane.container,{alpha : 0,time : alphaDuration,delay : alphaDelay,onUpdate : loopRenderCamera,onComplete : tweenImageRightToCenter});
		}
		
		private function tweenImageRightToCenter() : void
		{
			if((_imageToLoadIndex + 1) < bitmapArray.length)
		  		scene.removeChild(plane);
		  	else
		  	{
		  	  slideShowEnd();
		  	  return;
		  	}	
			plane = new Plane(bitmapArray[++_imageToLoadIndex]);
			plane.z = 1000;
			plane.x = this.parent.width * 5;
			var obj : Object = new Object();
			obj.time = duration;
			obj.transition = Equations.easeOutExpo;;
			//obj.rotationZ = 360;
			obj.onUpdate = loopRenderCamera;
			obj.x = 0;
			obj.onComplete = rightCenterPopup;
			scene.addChild(plane);
			plane.container.buttonMode = BlendMode.ADD;
			plane.container.alpha = 0;
			Tweener.addTween(plane,obj);
			Tweener.addTween(plane.container,{alpha : 1,time : alphaDuration});
			scene.removeChildByName("leftplane");
		}
		
		private function rightCenterPopup() : void
		{
			var obj : Object = new Object();
			obj.time = duration;
			//obj.delay = 1;
			obj.transition = Equations.easeOutExpo;;
			obj.onUpdate = loopRenderCamera;
			//if(plane.material.bitmap.width < plane.material.bitmap.height) 
		  	obj.z = (plane.material.bitmap.height * mH) + bH;
		  //else
		 //   obj.z = (plane.material.bitmap.width * mW) + bW;	
			//obj.onComplete = tweenImageTopToCenter;
			Tweener.addTween(plane,obj);
			Tweener.addTween(plane.container,{alpha : 0,time : alphaDuration,delay : alphaDelay,onUpdate : loopRenderCamera,onComplete : tweenImageTopToCenter});
		}
		
		private function tweenImageTopToCenter() : void
		{
			if((_imageToLoadIndex + 1) < numImages)
		  		scene.removeChild(plane);
		  	else
		  	{
		  	  slideShowEnd();
		  	  return;
		  	}	
			plane = new Plane(bitmapArray[++_imageToLoadIndex]);
			plane.z = 1000;
			plane.y = this.parent.height*5;
			var obj : Object = new Object();
			obj.time = duration;
			//obj.rotationZ = 360;
			obj.onUpdate = loopRenderCamera;
			obj.y = 0;
			obj.onComplete = topCenterPopUp;
			scene.addChild(plane);
			plane.container.buttonMode = BlendMode.ADD;
			plane.container.alpha = 0;
			Tweener.addTween(plane,obj);
			Tweener.addTween(plane.container,{alpha : 1,time : alphaDuration});
			
		}
		
		private function topCenterPopUp() : void
		{
			var obj : Object = new Object();
			obj.time = duration;
			//obj.delay = 1;
			obj.transition = Equations.easeOutExpo;;
			obj.onUpdate = loopRenderCamera;
			obj.z = (plane.material.bitmap.height * mH) + bH;
			obj.onComplete = topCenterFadeOut;
			Tweener.addTween(plane,obj);
			
		}
		
		private function topCenterFadeOut() : void
		{
			Tweener.addTween(plane.container,{alpha : 0,time : alphaDuration,delay : alphaDelay+1,onUpdate : loopRenderCamera,onComplete : tweenImageBottomCenter});	
		}
		
		private function tweenImageBottomCenter() : void
		{
			if((_imageToLoadIndex + 1) < bitmapArray.length -1)
		  		scene.removeChild(plane);
		  	else
		  	{
		  	  slideShowEnd();
		  	  return;
		  	}	
			plane = new Plane(bitmapArray[++_imageToLoadIndex]);
			plane.z = 1000;
			plane.y = -this.parent.height*5;
			var obj : Object = new Object();
			obj.time = duration;
			//obj.rotationZ = 360;
			obj.onUpdate = loopRenderCamera;
			obj.y = 0;
			obj.onComplete = bottomCenterPopUp;
			scene.addChild(plane);
			plane.container.buttonMode = BlendMode.ADD;
			plane.container.alpha = 0;
			Tweener.addTween(plane,obj);
			Tweener.addTween(plane.container,{alpha : 1,time : alphaDuration});	
		}
		
		private function bottomCenterPopUp() : void
		{
			var obj : Object = new Object();
			obj.time = duration;
			//obj.delay = 2;
			obj.transition = Equations.easeOutExpo;;
			obj.onUpdate = loopRenderCamera;
			//if(plane.material.bitmap.width < plane.material.bitmap.height) 
		  	obj.z = (plane.material.bitmap.height * mH) + bH;
		 // else
		 //   obj.z = (plane.material.bitmap.width * mW) + bW;	
			//obj.onComplete = tweenImageLeftRightCorner;
			Tweener.addTween(plane,obj);
			Tweener.addTween(plane.container,{alpha : 0,time : alphaDuration,delay : alphaDelay+1,onUpdate : loopRenderCamera,onComplete : tweenImageLeftRightCorner});
		}
		
		private function tweenImageLeftRightCorner() : void
		{
			if((_imageToLoadIndex + 1) < bitmapArray.length -1)
		  		scene.removeChild(plane);
		  	else
		  	{
		  	  slideShowEnd();
		  	  return;
		  	}	
			plane = new Plane(bitmapArray[++_imageToLoadIndex]);
			plane.z = 1000;
			plane.y = this.parent.height*5;
			plane.x = -this.parent.width*5;
			var obj : Object = new Object();
			obj.time = duration;
			obj.onUpdate = loopRenderCamera;
			obj.y = 0;
			obj.x = 0;
			obj.onComplete = leftRightCornerPopUp;
			
			Tweener.addTween(plane,obj);
			var planeRight : DisplayObject3D = new Plane(bitmapArray[_imageToLoadIndex]);
			planeRight.z = 1000;
			planeRight.y = this.parent.height*5;
			planeRight.x = this.parent.width*5;
			var objRight : Object = new Object();
			objRight.time = duration;
			objRight.y = 0;
			objRight.x = 0;
			//objRight.z = 100;
			objRight.onUpdate = loopRenderCamera;
			scene.addChild(plane,"leftCorner");
			plane.container.buttonMode = BlendMode.ADD;
			scene.addChild(planeRight,"rightCorner");
			planeRight.container.buttonMode = BlendMode.ADD;
			plane.container.alpha = 0;
			
			Tweener.addTween(plane.container,{alpha : 1,time : alphaDuration});
			Tweener.addTween(planeRight,objRight);	
			
		}
		
		private function leftRightCornerPopUp() : void
		{
			scene.removeChildByName("rightCorner");
			var obj : Object = new Object();
		//	if(plane.material.bitmap.width < plane.material.bitmap.height) 
		  	obj.z = (plane.material.bitmap.height * mH) + bH;
		//  else
		//    obj.z = (plane.material.bitmap.width * mW) + bW;	
			//obj.delay = 1;
			obj.time = duration;
			//obj.delay = _delay;
			obj.onUpdate = loopRenderCamera;;
			obj.transition = Equations.easeOutCirc;
			obj.onComplete = leftRightCornerFadeOut;
			Tweener.addTween(plane,obj);
			
		}
		
		private function leftRightCornerFadeOut() : void
		{
			Tweener.addTween(plane.container,{alpha : 0,delay : alphaDelay,time : alphaDuration,onUpdate : loopRenderCamera,onComplete : tweenImageStart});
		}
		
		/* private function loadLastImage() : void
		{
			if((_imageToLoadIndex + 1) < numImages)
		  		scene.removeChild(plane);
		  	else
		  	{
		  	  slideShowEnd();
		  	  return;
		  	}	
			plane = new Plane(bitmapArray[bitmapArray.length - 1]);
			plane.z = -10;
			plane.y = 0;
			plane.x = 0;
			scene.addChild(plane);
			this.scene.renderCamera(camera);
			sound.close();
			
		} */
		
		private var slideShowComplete : Boolean = false;
		private function slideShowEnd() : void
		{
			scene.removeChild(plane);
			//var endText : TextMaterial = new TextMaterial("End","Arial",70);
			plane = new Plane(endBitMap);
			plane.z = 1000;
			scene.addChild(plane);
			/* var timer : Timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER,handleTimerEvent);
			timer.start(); */
			Tweener.addTween(plane,{z : -20,onUpdate : handleTimerEvent,time : duration});
		}
		
		
		private function handleTimerEvent() : void
		{
			soundVolume.volume = soundchannel.soundTransform.volume -0.02;
			soundchannel.soundTransform = soundVolume;
			if(soundchannel.soundTransform.volume <= 0)
			{
				slideShowComplete = true;
				soundchannel.stop();
			}
				
			this.scene.renderCamera(camera);
		}
		
		private function handleSoundComplete(event : Event) : void
		{
			if(!slideShowComplete)
			{
				soundchannel = sound.play();
			}
		}
		
		
		

	}
}