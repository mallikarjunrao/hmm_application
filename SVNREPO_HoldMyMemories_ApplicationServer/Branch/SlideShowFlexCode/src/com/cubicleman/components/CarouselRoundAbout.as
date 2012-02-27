/**
 * created from Canvas3D.as from the Papervision gurus extraordinaire!
 * credit is hereby given to them and this file follows teh MIT license as 
 * required.  

 * Credit to the Math and algorithm behind the scenes is given to 
 * Lee Brimelow see http://theflashblog.com/?p=293 for more info
 
 
The MIT License

Copyright (c) <year> <copyright holders>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

 **/

package com.cubicleman.components
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.effects.easing.Back;
	import flash.display.StageQuality;
	import flash.events.Event;
	import org.papervision3d.scenes.MovieScene3D;
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.Plane;
	import org.papervision3d.objects.DisplayObject3D;
	import mx.controls.Button;
	import flash.events.MouseEvent;
	import caurina.transitions.Tweener;
	import flash.filters.DropShadowFilter;
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.XMLListCollection;
	

	public class CarouselRoundAbout extends UIComponent
	{	
		private var paperSprite:Sprite;
		private var backgroundSprite:Sprite;
		private var clipRect:Rectangle;
		private var scene:MovieScene3D;
		private var camera:Camera3D;
		private var plane:DisplayObject3D;
		
		
		/** to be made available via accessors/mutators **/
		private var _backgroundColor:uint = 0x000000;
		private var _backgroundAlpha:Number = 1;
		private var _defaultCameraZoom:Number = 2;
		private var _dataProvider:Object;
		private var _radius:Number = 500;
		
		
		/** locals **/
		private var anglePer:Number;
		public var angleX:Number;
		private var numOfItems:Number;
		private var dest:Number = 1;
		private var dsf:DropShadowFilter;
		private var itemsDirty:Boolean = false;
		
		public function CarouselRoundAbout()
		{
			super();
			
			//no clue what this is for
			clipRect = new Rectangle();
			
			// Create camera
			camera = new Camera3D();
			camera.zoom = _defaultCameraZoom;

			//bkgrnd sprite for what?			
			backgroundSprite = new Sprite();
			backgroundSprite.cacheAsBitmap = true;
			
			//the main sprite
			paperSprite = new Sprite();
			paperSprite.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage );
			paperSprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//3D movie scene of the sprite ??
			scene = new MovieScene3D(paperSprite);
			
			dsf = new DropShadowFilter(10, 45, 0x000000, 0.3, 6, 6, 1, 3);
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			addChild(backgroundSprite);
			addChild(paperSprite);	
			
		}
		
		private function handleAddedToStage( event : Event) : void	{
			paperSprite.stage.quality = StageQuality.MEDIUM;
		}
		
		public function moveLeft( ) : void	{
			dest++;
			Tweener.addTween(this, {angleX:dest*anglePer, time:0.5});
			
		}

		public function moveRight( ) : void	{
			dest--;
			Tweener.addTween(this, {angleX:dest*anglePer, time:0.5});
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);		
			drawBackground();
			
			var hw:Number = unscaledWidth/2;
			var hh:Number = unscaledHeight/2;
			
			paperSprite.x = hw;
			paperSprite.y = hh;
			
			clipRect.x = 0;
			clipRect.y = 0;
			clipRect.width = unscaledWidth;
			clipRect.height = unscaledHeight;
			
			scrollRect = clipRect;
		}
		
		protected function drawBackground():void
		{
			if(backgroundSprite){
				var g:Graphics = backgroundSprite.graphics;
				g.clear();
				g.beginFill(backgroundColor, _backgroundAlpha);
				g.drawRect(0,0,unscaledWidth,unscaledHeight);
				g.endFill();
			}
		}
		
		public function set dataProvider(value:Object):void	{
			_dataProvider = value;
			
			if (value is Array)	{
                _dataProvider = new ArrayCollection(value as Array);
            }	else if (value is IList)	{
                _dataProvider = IList(value);
            }	else if (value is XMLList)	{
                _dataProvider = new XMLListCollection(value as XMLList);
            }
            
            itemsDirty = true;
            invalidateProperties();
            invalidateSize();
		}
		
		override protected function commitProperties():void	{
			
			if( itemsDirty )	{
				itemsDirty = false;
				
				for(var j:uint=1; j<=numOfItems; j++)	{
					scene.removeChild(scene.getChildByName("Plane" + j ) as DisplayObject3D);
				}
				dest = 1;
				
				numOfItems = _dataProvider.length;
				anglePer = (Math.PI*2) / numOfItems;
				angleX = anglePer;
				
				var bmp:BitmapFileMaterial;
				for(var i:uint=1; i<=numOfItems; i++)	{
					bmp = new BitmapFileMaterial(_dataProvider[i-1]);
					bmp.doubleSided = true;
					bmp.smooth = true;
					plane = scene.addChild( new Plane( bmp , 162, 230, 2, 2 ), "Plane" + i );
					plane.x = Math.cos(i*anglePer) * radius;
					plane.z = Math.sin(i*anglePer) * radius;
					plane.rotationY = (-i*anglePer) * (180/Math.PI) + 270;
					plane.container.filters = [dsf];
					
				}
			}
			
			invalidateDisplayList();
		}
		
		public function get dataProvider() : Object	{
			return _dataProvider;
		}
		
		public function set backgroundColor(bgColor:uint):void
		{
			_backgroundColor = bgColor;	
			drawBackground();
		}
		
		public function get backgroundColor():uint
		{
			return _backgroundColor;	
		}
		
		public function set backgroundAlpha(alpha:Number):void
		{
			_backgroundAlpha = alpha;
		}
		
		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;	
		}
		
		public function set radius(radius:Number):void
		{
			_radius = radius;
		}
		
		public function get radius():Number
		{
			return _radius;	
		}
		
		private function onEnterFrame( event :Event ):void	{
			camera.x = Math.cos(angleX) * 1000;					 
			camera.z = Math.sin(angleX) * 1000;
			this.scene.renderCamera( camera );
		}
	
	}
}
