package ;

import flash.display.LineScaleMode;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
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
    private var _sun_emitter : FlxEmitter;
    //private var _particle : FlxParticle;

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

        _sun = new PlanetaryBody({ distance: -1, size: 30, period: 0, direction: 0 }, debug);
        _sun.center_position = FlxPoint.weak(FlxG.width / 2, FlxG.height / 2);
        _sun.color = FlxColor.YELLOW;

        _sun.create_child("Mercury", PlanetaryBody.PLANETS.mercury).color = FlxColor.GRAY;
        _sun.create_child("Venus", PlanetaryBody.PLANETS.venus).color = FlxColor.ORANGE;
        _sun.create_child("Earth", PlanetaryBody.PLANETS.earth).color = FlxColor.CYAN;
        _sun.create_child("Mars", PlanetaryBody.PLANETS.mars).color = FlxColor.RED;
        _sun.create_child("Jupiter", PlanetaryBody.PLANETS.jupiter).color = FlxColor.BROWN;
        _sun.create_child("Saturn", PlanetaryBody.PLANETS.saturn).color = FlxColor.BLUE;
        _sun.create_child("Uranus", PlanetaryBody.PLANETS.uranus).color = FlxColor.GREEN;
        _sun.create_child("Neptune", PlanetaryBody.PLANETS.neptune).color = FlxColor.LIME;
        _sun.create_child("Pluto", PlanetaryBody.PLANETS.pluto).color = FlxColor.BROWN;

        add(_sun);

        _sun.children.forEach(function(Planet : PlanetaryBody) : Void {
                draw_orbit(Planet.orbit_distance);
            });

/*

        _sun_emitter = new FlxEmitter(FlxG.width / 2, FlxG.height / 2, 500);
        _sun_emitter.setMotion(0, 1, 0.1, 360, 5, 0.5);
        _sun_emitter.setXSpeed(1000, 5000);
        _sun_emitter.setYSpeed(1000, 5000);

        for (i in 0..._sun_emitter.maxSize)
        {
            var color : UInt = FlxColor.YELLOW;
            if (i % 2 == 0)
                color = FlxColor.GOLDENROD;

            var particle = new FlxParticle();
            particle.makeGraphic(2, 2, color);
            particle.visible = false;
            _sun_emitter.add(particle);
        }
        
        //_sun_emitter.makeParticles(particle, 50);

        _sun_emitter.start(false, -1, 0.01);
        add(_sun_emitter);
        */
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
    }

    private function draw_orbit(Orbit : Float)
    {
        var lineStyle : LineStyle = { color: FlxColor.GRAY & 0x55FFFFFF, thickness: 2, pixelHinting: true, scaleMode: LineScaleMode.NONE };
        
        MySpriteUtil.drawCircle(_orbit_sprite, _orbit_sprite.width / 2, _orbit_sprite.height / 2, Orbit, FlxColor.TRANSPARENT, lineStyle);
    }

    public function setZoom(zoom : Float)
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
        // NOTE: Apparently not needed for the current dev branch..
        //FlxG.camera.scroll.set(scroll_x, scroll_y);
    }
}