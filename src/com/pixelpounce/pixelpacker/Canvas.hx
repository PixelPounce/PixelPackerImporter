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
import nme.display.Graphics;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Vector;


class Canvas
{
	private var _drawList:Array<Float>;
	private var _tilesheet:Tilesheet;
	public var smooth:Bool;
	public var rootSpriteNode:String;


	public function new(rectangles:Array<Rectangle>,image:BitmapData) 
	{
		smooth = true;
		_drawList = new Array<Float>();
		_tilesheet = new Tilesheet(image);
		

		for (imageRec in rectangles)
		{
			//prevents lines flickering on the edge of the textures
			//Assuming animation has been exported with padding then nothing important will be cut off
			imageRec.x += 1;
			imageRec.y += 1;
			imageRec.width -= 2;
			imageRec.height -= 2;
			_tilesheet.addTileRect(imageRec,new Point(imageRec.width/2,imageRec.height/2));
		}
	}

	
	public function renderSprite(id:Int,x:Float,y:Float,a:Float, b:Float, c:Float, d:Float,alpha:Float):Void
	{
		var index:Int = _drawList.length;
		_drawList[index] = x;
		_drawList[index + 1] = y;
		_drawList[index + 2] = id;
		_drawList[index + 3] = a;
		_drawList[index + 4] = b; 
		_drawList[index + 5] = c; 
		_drawList[index + 6] = d;
		_drawList[index + 7] = alpha; 
	}
	
	public function draw(graphics:Graphics):Void
	{
		graphics.clear();
		_tilesheet.drawTiles(graphics, _drawList, smooth, Tilesheet.TILE_TRANS_2x2 | Tilesheet.TILE_ALPHA);
		_drawList = new Array<Float>();
	}
	

}