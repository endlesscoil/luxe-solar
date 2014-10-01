package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxAngle;
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
    public var angular_position : Float = 0;
    public var rotation_speed : Float = 0.0;

    private var _sprite : FlxSprite = null;
    private var _center_sprite : FlxSprite = null;

    public function new(Size : Int, ?Name : String = "Unknown", ?Color : Int = FlxColor.AQUAMARINE, ?RotationSpeed : Float = 0.0, ?Debug : Bool = false) : Void
    {
        super();

        size = Size;
        name = Name;
        color = Color;
        rotation_speed = RotationSpeed;

        _sprite = new FlxSprite(FlxG.width / 2, FlxG.height / 2);
        _sprite.makeGraphic(size, size, FlxColor.TRANSPARENT, true);
        _sprite.drawCircle(size / 2, size / 2, size / 2, color);
        add(_sprite);

        if (Debug)
        {
            _center_sprite = new FlxSprite();
            _center_sprite.makeGraphic(3, 3, FlxColor.RED, true);
            //_center_sprite.x = _center_position.x;
            //_center_sprite.y = _center_position.y;
            add(_center_sprite);
        }

        children = new FlxTypedGroup<PlanetaryBody>();
        add(children);

        trace('$name ${_sprite}');
    }

    public override function update() : Void
    {
        super.update();

        //trace('$name: ${_sprite.x}, ${_sprite.y} - ${_position} ${_center_position}');

        rotate();

        children.forEach(function(body : PlanetaryBody) : Void {
                body.set_center_position(FlxPoint.weak(_position.x + size / 2, _position.y + size / 2));

                body.update();
            });
    }

    public override function destroy() : Void
    {
        super.destroy();
    }

    public function rotate() : Void
    {
        var destination_point:FlxPoint = null;

        if (orbit_distance <= 0)
            return;

        angular_position += rotation_speed;
        if (angular_position > 359)
            angular_position = 0;
        destination_point = FlxAngle.rotatePoint(_center_position.x, _center_position.y - orbit_distance - size, _center_position.x, _center_position.y, angular_position);
    
        set_position(destination_point);

        trace('angle: ${angular_position} $destination_point');
    }

    public function add_child(Child : PlanetaryBody, Orbit : Int) : Void
    {
        Child.orbit_distance = Orbit;
        Child.set_center_position(FlxPoint.weak(_center_position.x + size / 2, _center_position.y + size / 2));
        Child.set_position(FlxPoint.weak(_center_position.x - Orbit + Child.size / 2, _center_position.y + Child.size / 2));
        Child.parent = this;
        children.add(Child);
    }

    public var position(get_position, set_position) : FlxPoint;
    private var _position : FlxPoint = FlxPoint.weak(0, 0);
    
    function get_position() : FlxPoint { return _position; }
    function set_position(value : FlxPoint) : FlxPoint
    {
        _sprite.x = value.x;
        _sprite.y = value.y;

        center_position = FlxPoint.weak(value.x + size / 2, value.y + size / 2);

        return _position = value;
    }

    public var center_position(get_center_position, set_center_position):FlxPoint;
    private var _center_position : FlxPoint = FlxPoint.weak(0, 0);
    
    function get_center_position():FlxPoint { return _center_position; }
    function set_center_position(value:FlxPoint):FlxPoint
    {
        if (_center_sprite != null)
        {
            _center_sprite.x = value.x;
            _center_sprite.y = value.y;
        }

        return _center_position = value;
    }
}