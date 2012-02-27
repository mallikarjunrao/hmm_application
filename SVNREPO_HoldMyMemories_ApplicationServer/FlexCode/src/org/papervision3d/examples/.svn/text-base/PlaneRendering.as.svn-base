package org.papervision3d.examples
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.Number3D;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.Plane;
	import org.papervision3d.scenes.MovieScene3D;
	import org.papervision3d.scenes.Scene3D;
	
	public class PlaneRendering
	{
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
		public var bitmapAssets : Array;
		public var animationPlanes : Array;
		private var zoomed : Boolean = false;
		private var cameraDefault : DisplayObject3D = new DisplayObject3D();
		public function PlaneRendering(pv3dSprite:Sprite, bitmaps : Array)
		{
			this.pv3dSprite = pv3dSprite;
			bitmapAssets = bitmaps;
			animationPlanes = new Array();
			bitmapPlanes = new Dictionary();
			
			init();
		}
		
		private function init():void
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
			camera.x = 3000;
			camera.z = -300;
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
			
			

			// Add a plane to rootNode
			// We divide the plane in segments to use smaller triangles and avoid sorting artifacts.
			//rootNode = scene.addChild(new  Plane( new ColorMaterial( 0xFFFFFF )));
			rootNode = scene.addChild(new  Plane( new ColorMaterial( 0xFFFFFF )), "Ground");
			// Position the plane
			rootNode.rotationX = -90;
			rootNode.y = -2000;
			rootNode.scaleX = 5;
			rootNode.scaleZ = 5;
			rootNode.scaleY = 5;
			
			//X marker
			/* var markerX : DisplayObject3D = new Cube(new ColorMaterial(0xFF0000));
			markerX.x = 100;
			markerX.y = 0;
			markerX.z = 0;
			markerX.scaleX = 0.1;
			markerX.scaleY = 0.1;
			markerX.scaleZ = 0.1;
			
			rootNode.addChild(scene.addChild(markerX));
			
			//Y marker
			var markerY : DisplayObject3D = new Cube(new ColorMaterial(0x00FF00));
			markerY.x = 0;
			markerY.y = 100;
			markerY.z = 0;
			markerY.scaleX = 0.1;
			markerY.scaleY = 0.1;
			markerY.scaleZ = 0.1;
			
			rootNode.addChild(scene.addChild(markerY));
			
			//Z marker
			var markerZ : DisplayObject3D = new Cube(new ColorMaterial(0x0000FF));
			markerZ.x = 0;
			markerZ.y = 0;
			markerZ.z = 100;
			markerZ.scaleX = 0.1;
			markerZ.scaleY = 0.1;
			markerZ.scaleZ = 0.1;
			
			rootNode.addChild(scene.addChild(markerZ)); */
			for(var i : int = 0; i < bitmapAssets.length; i++)
			{
				var bitmap : BitmapFileMaterial = new BitmapFileMaterial(bitmapAssets[i]);
				var plane : Plane = new Plane(bitmap);
				//plane.y = 10*i;
				plane.x = -100*i;
				plane.z = -100*i;
				plane.rotationY = -90;
				scene.addChild(plane);
				// Randomize position
				var gotoData :DisplayObject3D = new DisplayObject3D();
		
				gotoData.x = plane.x;
				gotoData.y = plane.y;
				gotoData.z = plane.z;
		
				gotoData.rotationX = plane.rotationX;
				gotoData.rotationY = plane.rotationY;
				gotoData.rotationZ = plane.rotationZ;
		
				plane.extra =
				{
					goto: gotoData
				};

				var container:Sprite = plane.container
				container.buttonMode = true;
				container.addEventListener( MouseEvent.ROLL_OVER, doRollOver );
				container.addEventListener( MouseEvent.ROLL_OUT, doRollOut );
				container.addEventListener( MouseEvent.MOUSE_DOWN, doPress );
				
				bitmapPlanes[plane.container] = plane;
			}
			lastImagePosition.z = plane.z;
			lastImagePosition.x = plane.x;
		}
		
		private function doRollOver(event : Event) : void
		{
			 var plane:Plane = bitmapPlanes[ event.target ];
			plane.scaleX = 1.1;
			plane.scaleY = 1.1;

			plane.material.lineAlpha = 1; 

			//var glow:Number = Math.max( 20, Math.min( 30, 10 + 20 * (1 - plane.screenZ / cloudSize ) ) );
		//event.target.filters = [new GlowFilter( 0xFFFFFF, 0.7, glow, glow, 1, 1, false, false ) ];
		}
		
		private function doRollOut(event : Event) : void
		{
			var plane:Plane = bitmapPlanes[ event.target ];
			plane.scaleX = 1;
			plane.scaleY = 1;
	
			plane.material.lineAlpha = 0;
		}
		
		private function doPress(event : Event) : void
		{
			
			var plane:Plane = bitmapPlanes[ event.target ];
			plane.scaleX = 1;
			plane.scaleY = 1;
	
			var target :DisplayObject3D = new DisplayObject3D();
			if(zoomed)
			{
				target.copyTransform( plane );
				target.moveBackward( -350 );
		
				camera.extra.goPosition.copyPosition( cameraDefault );
				camera.extra.goTarget.copyPosition( cameraDefault );
		
				plane.material.lineAlpha = 0;
				zoomed = false;
			}else
			{
				target.copyTransform( plane );
				target.moveBackward( 350 );
		
				camera.extra.goPosition.copyPosition( target );
				camera.extra.goTarget.copyPosition( plane );
		
				plane.material.lineAlpha = 0;
				zoomed = true;
					
			}
			
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
	
			for( var i:Number=0; paper = scene.getChildByName( "Album"+i ); i++ )
			{
				var goto :DisplayObject3D = paper.extra.goto;
	
				paper.x -= (paper.x - goto.x) / 32;
				paper.y -= (paper.y - goto.y) / 32;
				paper.z -= (paper.z - goto.z) / 32;
	
				paper.rotationX -= (paper.rotationX - goto.rotationX) /32;
				paper.rotationY -= (paper.rotationY - goto.rotationY) /32;
				paper.rotationZ -= (paper.rotationZ - goto.rotationZ) /32;
			}

			
			/*  for(var i : int =0; i < bitmapPlanes.length; i++)
			{
				var plane : Plane = bitmapPlanes[i] as Plane;
				plane.z += 30;
				plane.x += 30;
				if(plane.z > 1800)
				{
					plane.z = lastImagePosition.z;
					plane.x = lastImagePosition.x +(-100*i);
				}	
			}  */
			// Get plane from rootNode
			//var plane :DisplayObject3D = this.rootNode.getChildByName( "Plane" );

			// Check if car has been loaded
			
				// Get plane from rootNode, we obviously don't need to check if it has been loaded.
				//var plane :DisplayObject3D = this.rootNode.getChildByName( "Plane" );

				// Check if car hits plane and change color
				/* if( car.hitTestObject( plane ) )
					plane.material.fillColor = 0xFFFFFF;
				else
					plane.material.fillColor = 0x333333;
 */
				// Calculate current steer and speed
				//driveCar();

				// Update car model
				//updateCar( car );
			

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

	}
}