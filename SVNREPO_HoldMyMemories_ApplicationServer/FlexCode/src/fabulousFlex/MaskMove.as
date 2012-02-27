package fabulousFlex
{
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import mx.effects.AnimateProperty;
	import mx.effects.Move;
	import mx.core.UIComponent;
	import flash.geom.Point;
	
	import mx.events.EffectEvent;
	import mx.events.TweenEvent;
	import flash.geom.Rectangle;
	import mx.effects.easing.Circular;
	import mx.effects.easing.Back;
	import mx.effects.easing.Bounce;
	import mx.effects.easing.Sine;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * Core functionality of the Mask Move.
	 * Handles moving the mask over the component, according to user mouse move.
	 * */
	public class MaskMove extends UIComponent 
	{
		private var _target:DisplayObject = null;
		private var _isPlaying:Boolean = false;
		private var _move:Move = new Move();
		private var _lastPos:Point = null;
		private var _nextPos:Point = null;
		private var _curPoint:Point = null;
		private var _tickCount:int = 0;
		private var _moveDistance:int = 0;
		private var _mouseMoving:Boolean = false;
		private var _timer:Timer = new Timer(100);;
		private var _minDistance:int = 30;
		private var _minMoveTickCount:int = 2;
		
		/**
		 * @param target that is moved under the mask
		 */
		public function MaskMove(target:DisplayObject):void
		{
			super();
			if(target == null)
				throw new Error("target cannot be null");
			this._target = target;
			_target.parent.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			_target.parent.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			_target.parent.addEventListener(MouseEvent.ROLL_OUT,onRollOver);
			
			_move.duration = 2000;
			_move.addEventListener(EffectEvent.EFFECT_END,onEffectEnd);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		
		/** the minimum number of pixels (distance) the mouse has to go
		 *  for moving the target to trigger**/
		public function set minMoveDistance(val:int):void
		{
			_minDistance = val;
		}
		
		/** the minimum number of pixels (distance) the mouse has to go
		 *  for moving the target to trigger**/
		public function get minMoveDistance():int
		{
			return _minDistance;
		}
		
		/** The time in Milisecs until the move check is triggered.
		 * affects the time from user movement until move effect happens**/
		public function set responseTime(val:int):void
		{
			_timer.delay = val;
		}
		
		/** The time in Milisecs until the move check is triggered.
		 * affects the time from user movement until move effect happens**/
		public function get responseTime():int
		{
			return _timer.delay;
		}
		
		
		private function onEffectEnd(event:EffectEvent):void
		{
			_isPlaying = false;
			_nextPos = null;
			_moveDistance = 0;
			trace("image loc: " + _target.x + "," + _target.y);
		}
		
		/** The sensitivity of mouse movement effect triggering, <b>while</b>
		 *  mouse is moving**/
		public function get sensitivity():int
		{
			return _minMoveTickCount;
		}
		
		/** The sensitivity of mouse movement effect triggering, <b>while</b>
		 *  mouse is moving**/
		public function set sensitivity(val:int):void
		{
			_minMoveTickCount = val;
		}
		
		/** checks and triggers movment if needed**/
		private function onTimer(event:TimerEvent):void
		{
			var distance:int = getDistance(_lastPos,_curPoint);
			if(((!_mouseMoving)||(_tickCount > _minMoveTickCount))&&(distance > _minDistance))
			{
				handleMode(_lastPos,_curPoint);
				_lastPos = _curPoint.clone();
				_timer.stop();
				_tickCount = 0;
			}
			else
				_tickCount++;
			
			_mouseMoving = false;
		}
		
		public function stopMoveEffect():void
		{
			if(_isPlaying)
			{
				_move.pause();
				_move = new Move();
				_isPlaying = false;	
			}
		}
		
		/** handles the movement of the target under the mask,
		 *  fromPoint to toPoint**/
		private function handleMode(fromPoint:Point, toPoint:Point):void
		{
			stopMoveEffect();
			if(!_isPlaying)
			{
				_moveDistance = getDistance(toPoint,fromPoint);
				_nextPos = calcPosByQuadrent(_target,_moveDistance,_lastPos,_curPoint);
				/**
				 * check that target is still in bounds of parent mask.
				 * and if not adjust newPos to bound
				 */
				if(_nextPos.x > 0)
					_nextPos.x = 0;
				if(_nextPos.x + _target.width < _target.parent.width)
					_nextPos.x = _target.parent.width - _target.width;
				if(_nextPos.y > 0)
					_nextPos.y = 0;
				if(_nextPos.y + _target.height < _target.parent.height)
					_nextPos.y = _target.parent.height - _target.height;
				_move.xFrom = _target.x;
				_move.yFrom = _target.y;
				_move.xTo = _nextPos.x;
				_move.yTo = _nextPos.y;
				
				_move.duration = getDuration(_moveDistance);
				_move.easingFunction = Circular.easeOut;
				_move.play([_target]);
				_isPlaying = true;
				trace("moveTo: " + _move.xTo+ "," + _move.yTo);
				
			}	
		}
		
		
		private function onMouseMove(event:MouseEvent):void
		{
			
			_mouseMoving = true;
			_curPoint = new Point(event.stageX,event.stageY);
			if(_lastPos == null)
				_lastPos = _curPoint.clone();
			//start timer for move effect triggering check
			if(!_timer.running)
				_timer.start();
			
			
		}
		
		private function onRollOver(event:MouseEvent):void
		{
		
			_lastPos = new Point(event.stageX,event.stageY);
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			_timer.stop();
			_curPoint = new Point(event.stageX,event.stageY);
			handleMode(_lastPos,_curPoint);
		}
		
		
		private function getDuration(distance:int):int
		{
			return Math.max(distance*50,500);
		}
		
		/** calculate the distance between 2 points**/
		public static function getDistance(pos1:Point,pos2:Point):Number
		{
			
			var x:Number = Math.abs(pos1.x-pos2.x);
			var y:Number = Math.abs(pos1.y - pos2.y);
			return Math.sqrt(Math.pow(x,2) + Math.pow(y,2)); 
		}
		
		/**calculate where the next point to move to is.
		 * Basicaly, check what quadrent the current point is, relative to last
		 * and move to the last.
		 * movement is in 45 degree angle, unless movement falls in a small range
		 * arround the axises.
		 * **/
		private function calcPosByQuadrent(item:DisplayObject,distance:Number,
			last:Point,cur:Point):Point
		{
			var newPos:Point = new Point(0,0);
			
			var RANGE:int = 5;
			
			if((int(last.x) >= int(cur.x))&&(int(last.y) > int(cur.y)))
			{
				//tl
				if(cur.x > _lastPos.x - RANGE)
				{
					newPos.x = item.x;
					newPos.y = item.y - distance; 
				}
				else if(cur.y > _lastPos.y-RANGE)
				{
					newPos.x = item.x- distance;
					newPos.y = item.y; 
				}
				else
				{
					newPos.x = item.x- distance;
					newPos.y = item.y - distance; 
				}
			}
			else if((int(last.x) >= int(cur.x))&&(int(last.y) <= int(cur.y)))
			{
				//BL
				if(cur.x > _lastPos.x - RANGE)
				{
					newPos.x = item.x;
					newPos.y = item.y + distance; 
				}
				else if(cur.y < _lastPos.y + RANGE)
				{
					newPos.x = item.x - distance;
					newPos.y = item.y; 
				}
				else
				{
					newPos.x = item.x - distance;
					newPos.y = item.y + distance; 
				}
				
			}
			else if((int(last.x) <= int(cur.x))&&(int(last.y) <= int(cur.y)))
			{
				//BR
				if(cur.x < _lastPos.x + RANGE)
				{
					newPos.x = item.x;
					newPos.y = item.y + distance; 
				}
				else if(cur.y < _lastPos.y + RANGE)
				{
					newPos.x = item.x + distance;
					newPos.y = item.y; 
				}
				else
				{
					newPos.x = item.x + distance;
					newPos.y = item.y + distance; 
				}
			}
			else 
			{
				//TR
				if(cur.x < _lastPos.x + RANGE)
				{
					newPos.x = item.x;
					newPos.y = item.y - distance; 
				}
				else if(cur.y > _lastPos.y - RANGE)
				{
					newPos.x = item.x + distance;
					newPos.y = item.y; 
				}
				else
				{
					newPos.x = item.x + distance;
					newPos.y = item.y - distance; 
				}
			}
			return newPos;
		}

	}
}