
package ;

import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColorUtil;
using flixel.util.FlxSpriteUtil;

class MySpriteUtil
{
    public static function drawCircle(sprite : FlxSprite, X : Float = -1, Y : Float = -1, Radius : Float = -1, FillColor : Int = FlxColor.WHITE, ?lineStyle : LineStyle, ?drawStyle : DrawStyle)
    {
        var flashGfxSprite : Sprite = new Sprite();
        var flashGfx : Graphics = flashGfxSprite.graphics;

        flashGfx.lineStyle(lineStyle.thickness, lineStyle.color & 0xffffff, FlxColorUtil.getAlphaFloat(lineStyle.color), lineStyle.pixelHinting, lineStyle.scaleMode, lineStyle.capsStyle, lineStyle.jointStyle, lineStyle.miterLimit);
        flashGfx.drawCircle(X, Y, Radius);

        if (drawStyle == null)
            drawStyle = { smoothing: false };

        sprite.pixels.draw(flashGfxSprite, drawStyle.matrix, drawStyle.colorTransform, drawStyle.blendMode, drawStyle.clipRect, drawStyle.smoothing);
        sprite.dirty = true;
        sprite.resetFrameBitmapDatas();
    }

    public static function generate_perlin_sphere(radius : Float, octaves : Int, color_mask : UInt) : FlxSprite
    {
        var width : Int = Math.ceil(radius * 2) + 2;
        var height : Int = Math.ceil(radius * 2) + 2;

        var img_perlin : FlxSprite = new FlxSprite();
        img_perlin.makeGraphic(width, height, FlxColor.TRANSPARENT);
        img_perlin.pixels.perlinNoise(width, height, octaves, Std.random(1000), true, false);

        var img_mask : FlxSprite = new FlxSprite();
        img_mask.makeGraphic(width, height, 0x00FFFFFF);
        img_mask.drawCircle(width / 2, height / 2, radius, 0xFF000000);

        var img_out : FlxSprite = new FlxSprite();
        img_out.makeGraphic(width, height, FlxColor.TRANSPARENT);
        img_perlin.alphaMaskFlxSprite(img_mask, img_out);

        var ct = get_color_transform(color_mask);
        img_out.setColorTransform(ct.red, ct.green, ct.blue);

        return img_out;
    }

    private static function get_color_transform(color : UInt) : Dynamic
    {
        return { 
            red: ((color & 0x00FF0000) >> 16) / 255, 
            green: ((color & 0x0000FF00) >> 8) / 255, 
            blue: (color & 0x000000FF) / 255 
        };
    }
}