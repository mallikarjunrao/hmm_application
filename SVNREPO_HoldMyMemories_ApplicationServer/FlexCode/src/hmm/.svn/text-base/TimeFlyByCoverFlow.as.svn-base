package hmm
{
	import events.CoverFlowEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.Plane;
	import org.papervision3d.scenes.MovieScene3D;

	public class TimeFlyByCoverFlow extends StackCoverFlowLeft
	{
		protected var timer : Timer = new Timer(500);
		private var currentIndex : int = 0;
		private var positionReached : Boolean = false;
		public function TimeFlyByCoverFlow(pv3dSprite:Sprite, bitmaps:Array, xoff:Number, yoff:Number, zoff:Number, direction:Boolean)
		{
			//TODO: implement function
			super(pv3dSprite, bitmaps, xoff, yoff, zoff, direction);
			timer.addEventListener(TimerEvent.TIMER, handleTimerEvent);
			timer.start();
		}
		
		private function handleTimerEvent(event : Event) : void
		{
		/* 	var plane : Plane = renderList[0];
			var prevPoint : Number3D = new Number3D();
			prevPoint.x = plane.x;
			prevPoint.y = plane.y;
			prevPoint.z = plane.z;
			plane.extra.goto.x = 300;
			plane.extra.goto.z = 2800;
			plane.extra.goto.y = 200;
			plane.extra.finalPosition.x = 800;
			plane.extra.finalPosition.z = 3800;
			plane.extra.finalPosition.y = 200;
			var currPoint : Number3D = new Number3D(); 
			for(var i : int= 1; i < renderList.length; i++)
			{
				plane = renderList[i];
				currPoint.x = plane.x;
				currPoint.y = plane.y;
				currPoint.z = plane.z;
				plane.extra.goto.x = prevPoint.x;
				plane.extra.goto.y = prevPoint.y;
				plane.extra.goto.z = prevPoint.z;
				prevPoint.x = currPoint.x;
				prevPoint.y = currPoint.y;
				prevPoint.z = currPoint.z;
				plane.extra.finalPosition.x = currPoint.x;
				plane.extra.finalPosition.z = currPoint.y;
				plane.extra.finalPosition.y = currPoint.z;
			}  */
			 
			camera.extra.goPosition.z =  -_zOffset*(currentIndex) + 800;	
			camera.extra.goPosition.x = 400+_direction*_xOffset*currentIndex*Math.sin(-camera.extra.goPosition.z/2300);
			camera.extra.goPosition.y = _yOffset*currentIndex*Math.sin(camera.extra.goPosition.z/1000);
			camera.extra.goTarget.x = camera.extra.goPosition.x;
			camera.extra.goTarget.y = camera.extra.goPosition.y;
			camera.extra.goTarget.z = camera.extra.goPosition.z;
			camera.target.x = camera.extra.goPosition.x;
			camera.target.y = camera.extra.goPosition.y;
			camera.target.z = camera.extra.goPosition.z-800;
			positionReached = false; 
		}
		
		override protected function setupScene():void
		{
			scene = new MovieScene3D(pv3dSprite);

			// Create camera
			camera = new Camera3D();
			camera.x = 0;
			camera.z = 2400;
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
				
				plane.z =  -_zOffset*(i)-800;
				plane.x = 400+_direction*_xOffset*i*Math.sin(-plane.z/2300);
				plane.y = _yOffset*i*Math.sin(plane.z/1000);
				plane.scaleY = 1;
				plane.scaleX = 1.3;
				plane.rotationY = 180;
				// ref plane
				refPlane.x = _direction*_xOffset*i;
				refPlane.z = -_zOffset*i;
				refPlane.y = plane.y -520;
				refPlane.scaleY = 1;
				refPlane.scaleX = 1.3;
				refPlane.rotationY = 180;
				
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
		
		override protected function doRollOver(event:Event):void
		{
			timer.stop()
		}
		
		override protected function doRollOut(event:Event):void
		{
			timer.start();	
		}
		
		override protected function doPress(event:Event):void
		{
			
		}
		
		override protected function onEnterFrame(event:Event):void
		{
			super.onEnterFrame(event);
			var target     :DisplayObject3D = camera.target;
			var goPosition :DisplayObject3D = camera.extra.goPosition;
			var goTarget   :DisplayObject3D = camera.extra.goTarget;
	
			camera.x -= (camera.x - goPosition.x) /32;
			camera.y -= (camera.y - goPosition.y) /32;
			camera.z -= (camera.z - goPosition.z) /32;
	
			target.x -= (target.x - goTarget.x) /32;
			target.y -= (target.y - goTarget.y) /32;
			target.z -= (target.z - goTarget.z) /32;
			//trace(camera.x+" "+camera.y+" "+camera.z);
			if(Math.abs((camera.x - goPosition.x) / 32) < 0.1 && !positionReached)
				{
					
					currentIndex++;
					positionReached = true;
				}
		}
		
	}
}