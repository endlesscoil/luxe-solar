package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
using flixel.util.FlxSpriteUtil;

class PlanetaryBody
    extends FlxGroup 
{
    public var name : String = "Unknown";
    public var parent : PlanetaryBody = null;
    public var children : FlxTypedGroup<PlanetaryBody> = null;
    public var orbit_distance : Int = -1;
    public var size : Int = -1;
    public var color : Int = FlxColor.AQUAMARINE;

    private var _sprite : FlxSprite = null;

    public function new(Size : Int, ?Name : String = "Unknown", ?Color : Int = FlxColor.AQUAMARINE) : Void
    {
        super();

        size = Size;
        name = Name;
        color = Color;

        _sprite = new FlxSprite(FlxG.width / 2, FlxG.height / 2);
        _sprite.makeGraphic(size, size, FlxColor.TRANSPARENT, true);
        _sprite.drawCircle(size / 2, size / 2, size / 2, color);
        add(_sprite);

        children = new FlxTypedGroup<PlanetaryBody>();
        add(children);

        trace('$name ${_sprite}');
    }

    public override function update() : Void
    {
        super.update();

        trace('$name: ${_sprite.x}, ${_sprite.y} - ${_position}');
        _position.x = _sprite.x;
        _position.y = _sprite.y;

        if (orbit_distance != -1)
        {
            _center_position.x = parent._position.x;
            _center_position.y = parent._position.y;

            trace('$name orbit $orbit_distance');
        }

/*        children.forEach(function( body : PlanetaryBody) : Void {
                body.set_position(_position);

                body.update();
            });*/
    }

    public override function destroy() : Void
    {
        super.destroy();
    }

    public function add_child(Child : PlanetaryBody, Orbit : Int) : Void
    {
        Child.orbit_distance = Orbit;
        Child.set_center_position(FlxPoint.weak(_position.x + size / 2, _position.y + size / 2));
        Child.set_position(FlxPoint.weak(_center_position.x - Orbit, _center_position.y));
        Child.parent = this;
        children.add(Child);

        Child.start_rotation(Orbit);
    }

    public function start_rotation(Radius : Float) : Void
    {
        FlxTween.circularMotion(_sprite, _center_position.x, _center_position.y, Radius, 0, false, 40, false, { type: FlxTween.LOOPING });
    }

    public var position(get_position, set_position) : FlxPoint;
    private var _position : FlxPoint;
    
    function get_position() : FlxPoint { return _position; }
    function set_position(value : FlxPoint) : FlxPoint
    {
        _sprite.x = value.x;
        _sprite.y = value.y;

        return _position = value;
    }

    public var center_position(get_center_position, set_center_position):FlxPoint;
    private var _center_position:FlxPoint;
    
    function get_center_position():FlxPoint { return _center_position; }
    function set_center_position(value:FlxPoint):FlxPoint
    {
        return _center_position = value;
    }
}