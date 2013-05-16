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

import format.display.MovieClip;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.geom.Matrix;
import nme.geom.Point;

class Animation
{
	
	public var x:Float;
	public var y:Float;
	public var rotation:Float;
	public var alpha:Float;
	public var scale:Float;
	public var name(default, null):String;
	public var play:Bool;
	public var loop:Bool;
	private var _behavourName:String;
	private var _frame:Int;
	private var _isLastFrame:Bool;
	
	public function new(name:String) 
	{
		this.name = name;
		x = 0;
		y = 0;
		rotation = 0;
		alpha = 1;
		scale = 1;
		play = false;
		_isLastFrame = false;
		loop = false;
	}
	
	public function gotoAndPlay(behaviour:String)
	{
		_behavourName = behaviour;
		play = true;
	}
	
	public function gotoAndStop(behaviour:String)
	{
		_behavourName = behaviour;
		play = false;
	}
	
	public function getBehaviour():String
	{
		return _behavourName;
	}
	
	public function getFrame() 
	{
		return _frame;
	}
	
	public function setFrame(frame:Int)
	{
		_frame = frame;
	}
	
	public function isLastFrame():Bool
	{
		return _isLastFrame;
	}
	
	public function setLastFrame(val:Bool):Void
	{
		_isLastFrame = val;
	}
}