package com
{
	import caurina.transitions.Tweener;
	
	import com.dougmccune.containers.CoverFlowContainer;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	import mx.core.EdgeMetrics;
	
	import org.papervision3d.objects.DisplayObject3D;

	public class TimeFlyByContainer extends CoverFlowContainer
	{
		public function TimeFlyByContainer()
		{
			//TODO: implement function
			tweenDuration = 8;
			super();
		}
		
		override protected function layoutChildren(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutChildren(unscaledWidth, unscaledHeight);
		}
		
		override protected function layoutCoverflow(uncaledWidth:Number, unscaledHeight:Number):void {
				
			var n:int = numChildren;
			
			for(var i:int=0; i<n; i++) {
				var child:DisplayObject = getChildAt(i);
				var plane:DisplayObject3D = lookupPlane(child);
				
				if(plane == null) {
					continue;
				}
				
				plane.container.visible = true;
				
				var abs:Number = Math.abs(selectedIndex - i);
				
				var horizontalGap:Number = getStyle("horizontalSpacing");
				if(isNaN(horizontalGap)) {
					//this seems to work fairly well as a default
					horizontalGap = maxChildHeight/3;
				}
				
				var verticalGap:Number = getStyle("verticalSpacing");
				if(isNaN(verticalGap)) {
					verticalGap = 10;
				}
				var radius : Number = 400;
				var theta : Number = 2* Math.PI/n;
				
				/* var xPosition:Number = selectedChild.width + ((abs-1) * horizontalGap) +200;
				var yPosition:Number = -(maxChildHeight - child.height)/2;
				var zPosition:Number = camera.z/2 + selectedChild.width + abs * verticalGap;
				camera.extra.goPosition.z =  -_zOffset*(currentIndex) + 800;	
				camera.extra.goPosition.x = 400+_direction*_xOffset*currentIndex*Math.sin(-camera.extra.goPosition.z/2300);
				camera.extra.goPosition.y = _yOffset*currentIndex*Math.sin(camera.extra.goPosition.z/1000);
				 */
				var zPosition:Number = camera.z/2 + selectedChild.width + abs * verticalGap*8;
				var xPosition:Number =   - (((abs) * horizontalGap)*Math.sin(-zPosition/500))*3 ;
				
				var yPosition:Number = -(maxChildHeight - child.height)/2 + (((abs-1) )*Math.sin(-zPosition/300))*60;
				if(zPosition > 1500)
				{
					xPosition = 1200;
					yPosition = 1200;
					plane.visible = false;
				}
				
				var yRotation:Number = 0;
				
				//some kinda fuzzy math here, I dunno, I was just playing with values
				//note that this only gets used if fadeEdges is true below
				var alpha:Number = (unscaledWidth/2 - xPosition) / (unscaledWidth/2);
				alpha  = Math.max(Math.min(alpha*2, 1), 0);
				
				if(i < selectedIndex) {
					//xPosition *= -1;
					//yRotation *= -1;
					zPosition = -205;
					xPosition = -70;
				}
				else if(i==selectedIndex) {
					xPosition = 0;
					zPosition = camera.z/2;
					yRotation = 0;
					alpha = 1;
				}
				if(zPosition > 1500)
				{
					//plane.visible = false;
					var reflection:DisplayObject3D = lookupReflection(child);
					reflection.visible = false;
				}	
				else if(zPosition > 700)
				{
					plane.visible = true;
					reflection= lookupReflection(child);
					reflection.visible = false;
				}else
				{
					plane.visible = true;
					reflection = lookupReflection(child);
					reflection.visible = true;	
				}	
				if(fadeEdges) {
					//here's something sneaky. PV3D applies the colorTransform of the source movie clip to the
					//bitmapData that's created. So if we adjust the colorTransform that will be shown in the
					//3D plane as well. Cool, huh?
					var colorTransform:ColorTransform  = child.transform.colorTransform;
					colorTransform.alphaMultiplier = alpha;
					child.transform.colorTransform = colorTransform;
					plane.material.updateBitmap();
				}
				
				if(reflectionEnabled) {
					reflection = lookupReflection(child);
					
					if(fadeEdges) {
						reflection.material.updateBitmap();
					}
					
					//drop the reflection down below the plane and put in a gap of 2 pixels. Why 2 pixels? I think it looks nice.
					reflection.y = yPosition - child.height - 2;
					
					if(i!=selectedIndex) {
						Tweener.addTween(reflection, {z:zPosition, time:tweenDuration/3});
						Tweener.addTween(reflection, {x:xPosition, rotationY:yRotation, time:tweenDuration});
					}
					else {
						Tweener.addTween(reflection, {x:xPosition, z:zPosition, rotationY:yRotation, time:tweenDuration});
					}
				}
				
				if(i!=selectedIndex) {
					Tweener.addTween(plane, {z:zPosition, time:tweenDuration});
					Tweener.addTween(plane, {x:xPosition, y:yPosition, rotationY:yRotation, time:tweenDuration});
				}
				else {
					Tweener.addTween(plane, {x:xPosition, y:yPosition, z:zPosition, rotationY:yRotation, time:tweenDuration});
				}
				
				if(i == selectedIndex) {
					var bm:EdgeMetrics = borderMetrics;
		
					//We need to adjust the location of the selected child so
					//it exactly lines up with where our 3D plane will be. 
					child.x = unscaledWidth/2 - child.width/2 - bm.top;
					child.y = unscaledHeight/2 - child.height/2 - yPosition - bm.left;
					
					//the normal ViewStack sets the visibility of the selectedChild. That's no good for us,
					//so we just reset it back. 
					child.visible = false;
				}
			}
		}
		
	}
}