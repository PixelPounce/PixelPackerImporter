/*
 * Pixel Packer
 *
 * Copyright (c) 2013 Pixel Pounce Pty Ltd
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.pixelpounce.pixelpacker;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.Lib;
import nme.events.Event;

class AnimationStage extends Sprite
{
	private var _canvas:Canvas;
	private var _children:Hash<Animation>;
	private var _animationSheet:AnimationSheet;
	private static inline var DEGREES_TO_RADIANS:Float = 0.0174532925;

	public function new(animationSheet:AnimationSheet) 
	{
		super();
		_canvas = new Canvas(animationSheet.rectangles,animationSheet.getImage());
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		_animationSheet = animationSheet;
		_children = new Hash<Animation>();
	}
	
	private function onEnterFrame(e:Event):Void 
	{
		for (child in _children)
		{
			process(child);
		}
		
		_canvas.draw(this.graphics);
	}
	
	
	private function process(child:Animation):Void
	{
		var behaviour:Behaviour = _animationSheet.getBehaviour(child.getBehaviour());
		var frame:Int = child.getFrame();
		var tileFrameCollection:TileFrameDataCollection = behaviour.getTileFrameDataCollection(frame);

		for (spriteFrame in tileFrameCollection.frameData)
		{
			var m:Matrix = new Matrix();
			m.tx = spriteFrame.x;
			m.ty = spriteFrame.y;
			m.a = spriteFrame.a;
			m.b = spriteFrame.b;
			m.c = spriteFrame.c;
			m.d = spriteFrame.d;
			
			var rM:Matrix = new Matrix();
			
			var center:Point = new Point(behaviour.origin.x,behaviour.origin.y);
			var displacement:Point = new Point(spriteFrame.x * child.scale, spriteFrame.y * child.scale);
			
			var rotatedPoint:Point;
			
			if ((spriteFrame.a < 0 && spriteFrame.d > 0) || (spriteFrame.a > 0 && spriteFrame.d < 0))
			{
				rotatedPoint = rotateAroundPoint(displacement, center,-child.rotation);
				rM.rotate(( -child.rotation) * DEGREES_TO_RADIANS);
			}
			else
			{
				rotatedPoint = rotateAroundPoint(displacement, center, -child.rotation);
				rM.rotate(child.rotation * DEGREES_TO_RADIANS);
			}
			
			rM.scale(child.scale, child.scale);
			m.concat(rM);
			
			_canvas.renderSprite(spriteFrame.tile.id, rotatedPoint.x+child.x, rotatedPoint.y+child.y, m.a, m.b, m.c, m.d, spriteFrame.alpha*child.alpha);
			
		}
		
		if (child.play == true)
		{
			frame++;
			child.setFrame(frame);
			if (frame>= behaviour.frames.length)
			{
				child.setLastFrame(true);
				
				if (child.loop == true)
				{
					child.setFrame(0);
				}
				else
				{
					child.setFrame(behaviour.frames.length-1);
				}
			}
			else
			{
				child.setLastFrame(false);
			}
		}
		
	}
	
	public function rotateAroundPoint(p:Point, cp:Point, rotation:Float):Point
	{
		var dx:Float = p.x - cp.x;
		var dy:Float = p.y - cp.y;
		
		var radius:Float =  Math.sqrt(dx * dx + dy * dy);
		
		var currentAngle:Float = Math.atan2(dy, dx);
		
		currentAngle += (rotation * DEGREES_TO_RADIANS);
		
		var nx:Float = Math.cos(currentAngle) * radius;
		var ny:Float = Math.sin(currentAngle) * radius;
		
		nx += cp.x;
		ny += cp.y;
		
		return new Point(nx, ny);
		
	}

	public function addMovieClip(child:Animation)
	{
		_children.set(child.name, child);
	}
	
	public function removeMovieClip(child:Animation)
	{
		_children.remove(child.name);
	}
}