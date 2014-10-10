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

typedef PlanetSpec = { distance : Float, size: Float, period : Float, direction: Int }

class PlanetaryBody
    extends FlxGroup 
{
    public static var AU : Float = 50;
    public static var BASE_SIZE : Float = 40;
    public static var BASE_ORBITAL_PERIOD : Float = 0.75;

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
        mercury: { distance: AU * 1, size: BASE_SIZE * 0.5 * 0.5, period: BASE_ORBITAL_PERIOD / 0.24, direction: 1 },
        venus: { distance: AU * 2, size: BASE_SIZE * 0.5 * 0.95, period: BASE_ORBITAL_PERIOD / 0.62, direction: 1 },
        earth: { distance: AU * 3, size: BASE_SIZE * 0.5, period: BASE_ORBITAL_PERIOD, direction: 1 },
        mars: { distance: AU * 4, size: BASE_SIZE * 0.5 * 0.7, period: BASE_ORBITAL_PERIOD / 1.88, direction: 1 },
        jupiter: { distance: AU * 5, size: BASE_SIZE, period: BASE_ORBITAL_PERIOD / 11.86, direction: 1 },
        saturn: { distance: AU * 6, size: BASE_SIZE * 0.9, period: BASE_ORBITAL_PERIOD / 29.46, direction: 1 },
        uranus: { distance: AU * 7, size: BASE_SIZE * 0.8, period: BASE_ORBITAL_PERIOD / 84.01, direction: 1 },
        neptune: { distance: AU * 8, size: BASE_SIZE * 0.7, period: BASE_ORBITAL_PERIOD / 164.8, direction: 1 },
        pluto: { distance: AU * 9, size: BASE_SIZE * 0.5 * 0.4, period: BASE_ORBITAL_PERIOD / 247.7, direction: 1 }
    }

    public var name : String = "Unknown";
    public var size : Float = -1;
    public var color(get_color, set_color) : Int;
    private var _color : Int = FlxColor.AQUAMARINE;
    public var angular_position : Float = 0;
    public var rotation_speed : Float = 0;
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

    private var _debug : Bool = false;

/*
    public function new(Size : Float,
                        ?Name : String = "Unknown", 
                        ?Color : Int = FlxColor.AQUAMARINE, 
                        ?RotationSpeed : Float = 0.0, 
                        ?RotationDirection : Int = 1,
                        ?Debug : Bool = false) : Void
*/
    public function new(Spec : PlanetSpec, ?Debug : Bool = false)
    {
        super();

        size = Spec.size;
        orbit_distance = Spec.distance;
        rotation_speed = Spec.period;
        rotation_direction = Spec.direction;

        _debug = Debug;

        _sprite = new FlxSprite();
        create_graphic();
        add(_sprite);

        children = new FlxTypedGroup<PlanetaryBody>();
        add(children);

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

    public function create_child(Name : String, Spec : PlanetSpec)
    {
        var child : PlanetaryBody = new PlanetaryBody(Spec, _debug);

        child.name = Name;
        add_child(child);

        return child;
    }

    public function add_child(Child : PlanetaryBody) : Void
    {
        Child.parent = this;
        Child.set_center_position(FlxPoint.weak(_center_position.x - Child.orbit_distance, _center_position.y - Child.orbit_distance));

        //draw_orbit(Child.orbit_distance);
        children.add(Child);
        //add(children);
    }

    private function create_graphic() : Void
    {
        _sprite.makeGraphic(cast size, cast size, FlxColor.TRANSPARENT, true);
        _sprite.drawCircle(size / 2, size / 2, size / 2, color);
    }

    private function get_color() : Int { return _color; }
    private function set_color(value : Int) : Int
    {
        _color = value;
        create_graphic();

        return _color;
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