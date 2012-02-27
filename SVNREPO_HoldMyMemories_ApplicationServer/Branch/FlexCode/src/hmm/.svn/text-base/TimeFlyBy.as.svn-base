package hmm
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import events.CoverFlowEvent;
	
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.Number3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.Plane;
	import org.papervision3d.scenes.MovieScene3D;
	import org.papervision3d.scenes.Scene3D;
	
	public class TimeFlyBy extends EventDispatcher
	{
		public function TimeFlyBy(pv3dSprite:Sprite, bitmaps : Array, xoff: Number, yoff: Number, zoff: Number, direction : Boolean)
		{
			this.pv3dSprite = pv3dSprite;
			bitmapAssets = bitmaps;
			animationPlanes = new Array();
			bitmapPlanes = new Dictionary();
			_xOffset = xoff;
			_yOffset = yoff;
			_zOffset = zoff;
			leftHanded = direction;
		}
		private var camera:Camera3D;
		private var scene:Scene3D;
		private var rootNode:DisplayObject3D;
		private var pv3dSprite:Sprite;
		private var bitmapPlanes : Dictionary;
		private var keyRight:Boolean = false;
		private var keyLeft:Boolean = false;
		private var keyForward:Boolean = false;
		private var keyReverse:Boolean = false;
		private var lastImagePosition : Number3D = new Number3D();
		private var firstImagePosition : Number3D = new Number3D();
		public var  bitmapAssets : Array;
		public var  animationPlanes : Array;
		private var zoomed : Boolean = false;
		private var cameraDefault : DisplayObject3D = new DisplayObject3D();
		private var renderList : Array = new Array();
		private var _refPlanes : Dictionary = new Dictionary();
		private var kFalloff : Number = 0.4;
		// offsets
		private var _xOffset : Number = 0;
		private var _zOffset : Number = 0;
		private var _yOffset : Number = 0;
		
		// direction
		private var _direction : int = 1;
		var selectedPlane:Plane;
		var selectedIndex : int;
		private var assetPlaneDictionary : Dictionary = new Dictionary();
		var planeBitmapDictionary : Dictionary = new Dictionary();
		public function set xOffset(off : Number) : void
		{
			_xOffset = off;
		}
		
		public function get xOffset() : Number
		{
			return _xOffset;
		}		
		
		public function set yOffset(off : Number) : void
		{
			_yOffset = off;
		}
		public function get yOffset() : Number
		{
			return _yOffset;
		}
		
		public function set zOffset(off : Number) : void
		{
			_zOffset = off;
		}
		public function get zOffset() : Number
		{
			return _zOffset;
		}
		
		public function set leftHanded(left : Boolean) : void
		{
			if(left)
				_direction = -1;
			else
				_direction = -1;
		}
		public function get leftHanded() : Boolean
		{
			return _direction;
		}
		
		public var dataField : String;
		public var labelField : String;
		
		public function StackCoverFlowLeft(pv3dSprite:Sprite, bitmaps : Array, xoff: Number, yoff: Number, zoff: Number, direction : Boolean)
		{
			this.pv3dSprite = pv3dSprite;
			bitmapAssets = bitmaps;
			animationPlanes = new Array();
			bitmapPlanes = new Dictionary();
			_xOffset = xoff;
			_yOffset = yoff;
			_zOffset = zoff;
			leftHanded = direction;
			
		}
		
		public function init():void
		{
			var s:Stage = pv3dSprite.stage;
			s.quality = StageQuality.MEDIUM;

			s.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			s.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			s.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler );

			setupScene();
		}

		private function setupScene():void
		{
			scene = new MovieScene3D(pv3dSprite);

			// Create camera
			camera = new Camera3D();
			camera.x = 800;
			camera.z = 0;
			camera.zoom = 5;
			camera.focus = 100;
			camera.extra =
			{
				goPosition: new DisplayObject3D(),
				goTarget:   new DisplayObject3D()
			};
		  cameraDefault.copyPosition(camera);
		  camera.extra.goPosition.copyPosition( camera );
			// Load Collada scene as rootNode
			
			
			
			
			
			for(var i : int = 0; i < bitmapAssets.length; i++)
			{
				if(dataField)
					var bitmap : BitmapFileMaterial = new BitmapFileMaterial(bitmapAssets[i][dataField]);
				else
					bitmap = new BitmapFileMaterial(bitmapAssets[i]);
				bitmap.smooth = true;
				bitmap.addEventListener(FileLoadEvent.LOAD_COMPLETE, handleFileLoaded);
				var plane : Plane = new Plane(bitmap);
				if(labelField)
				{
					plane.name = bitmapAssets[i][labelField];
				}
				
				var refPlane : Plane = new Plane(bitmap);
				planeBitmapDictionary[bitmap] = plane;
				_refPlanes[plane] = refPlane;
				
				//plane.y = 10*i;
				plane.x = _direction*_xOffset*i;
				plane.z = _zOffset*i;
				plane.y = _direction*_yOffset*i;
				plane.scaleY = 1;
				plane.scaleX = 1.3;
				plane.rotationY = -80;
				// ref plane
				refPlane.x = _direction*_xOffset*i;
				refPlane.z = _zOffset*i;
				refPlane.y = -520;
				refPlane.scaleY = 1;
				refPlane.scaleX = 1.3;
				refPlane.rotationY = -80;
				
				scene.addChild(plane);
				
				scene.addChild(refPlane);
				// Randomize position
				var gotoData :DisplayObject3D = new DisplayObject3D();
		
				gotoData.x = plane.x;
				gotoData.y = plane.y;
				gotoData.z = plane.z;
				gotoData.scaleX = 1.3;
				gotoData.scaleY = 1;
				gotoData.scaleZ = 1;
		
				gotoData.rotationX = plane.rotationX;
				gotoData.rotationY = plane.rotationY;
				gotoData.rotationZ = plane.rotationZ;
				var finalPosition : DisplayObject3D = new DisplayObject3D();
				finalPosition.x = gotoData.x;
				finalPosition.z = gotoData.z;
				plane.extra =
				{
					goto: gotoData,
					finalPosition : finalPosition
				};
				assetPlaneDictionary[plane.container] = bitmapAssets[i];
				var container:Sprite = plane.container
				container.buttonMode = true;
				container.doubleClickEnabled = true;
				container.addEventListener( MouseEvent.ROLL_OVER, doRollOver );
				container.addEventListener( MouseEvent.ROLL_OUT, doRollOut );
				container.addEventListener( MouseEvent.MOUSE_DOWN, doPress );
				container.addEventListener( MouseEvent.DOUBLE_CLICK, handleDoubleClick);
				animationPlanes.push(plane);
				renderList.push(plane);
				bitmapPlanes[plane.container] = plane;
			}
			if(plane)
			{
				lastImagePosition.z = plane.z;
				lastImagePosition.x = plane.x;
				
			}
			if(animationPlanes[0])
			{
				firstImagePosition.z = animationPlanes[0].z;
				firstImagePosition.z = animationPlanes[0].x;	
				var evt : CoverFlowEvent = new CoverFlowEvent("change");
				evt.extra = animationPlanes[0].name;
				dispatchEvent(evt);
			}
			
		}
		
		private function handleDoubleClick(event : MouseEvent) : void
		{
			var evt : CoverFlowEvent = new CoverFlowEvent(CoverFlowEvent.NAVIGATE_TO);
			evt.extra = assetPlaneDictionary[event.target];
			dispatchEvent(evt);
			trace("Yaayyyy! double click works");
		}
		
		
		private function handleFileLoaded(event : FileLoadEvent) : void
		{
			createBorders(	event.target as BitmapFileMaterial);
			createReflectionBitmap(event.target as BitmapFileMaterial, (planeBitmapDictionary[event.target] as Plane));
			
			//(planeBitmapDictionary[event.target] as Plane).material = event.target as BitmapFileMaterial;
		}
		
		private function doRollOver(event : Event) : void
		{
			
			 var plane:Plane = bitmapPlanes[ event.target ];
			plane.scaleX = 1.3;
			plane.scaleY = 1;

			//plane.material.lineAlpha = 1; 
			plane.extra.goto.scaleX = 1.3;
			plane.extra.goto.scaleY = 1.05;
			plane.extra.goto.scaleZ = 1.0;
			
			if(animationPlanes.indexOf(plane) == selectedIndex)
				plane.extra.goto.rotationY = -90;
			plane.container.filters = [new GlowFilter(0xff6600, 1, 90, 90, 1, 1, false, false)];
			
			//var glow:Number = Math.max( 20, Math.min( 30, 10 + 20 * (1 - plane.screenZ / cloudSize ) ) );
		//event.target.filters = [new GlowFilter( 0xFFFFFF, 0.7, glow, glow, 1, 1, false, false ) ];
		}
		
		private function doRollOut(event : Event) : void
		{
			var plane:Plane = bitmapPlanes[ event.target ];
			plane.scaleX = 1.3;
			plane.scaleY = 1;
	
			plane.material.lineAlpha = 0;
			plane.extra.goto.scaleX = 1.3;
			plane.extra.goto.scaleY = 1.0;
			plane.extra.goto.scaleZ = 1.0;
			
			plane.extra.goto.rotationY = -80;
			
			plane.container.filters = [];
		}
		
		private function doPress(event : Event) : void
		{
			
			selectedPlane = bitmapPlanes[ event.target ];
			selectedPlane.scaleX = 1.3;
			selectedPlane.scaleY = 1;
			
			
			animationPlanes.sortOn(["x"], [Array.NUMERIC| Array.DESCENDING]);
			selectedIndex = animationPlanes.indexOf(selectedPlane);
			for(var i : int = 0; i < animationPlanes.length; i++)
			{
				var plane : Plane = animationPlanes[i];
				
				if(plane.x > selectedPlane.x)
				{
					plane.extra.goto.x = 300;
					plane.extra.goto.z = -1000;
					plane.extra.finalPosition.x = _direction*_xOffset*(animationPlanes.length - selectedIndex + i);
					plane.extra.finalPosition.z = _zOffset*(animationPlanes.length - selectedIndex + i);
					
				}else
				{
					plane.extra.goto.x = _direction*_xOffset*(i-selectedIndex);
					plane.extra.goto.z = _zOffset*(i-selectedIndex); 
					plane.extra.finalPosition.x = plane.extra.goto.x
					plane.extra.finalPosition.z = plane.extra.goto.z
				}
				trace("index: "+i+" sorted x: "+plane.x);
			}
			var evt : CoverFlowEvent = new CoverFlowEvent("change");
			evt.extra = selectedPlane.name;
			dispatchEvent(evt);
			
			
			
			
		}
		
		
		private function handleMouseClick(event : MouseEvent) : void
		{
			trace(event.toString());
		}

		private function onEnterFrame( event :Event ):void
		{
			/* camera.z = -300 + pv3dSprite.mouseX * 5;
			camera.y = Math.max( 0, pv3dSprite.mouseY ) * 5; */
			
			var target     :DisplayObject3D = camera.target;
			var goPosition :DisplayObject3D = camera.extra.goPosition;
			var goTarget   :DisplayObject3D = camera.extra.goTarget;
	
			camera.x -= (camera.x - goPosition.x) /32;
			camera.y -= (camera.y - goPosition.y) /32;
			camera.z -= (camera.z - goPosition.z) /32;
	
			target.x -= (target.x - goTarget.x) /32;
			target.y -= (target.y - goTarget.y) /32;
			target.z -= (target.z - goTarget.z) /32;
	
			var paper :DisplayObject3D;
	
			
			
			
			
			for(var i : int= 0; i < animationPlanes.length; i++)
			{
				
				
				var bPlane : Plane = animationPlanes[i];
				var refPlane : Plane = _refPlanes[bPlane];
				var goto :DisplayObject3D = bPlane.extra.goto;
				if(goto.x == 300 && Math.abs((bPlane.x - goto.x) / 32) < 3)
				{
					/* bPlane.x = lastImagePosition.x;
					bPlane.x = -100*(animationPlanes.length - selectedIndex -1);
					bPlane.z = -100*(animationPlanes.length - selectedIndex -1);
					bPlane.extra.goto.x = bPlane.x;
					bPlane.extra.goto.z = bPlane.z; */
					trace("final position reached");
					
					bPlane.x = bPlane.extra.finalPosition.x;
					bPlane.z = bPlane.extra.finalPosition.z;
					refPlane.x = bPlane.x;
					refPlane.z = bPlane.z;
					bPlane.extra.goto.x = bPlane.extra.finalPosition.x;
					bPlane.extra.goto.z = bPlane.extra.finalPosition.z;
				}
				if(Math.abs((bPlane.x - goto.x) / 32) < 0.01)
				{
					/* bPlane.x = lastImagePosition.x;
					bPlane.x = -100*(animationPlanes.length - selectedIndex -1);
					bPlane.z = -100*(animationPlanes.length - selectedIndex -1);
					bPlane.extra.goto.x = bPlane.x;
					bPlane.extra.goto.z = bPlane.z; */
					//trace("final position reached");
					
					bPlane.x = bPlane.extra.finalPosition.x;
					bPlane.z = bPlane.extra.finalPosition.z;
					refPlane.x = bPlane.x;
					refPlane.z = bPlane.z;
					bPlane.extra.goto.x = bPlane.extra.finalPosition.x;
					bPlane.extra.goto.z = bPlane.extra.finalPosition.z;
				}
					bPlane.x -= (bPlane.x - goto.x) / 32;
					bPlane.y -= (bPlane.y - goto.y) / 32;
					bPlane.z -= (bPlane.z - goto.z) / 32;	
				
					bPlane.scaleX += (goto.scaleX - bPlane.scaleX)/300;
					bPlane.scaleY += (goto.scaleY - bPlane.scaleY)/300;
					bPlane.scaleZ += (goto.scaleZ - bPlane.scaleZ)/300;
					
					bPlane.rotationY += (goto.rotationY - bPlane.rotationY)/32;
					
					refPlane.x = bPlane.x;
					refPlane.z = bPlane.z;
					refPlane.scaleX = bPlane.scaleX;
					//refPlane.scaleY = bPlane.scaleY;
					refPlane.scaleZ = bPlane.scaleZ;
					
					refPlane.rotationY = bPlane.rotationY;
				
			}

			
			
			

			// Render the scene
			this.scene.renderCamera( camera );
		}

		

		

		private function keyDownHandler( event :KeyboardEvent ):void
		{
			switch( event.keyCode )
			{
				case "W".charCodeAt():
				case Keyboard.UP:
					keyForward = true;
					keyReverse = false;
					break;

				case "S".charCodeAt():
				case Keyboard.DOWN:
					keyReverse = true;
					keyForward = false;
					break;

				case "A".charCodeAt():
				case Keyboard.LEFT:
					keyLeft = true;
					keyRight = false;
					break;

				case "D".charCodeAt():
				case Keyboard.RIGHT:
					keyRight = true;
					keyLeft = false;
					break;
			}
		}

		private function keyUpHandler( event :KeyboardEvent ):void
		{
			switch( event.keyCode )
			{
				case "W".charCodeAt():
				case Keyboard.UP:
					keyForward = false;
					break;

				case "S".charCodeAt():
				case Keyboard.DOWN:
					keyReverse = false;
					break;

				case "A".charCodeAt():
				case Keyboard.LEFT:
					keyLeft = false;
					break;

				case "D".charCodeAt():
				case Keyboard.RIGHT:
					keyRight = false;
					break;
			}
		}
		
		/* 	this utility function creates our reflection bitmap from our content. It gets called whenever the 
		*	content changes. I should point out that this code was culled from the reflection example created 
		*	by the great Narcisso Jaramillo.
		*/
		private function createReflectionBitmap(target:BitmapFileMaterial, targetPlane : Plane): void
		{
			
			/* var originalHeight : Number = target.maxU*target.bitmap.width; 
			var originalWidth : Number = target.maxV*target.bitmap.height;
			var bitmap : BitmapData = new BitmapData(originalHeight, originalWidth, true, 0x0);
			
			var sprite:Sprite = new Sprite();
			
			var alphas:Array = [0, 0.2];
			var ratios:Array = [32, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(originalWidth,originalHeight, -Math.PI/2, 0, 0);
			sprite.width = originalWidth;
			sprite.height = originalHeight;
			
			sprite.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], alphas, ratios, matr);  
			sprite.graphics.drawRect(0,0, originalWidth, originalHeight);
			sprite.graphics.endFill();
			/* sprite.graphics.beginBitmapFill(target.bitmap);
			sprite.graphics.drawRect(5,5, originalWidth, originalHeight);
			sprite.graphics.endFill(); 
			
			var m : Matrix = new Matrix();
			m.scale(1, -1);
			m.translate(0,originalHeight);
			bitmap.draw(target.bitmap,m, null, BlendMode.ADD);
			var material : BitmapMaterial = new BitmapMaterial(bitmap);
			material.fillAlpha = 0.3;
			material.lineAlpha = 0;
			material.lineColor = 0;
			
			material.bitmap.draw(sprite, m, null, BlendMode.ALPHA); */
			var originalHeight : Number = target.maxV*target.bitmap.height; 
			var originalWidth : Number = target.maxU*target.bitmap.width;
			var bitmap : BitmapData = new BitmapData(originalHeight, originalWidth, true, 0x0);
			// first, figure out how big our bitmap needs to be. Flash bitmap APIs don't like 
			// 0x0 bitmaps, so we'll constrain it to make sure we at least create a 1x1 bitmap.
			var tw:Number = Math.max(1,originalWidth);
			var th:Number = Math.max(1,originalHeight);
			var rect: Rectangle = new Rectangle(0, 0, originalWidth, originalHeight);

			// Create a temporary alpha gradient bitmap.  When we draw our content into our
			// reflection bitmap, we'll combine it with this to get our fadeout effect.			
			// note that in the code below, we create a shape, draw into it, then blit it into
			// our bitmap, and throw the sprite away, all without ever actually adding the shape
			// to the display list.  DisplayObjects can be useful even if they never end up on screen.			
			var alphaGradientBitmap:BitmapData = new BitmapData(tw, th, true, 0x00000000);
			var kFalloff : Number= 0.2
			var gradientMatrix: Matrix = new Matrix();
			var gradientShape: Shape = new Shape();
			gradientMatrix.createGradientBox(tw, th * kFalloff, Math.PI/2, 
				0, th * (1.0 - kFalloff));
			gradientShape.graphics.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xFFFFFF], 
				[0, 0.3], [0, 255], gradientMatrix);
			gradientShape.graphics.drawRect(0, th * (1.0 - kFalloff), 
				tw, th * kFalloff);
			gradientShape.graphics.endFill();
			var m: Matrix = new Matrix();
			m.scale(1, -1);
			m.translate(0, th);
			alphaGradientBitmap.draw(gradientShape, m);
			
			m = new Matrix();
			m.scale(1, -1);
			m.translate(0, originalHeight);
			
			// create a temporary bitmap to hold the image of our content.
			var targetBitmap:BitmapData = new BitmapData(tw, th, true, 0x00000000);
			// initialize it to empty. Note that's not an RGB value, but an ARGB value.
			// the bitmap API adds alpha values to typical RGB hex values.  
			targetBitmap.fillRect(rect, 0x00000000);
			
			targetBitmap.draw(target.bitmap, m);
			// now create the final bitmap for our reflection. 
			var reflectionData:BitmapData = new BitmapData(tw, th, true, 0x00000000);									
			// initialize it to empty. Again, we're using RGBA values
			reflectionData.fillRect(rect, 0x00000000);
			// copy in the bits from our content, and merge it with the gradient bitmap as an alpha channel.
			reflectionData.copyPixels(targetBitmap, rect, new Point(),alphaGradientBitmap);

			var material : BitmapMaterial = new BitmapMaterial(reflectionData);
			material.smooth = false;
			(_refPlanes[targetPlane] as Plane).material = material;
			
			//target.bitmap = bitmap;
			
			
		}
		
		private function createBorders(target: BitmapFileMaterial) : void
		{
			
			var originalHeight : Number = target.maxV*target.bitmap.width; 
			var originalWidth : Number = target.maxU*target.bitmap.height;
			var frame: BitmapData = new BitmapData(target.bitmap.width, target.bitmap.height, false, 0xFFFFFF);
			
			frame.copyPixels(target.bitmap, new Rectangle(0,0, originalWidth, originalHeight), new Point(5,5));
			var plane : Plane = (planeBitmapDictionary[target] as Plane); 
			
			plane.material.maxU = (originalWidth+10)/target.bitmap.width;
			plane.material.maxV = (originalHeight+10)/target.bitmap.height;
			plane.material.bitmap  = frame;
		}
		
		
		
	}
}