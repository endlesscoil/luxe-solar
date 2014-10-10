
package ;

import flash.display.LineScaleMode;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
using flixel.util.FlxSpriteUtil;
using flixel.util.FlxColorUtil;

class MySpriteUtil
{
    public static function myDrawCircle(sprite : FlxSprite, X : Float = -1, Y : Float = -1, Radius : Float = -1, FillColor : Int = FlxColor.WHITE, ?lineStyle : LineStyle, ?drawStyle : DrawStyle)
    {                
        var lineStyle : LineStyle = { color: FlxColor.GRAY & 0x22FFFFFF, thickness: 2, pixelHinting: true, scaleMode: LineScaleMode.NONE };

        FlxSpriteUtil.flashGfx.lineStyle(lineStyle.thickness, lineStyle.color & 0xffffff, FlxColorUtil.getAlphaFloat(lineStyle.color), lineStyle.pixelHinting, lineStyle.scaleMode, lineStyle.capsStyle, lineStyle.jointStyle, lineStyle.miterLimit);
        FlxSpriteUtil.flashGfx.drawCircle(X, Y, Radius);
        sprite.endDraw();
    }
}