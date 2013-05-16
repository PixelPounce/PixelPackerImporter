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
import nme.geom.Rectangle;


class AnimationSheet 
{
	private var _behaviours:Hash<Behaviour>;
	private var _sheet:BitmapData;
	public var rectangles:Array<Rectangle>;
	private var maxRectangleWidth(default, null):Float;
	private var maxRectangleHeight(default, null):Float;

	public function new(image:BitmapData) 
	{
		_behaviours = new Hash<Behaviour>();
		rectangles = new Array<Rectangle>();
		maxRectangleHeight = 0;
		maxRectangleWidth = 0;
		_sheet = image;
	}

	public function getBehaviour(name:String):Behaviour
	{
		return _behaviours.get(name);
	}
	
	public function addBehaviour(behaviour:Behaviour):Void
	{
		_behaviours.set(behaviour.name, behaviour);
	}

	public function addImageRect(rec:Rectangle) 
	{
		rectangles.push(rec);
		if (rec.width > maxRectangleWidth)
		{
			maxRectangleWidth = rec.width;
		}
		if (rec.height > maxRectangleHeight)
		{
			maxRectangleHeight = rec.height;
		}
	}
	
	public function getAllBehaviours():Hash<Behaviour>
	{
		return _behaviours;
	}
	
	public function getImage() 
	{
		return _sheet;
	}
	
}