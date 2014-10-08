
package ;

import flash.display.LineScaleMode;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
using flixel.util.FlxSpriteUtil;
using flixel.util.FlxColorUtil;

class MySpriteUtil
{
    public static function drawCircleClean(sprite : FlxSprite, X : Float = -1, Y : Float = -1, Radius : Float = -1)
    {
    	var lineStyle : LineStyle = { color: FlxColor.GRAY, thickness: 2 };

    	// NOTE: Unintended side effect by multiplying the alpha float by 0.25.. fades out each following line.
    	// 		 Should probably fix it, but it's a neat effect.
    	FlxSpriteUtil.flashGfx.lineStyle(lineStyle.thickness, lineStyle.color & 0xffffff, 0.25 * FlxColorUtil.getAlphaFloat(lineStyle.color), true/*lineStyle.pixelHinting*/, LineScaleMode.NONE /*lineStyle.scaleMode*/, lineStyle.capsStyle, lineStyle.jointStyle, lineStyle.miterLimit);
    	FlxSpriteUtil.flashGfx.drawCircle(X, Y, Radius);
    	sprite.endDraw();
    }
}