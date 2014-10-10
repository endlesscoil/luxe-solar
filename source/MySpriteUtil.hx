
package ;

import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColorUtil;

class MySpriteUtil
{
    public static function drawCircle(sprite : FlxSprite, X : Float = -1, Y : Float = -1, Radius : Float = -1, FillColor : Int = FlxColor.WHITE, ?lineStyle : LineStyle, ?drawStyle : DrawStyle)
    {
        var _flashGfxSprite : Sprite = new Sprite();
        var _flashGfx : Graphics = _flashGfxSprite.graphics;

        _flashGfx.lineStyle(lineStyle.thickness, lineStyle.color & 0xffffff, FlxColorUtil.getAlphaFloat(lineStyle.color), lineStyle.pixelHinting, lineStyle.scaleMode, lineStyle.capsStyle, lineStyle.jointStyle, lineStyle.miterLimit);
        _flashGfx.drawCircle(X, Y, Radius);
        
        if (drawStyle == null)
        {
            drawStyle = { smoothing: false };
        }

        sprite.pixels.draw(_flashGfxSprite, drawStyle.matrix, drawStyle.colorTransform, 
            drawStyle.blendMode, drawStyle.clipRect, drawStyle.smoothing);
        sprite.dirty = true;
        sprite.resetFrameBitmapDatas();
    }
}