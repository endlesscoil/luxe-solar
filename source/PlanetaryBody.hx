package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxPoint;

using flixel.util.FlxSpriteUtil;
using MySpriteUtil.MySpriteUtil;

class PlanetaryBody
    extends FlxGroup 
{
    public static var AU = 50;
    public static var BASE_SIZE = 40;
    public static var BASE_ORBITAL_PERIOD = 0.75;

    /*
    public static var PLANETS = {
        mercury: { distance: AU * 0.39, size: BASE_SIZE * 0.38, period: BASE_ORBITAL_PERIOD / 0.24 },
        venus: { distance: AU * 0.72, size: BASE_SIZE * 0.95, period: BASE_ORBITAL_PERIOD / 0.62 },
        earth: { distance: AU, size: BASE_SIZE, period: BASE_ORBITAL_PERIOD },
        mars: { distance: AU * 1.52, size: BASE_SIZE * 0.53, period: BASE_ORBITAL_PERIOD / 1.88 },
        jupiter: { distance: AU * 5.20, size: BASE_SIZE * 11.20 * 0.25, period: BASE_ORBITAL_PERIOD / 11.86 * 0.25 },
        saturn: { distance: AU * 9.58, size: BASE_SIZE * 9.45 * 0.25, period: BASE_ORBITAL_PERIOD / 29.46 * 0.25 },
        uranus: { distance: AU * 19.23, size: BASE_SIZE * 4.00, period: BASE_ORBITAL_PERIOD / 84.01 * 0.25 },
        neptune: { distance: AU * 30.10, size: BASE_SIZE * 3.88, period: BASE_ORBITAL_PERIOD / 164.8 * 0.25 },
        pluto: { distance: AU * 39.3, size: BASE_SIZE * 0.18, period: BASE_ORBITAL_PERIOD / 247.7 * 0.25 }
    }
    */

    public static var PLANETS = {
        mercury: { distance: AU * 1, size: BASE_SIZE * 0.5 * 0.5, period: BASE_ORBITAL_PERIOD / 0.24 },
        venus: { distance: AU * 2, size: BASE_SIZE * 0.5 * 0.95, period: BASE_ORBITAL_PERIOD / 0.62 },
        earth: { distance: AU * 3, size: BASE_SIZE * 0.5, period: BASE_ORBITAL_PERIOD },
        mars: { distance: AU * 4, size: BASE_SIZE * 0.5 * 0.7, period: BASE_ORBITAL_PERIOD / 1.88 },
        jupiter: { distance: AU * 5, size: BASE_SIZE, period: BASE_ORBITAL_PERIOD / 11.86 },
        saturn: { distance: AU * 6, size: BASE_SIZE * 0.9, period: BASE_ORBITAL_PERIOD / 29.46 },
        uranus: { distance: AU * 7, size: BASE_SIZE * 0.8, period: BASE_ORBITAL_PERIOD / 84.01 },
        neptune: { distance: AU * 8, size: BASE_SIZE * 0.7, period: BASE_ORBITAL_PERIOD / 164.8 },
        pluto: { distance: AU * 9, size: BASE_SIZE * 0.5 * 0.4, period: BASE_ORBITAL_PERIOD / 247.7 }
    }

    public var name : String = "Unknown";
    public var size : Float = -1;
    public var color : Int = FlxColor.AQUAMARINE;
    public var angular_position : Float = 0;
    public var rotation_speed : Float = 0.0;
    public var rotation_direction : Int = 1;

    public var parent : PlanetaryBody = null;
    public var orbit_distance : Float = -1;
    public var children : FlxTypedGroup<PlanetaryBody> = null;

    public var center_position(get_center_position, set_center_position) : FlxPoint;

    private var _center_position : FlxPoint = FlxPoint.weak(0, 0);
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
    }

    public override function update() : Void
    {
        super.update();

        rotate();
    }

    public override function destroy() : Void
    {
        super.destroy();

        _sprite = FlxDestroyUtil.destroy(_sprite);
        _pos_sprite = FlxDestroyUtil.destroy(_pos_sprite);
        _center_sprite = FlxDestroyUtil.destroy(_center_sprite);
        _orbit_sprite = FlxDestroyUtil.destroy(_orbit_sprite);
        children = FlxDestroyUtil.destroy(children);
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
    
        // TODO: Seems to be a memory leak in flash.. I have a suspicion it's here.  Try FlxPoint.weak().
        set_center_position(destination_point);
    }

    public function add_child(Child : PlanetaryBody, Orbit : Float) : Void
    {
        Child.parent = this;
        Child.orbit_distance = Orbit;
        Child.set_center_position(FlxPoint.weak(_center_position.x - Orbit - size / 2, _center_position.y - Orbit - size / 2));

        if (_orbit_sprite == null)
        {
            _orbit_sprite = new FlxSprite();
            // TODO: Fix me.. definitely need to make this sane.
            _orbit_sprite.makeGraphic(8000, 8000, FlxColor.TRANSPARENT, true);
            _orbit_sprite.setPosition(-4000 + FlxG.width/2, -4000 + FlxG.height/2);

            add(_orbit_sprite);
        }

        _orbit_sprite.drawCircleClean(_orbit_sprite.width / 2, _orbit_sprite.height / 2, Orbit);

        children.add(Child);
    }

    private function get_center_position() : FlxPoint { return _center_position; }
    private function set_center_position(value : FlxPoint) : FlxPoint
    {
        _sprite.setPosition(value.x - size / 2, value.y - size / 2);

        if (_pos_sprite != null)
            _pos_sprite.setPosition(value.x - size / 2, value.y - size / 2);

        if (_center_sprite != null)
            _center_sprite.setPosition(value.x, value.y);

        if (_orbit_sprite != null && parent != null && parent.rotation_speed > 0)
            _orbit_sprite.setPosition(parent.center_position.x - orbit_distance - 1);

        return _center_position = value;
    }
}