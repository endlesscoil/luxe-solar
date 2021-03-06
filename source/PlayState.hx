package ;

import flash.display.LineScaleMode;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil.LineStyle;
//import MySpriteUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
    static var LEVEL_MIN_X = -1024;
    static var LEVEL_MAX_X = 1024*2;
    static var LEVEL_MIN_Y = -768;
    static var LEVEL_MAX_Y = 768*2;

    private var _orbit_sprite : FlxSprite;
    private var _sun : PlanetaryBody;

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void
    {
        super.create();

        FlxG.camera.antialiasing = true;
        setZoom(0.8);

        var debug : Bool = false;

        _orbit_sprite = new FlxSprite();
        // TODO: Fix me.. definitely need to make this sane.
        _orbit_sprite.makeGraphic(8000, 8000, FlxColor.TRANSPARENT, true);
        _orbit_sprite.setPosition(-4000 + FlxG.width/2, -4000 + FlxG.height/2);

        add(_orbit_sprite);

        _sun = new PlanetaryBody('Sol', { distance: -1, size: 30, period: 0, direction: 0, color: FlxColor.YELLOW }, debug);
        _sun.center_position = FlxPoint.weak(FlxG.width / 2, FlxG.height / 2);

        var num_planets : Int = Std.random(9) + 1;
        trace('Generating $num_planets planets..');
        for (i in 0...num_planets)
        {
            generate_planet(i);
        }

        add(_sun);

        trace('Drawing orbits..');
        _sun.children.forEach(function(Planet : PlanetaryBody) : Void {
            draw_orbit(Planet.orbit_distance);
        });

        trace('Running!');
    }
    
    /**
     * Function that is called when this state is destroyed - you might want to 
     * consider setting all objects this state uses to null to help garbage collection.
     */
    override public function destroy():Void
    {
        super.destroy();

        _sun = FlxDestroyUtil.destroy(_sun);
        _orbit_sprite = FlxDestroyUtil.destroy(_orbit_sprite);
    }

    /**
     * Function that is called once every frame.
     */
    override public function update(elapsed : Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.wheel > 0)
            setZoom(FlxG.camera.zoom + .1);
        if (FlxG.mouse.wheel < 0)
            setZoom(FlxG.camera.zoom - .1);

        if (_sun.check_collision(FlxG.mouse.x, FlxG.mouse.y))
            _sun.set_text_color(FlxColor.WHITE);
        else
            _sun.set_text_color(FlxColor.GRAY);

        _sun.children.forEach(function(Planet : PlanetaryBody) : Void {
            if (Planet.check_collision(FlxG.mouse.x, FlxG.mouse.y))
                Planet.set_text_color(FlxColor.WHITE);
            else
                Planet.set_text_color(FlxColor.GRAY);
        });
    }

    private function generate_planet(Index : Int) : PlanetaryBody
    {
        var spec : Dynamic = {
            distance: PlanetaryBody.AU * (Index + 1),
            size: 10 + Std.random(cast (PlanetaryBody.BASE_SIZE - 10, Int)),
            period: 0.05 + Math.random() * (PlanetaryBody.BASE_ORBITAL_PERIOD - 0.05),
            direction: (Std.random(10) > 7) ? -1 : 1,
            color: FlxColor.fromRGB(Std.random(256), Std.random(256), Std.random(256))
        };
        
        var name : String = generate_name();

        var child : PlanetaryBody = _sun.create_child(name, spec);

        trace('planet ${child.name} spec=$spec');

        return child;
    }

    private function generate_name() : String
    {
        var prefixes : Array<String> = ['Ultra', 'Mega', 'Super', 'Gummy', 'Zen'];
        var suffixes : Array<String> = ['Viking', 'Bee', 'Rex', 'Witch', 'Samurai'];

        return prefixes[Std.random(prefixes.length)] + ' ' + suffixes[Std.random(suffixes.length)] + ' ' + Std.random(10);
    }

    private function draw_orbit(Orbit : Float)
    {
        var lineStyle : LineStyle = { color: FlxColor.GRAY & 0x55FFFFFF, thickness: 2, pixelHinting: true, scaleMode: LineScaleMode.NONE };
        
        MySpriteUtil.drawCircle(_orbit_sprite, _orbit_sprite.width / 2, _orbit_sprite.height / 2, Orbit, FlxColor.TRANSPARENT, lineStyle);
    }

    public function setZoom(zoom : Float) : Void
    {
        var center_pos : FlxPoint = FlxPoint.weak(FlxG.width / 2, FlxG.height / 2);
        var camera_width : Int = Math.ceil(FlxG.width / zoom);
        var camera_height : Int = Math.ceil(FlxG.height / zoom);
        var diff_x : Int = FlxG.width - camera_width;
        var diff_y : Int = FlxG.height - camera_height;
        var scroll_x : Float = 0;
        var scroll_y : Float = 0;

        if (diff_x != 0)
            scroll_x = FlxG.width / 2 - (center_pos.x - diff_x / 2);

        if (diff_y != 0)
            scroll_y = FlxG.height / 2 - (center_pos.y - diff_y / 2);

        FlxG.camera.zoom = zoom;
        FlxG.camera.width = camera_width;
        FlxG.camera.height = camera_height;
        FlxG.camera.scroll.set(scroll_x, scroll_y);
    }
}