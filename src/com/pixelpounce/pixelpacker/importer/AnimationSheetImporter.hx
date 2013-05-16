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

package com.pixelpounce.pixelpacker.importer;

import com.pixelpounce.pixelpacker.AnimationSheet;
import com.pixelpounce.pixelpacker.TextureAtlasTile;
import com.pixelpounce.pixelpacker.TileFrameData;
import com.pixelpounce.pixelpacker.TileFrameDataCollection;
import haxe.xml.Fast;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.geom.Matrix;
import nme.geom.Rectangle;

class AnimationSheetImporter 
{
	private static inline var DEGREES_TO_RADIANS:Float = 0.0174532925;

	public static function parse(data:String, image:BitmapData):AnimationSheet 
	{
		var xml:Xml = Xml.parse(data);
		var spriteSheetNode:Xml = xml.firstElement ();
		var fast = new haxe.xml.Fast(xml.firstElement ());
		var animationSheet:AnimationSheet = new AnimationSheet(image);
		
		
		for ( rec in fast.node.bin.nodes.rec ) 
		{
			var rectangle = new Rectangle(Std.parseFloat(rec.att.x), Std.parseFloat(rec.att.y), Std.parseFloat(rec.att.w), Std.parseFloat(rec.att.h));
			animationSheet.addImageRect(rectangle);
		}
		
		for (behaviourXML in fast.nodes.behaviour)
		{
			var behaviour:Behaviour = new Behaviour(behaviourXML.att.name,Std.parseInt(behaviourXML.node.registration.att.x),Std.parseInt(behaviourXML.node.registration.att.y));
			animationSheet.addBehaviour(behaviour);
		
			for ( frame in behaviourXML.node.frames.nodes.frame ) 
			{
				var tileFrameCollection:TileFrameDataCollection = new TileFrameDataCollection();
				
				var frameDataList = frame.nodes.frameData;
				
				for (frameData in frameDataList)
				{
					var spriteFrame:TileFrameData = new TileFrameData();
					spriteFrame.alpha = Std.parseFloat(frameData.att.alpha);
					spriteFrame.rotation = Std.parseFloat(frameData.att.rotation);
					spriteFrame.scaleX = Std.parseFloat(frameData.att.scaleX);
					spriteFrame.scaleY = Std.parseFloat(frameData.att.scaleY);
					spriteFrame.x = Std.parseFloat(frameData.att.x);
					spriteFrame.y = Std.parseFloat(frameData.att.y);
						
					spriteFrame.tile = new TextureAtlasTile(Std.parseInt(frameData.att.sID),Std.parseFloat(frameData.att.ssX), Std.parseFloat(frameData.att.ssY), Std.parseFloat(frameData.att.ssW), Std.parseFloat(frameData.att.ssH));

					var matrix:Matrix = new Matrix();
					var mA = Std.parseFloat(frameData.att.mA);
					var mD = Std.parseFloat(frameData.att.mD);

			
					if (mA < 0 && mD >0)
					{
						matrix.scale(spriteFrame.scaleX, -spriteFrame.scaleY);
						matrix.rotate( (spriteFrame.rotation) * DEGREES_TO_RADIANS );
					}
					else if (mA > 0 && mD <0)
					{
						matrix.scale(spriteFrame.scaleX, -spriteFrame.scaleY);
						matrix.rotate((spriteFrame.rotation) * DEGREES_TO_RADIANS);
					}
					else
					{
						matrix.scale(spriteFrame.scaleX, spriteFrame.scaleY);
						matrix.rotate( -(spriteFrame.rotation) * DEGREES_TO_RADIANS );
					}

					spriteFrame.a = matrix.a;
					spriteFrame.b = matrix.b;
					spriteFrame.c = matrix.c;
					spriteFrame.d = matrix.d;
			
					tileFrameCollection.frameData.push(spriteFrame);
				}
				
				behaviour.frames.push(tileFrameCollection);
			}
		
		}

		return animationSheet;
	}
}