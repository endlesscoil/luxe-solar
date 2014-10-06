package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil.LineStyle;
using flixel.util.FlxSpriteUtil;

class PlanetaryBody
    extends FlxGroup 
{
    public static var AU = 100;
    public static var BASE_SIZE = 20;
    public static var BASE_ORBITAL_PERIOD = 1;
    public static var PLANETS = {
        mercury: { distance: AU * 0.39, size: BASE_SIZE * 0.38, period: BASE_ORBITAL_PERIOD / 0.24 },
        venus: { distance: AU * 0.72, size: BASE_SIZE * 0.95, period: BASE_ORBITAL_PERIOD / 0.62 },
        earth: { distance: AU, size: BASE_SIZE, period: BASE_ORBITAL_PERIOD },
        mars: { distance: AU * 1.52, size: BASE_SIZE * 0.53, period: BASE_ORBITAL_PERIOD / 1.88 },
        jupiter: { distance: AU * 5.20, size: BASE_SIZE * 11.20, period: BASE_ORBITAL_PERIOD / 11.86 },
        saturn: { distance: AU * 9.58, size: BASE_SIZE * 9.45, period: BASE_ORBITAL_PERIOD / 29.46 },
        uranus: { distance: AU * 19.23, size: BASE_SIZE * 4.00, period: BASE_ORBITAL_PERIOD / 84.01 },
        neptune: { distance: AU * 30.10, size: BASE_SIZE * 3.88, period: BASE_ORBITAL_PERIOD / 164.8 },
        pluto: { distance: AU * 39.3, size: BASE_SIZE * 0.18, period: BASE_ORBITAL_PERIOD / 247.7 }
    }

    public var name : String = "Unknown";
    public var parent : PlanetaryBody = null;
    public var children : FlxTypedGroup<PlanetaryBody> = null;
    public var orbit_distance : Float = -1;
    public var size : Float = -1;
    public var color : Int = FlxColor.AQUAMARINE;
    public var angular_position : Float = 0;
    public var rotation_speed : Float = 0.0;
    public var rotation_direction : Int = 1;

    private var _sprite : FlxSprite = null;
    private var _pos_sprite : FlxSprite = null;
    private var _center_sprite : FlxSprite = null;
    private var _orbit_sprite : FlxSprite = null;

    public function new(Size : Float,
                        ?Name : String = "Unknown", 
                        ?Color : Int = FlxColor.AQUAMARINE, 
                        ?RotationSpeed : Float = 0.0, 
                        ?RotationDirection : Int = 1,
                        ?Debug : Bool = false) : Void
    {
        super();

        size = Size;
        name = Name;
        color = Color;
        rotation_speed = RotationSpeed;
        rotation_direction = RotationDirection;

        _orbit_sprite = new FlxSprite();
        //_orbit_sprite.makeGraphic(1, 1, FlxColor.TRANSPARENT, true);
        add(_orbit_sprite);

        _sprite = new FlxSprite();
        _sprite.makeGraphic(cast size, cast size, FlxColor.TRANSPARENT, true);
        _sprite.drawCircle(size / 2, size / 2, size / 2, color);

        children = new FlxTypedGroup<PlanetaryBody>();
        add(children);
        add(_sprite);

        if (Debug)
        {
            _pos_sprite = new FlxSprite();
            _pos_sprite.makeGraphic(3, 3, FlxColor.RED, true);
            add(_pos_sprite);

            _center_sprite = new FlxSprite();
            _center_sprite.makeGraphic(3, 3, FlxColor.RED, true);
            add(_center_sprite);
        }
        
        trace('$name ${_sprite}');
    }

    public override function update() : Void
    {
        super.update();

        rotate();

        children.forEach(function(body : PlanetaryBody) : Void {
                //body.set_center_position(FlxPoint.weak(_position.x + size / 2, _position.y + size / 2));
                //body.set_center_position(FlxPoint.weak(_center_position.x, _center_position.y));
                //body.set_position(FlxPoint.weak(_center_position.x - body.orbit_distance - body.size / 2, _center_position.y - body.size / 2));

                //body.update();
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

        angular_position += rotation_speed * rotation_direction;
        if (angular_position > 359)
            angular_position = 0;
        destination_point = FlxAngle.rotatePoint(parent.center_position.x - orbit_distance, parent.center_position.y, parent.center_position.x, parent.center_position.y, angular_position);
    
        set_center_position(destination_point);
    }

    public function add_child(Child : PlanetaryBody, Orbit : Float) : Void
    {
        Child.set_center_position(FlxPoint.weak(_center_position.x - Orbit - size / 2, _center_position.y - Orbit - size / 2));
        Child.set_orbit(this, Orbit);

        trace('add_child: ${Child.name} - orbit=$Orbit, center=${Child.center_position}');
        children.add(Child);
    }

    public function set_orbit(Parent : PlanetaryBody, Orbit : Float)
    {
        orbit_distance = Orbit;
        parent = Parent;

        _orbit_sprite.x = parent.center_position.x - Orbit;
        _orbit_sprite.y = parent.center_position.y - Orbit;
        _orbit_sprite.makeGraphic(cast orbit_distance * 2 + 2, cast orbit_distance * 2 + 2, FlxColor.TRANSPARENT, true);
        _orbit_sprite.drawCircle(orbit_distance + 1, orbit_distance + 1, orbit_distance, FlxColor.TRANSPARENT, { color: FlxColor.GRAY, thickness: 2 }, { color: FlxColor.TRANSPARENT });

        trace('set_orbit: ${name} - orbit=$Orbit - sprite pos=${_orbit_sprite.x}, ${_orbit_sprite.y} size=${_orbit_sprite.width}, ${_orbit_sprite.height}, radius=${orbit_distance*2}');

//        add(_orbit_sprite);
    }

    public var center_position(get_center_position, set_center_position):FlxPoint;
    private var _center_position : FlxPoint = FlxPoint.weak(0, 0);
    
    function get_center_position():FlxPoint { return _center_position; }
    function set_center_position(value:FlxPoint):FlxPoint
    {
        _sprite.x = value.x - size / 2;
        _sprite.y = value.y - size / 2;

        if (_pos_sprite != null)
        {
            _pos_sprite.x = value.x - size / 2;
            _pos_sprite.y = value.y - size / 2;
        }

        if (_center_sprite != null)
        {
            _center_sprite.x = value.x;
            _center_sprite.y = value.y;
        }

        if (_orbit_sprite != null && parent != null && parent.rotation_speed > 0)
        {
            _orbit_sprite.x = parent.center_position.x - orbit_distance - 1;
            _orbit_sprite.y = parent.center_position.y - orbit_distance - 1;
        }

        return _center_position = value;
    }
}