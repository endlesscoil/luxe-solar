package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
    static var LEVEL_MIN_X = -1024;
    static var LEVEL_MAX_X = 1024*2;
    static var LEVEL_MIN_Y = -768;
    static var LEVEL_MAX_Y = 768*2;

    private var _sun : PlanetaryBody;
    private var _mercury : PlanetaryBody;
    private var _venus : PlanetaryBody;
    private var _earth : PlanetaryBody;
    private var _mars : PlanetaryBody;
    private var _jupiter : PlanetaryBody;
    private var _saturn : PlanetaryBody;
    private var _uranus : PlanetaryBody;
    private var _neptune : PlanetaryBody;
    private var _pluto : PlanetaryBody;

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void
    {
        super.create();

        FlxG.camera.antialiasing = true;

        var debug : Bool = true;

        //FlxG.camera.setBounds(LEVEL_MIN_X , LEVEL_MIN_Y , LEVEL_MAX_X + Math.abs(LEVEL_MIN_X), LEVEL_MAX_Y + Math.abs(LEVEL_MIN_Y), true);

        _sun = new PlanetaryBody(30, "Sun", FlxColor.YELLOW, 0.0, 0, debug);
        _sun.center_position = FlxPoint.weak(FlxG.width / 2, FlxG.height / 2);

        _mercury = new PlanetaryBody(PlanetaryBody.PLANETS.mercury.size, "Mercury", FlxColor.WHITE, 0.25, 1, true);
        _venus = new PlanetaryBody(PlanetaryBody.PLANETS.venus.size, "Venus", FlxColor.WHITE, 0.25, 1, true);
        _earth = new PlanetaryBody(PlanetaryBody.PLANETS.earth.size, "Earth", FlxColor.WHITE, 0.25, 1, true);
        _mars = new PlanetaryBody(PlanetaryBody.PLANETS.mars.size, "Mars", FlxColor.WHITE, 0.25, 1, true);
        _jupiter = new PlanetaryBody(PlanetaryBody.PLANETS.jupiter.size, "Jupiter", FlxColor.WHITE, 0.25, 1, true);
        _saturn = new PlanetaryBody(PlanetaryBody.PLANETS.saturn.size, "Saturn", FlxColor.WHITE, 0.25, 1, true);
        _uranus = new PlanetaryBody(PlanetaryBody.PLANETS.uranus.size, "Uranus", FlxColor.WHITE, 0.25, 1, true);
        _neptune = new PlanetaryBody(PlanetaryBody.PLANETS.neptune.size, "Neptune", FlxColor.WHITE, 0.25, 1, true);
        _pluto = new PlanetaryBody(PlanetaryBody.PLANETS.pluto.size, "Pluto", FlxColor.WHITE, 0.25, 1, true);

/*
        _earth = new PlanetaryBody(20, "Earth", FlxColor.CYAN, 0.25, 1, debug);
        //_earth.position = FlxPoint.weak(100, 200);

        var moon = new PlanetaryBody(5, "The Moon", FlxColor.WHITE, 0.5, -1, debug);

        _mars = new PlanetaryBody(30, "Mars", FlxColor.MAROON, 0.99, 1, debug);
        //_mars.position = FlxPoint.weak(200, 200);

        _sun.add_child(_earth, 60);
        _sun.add_child(_mars, 100);
        _earth.add_child(moon, 15);

        add(_sun);
        add(_earth);
        add(_mars);
*/
        _sun.add_child(_mercury, PlanetaryBody.PLANETS.mercury.distance);
        _sun.add_child(_venus, PlanetaryBody.PLANETS.venus.distance);
        _sun.add_child(_earth, PlanetaryBody.PLANETS.earth.distance);
        _sun.add_child(_mars, PlanetaryBody.PLANETS.mars.distance);
        _sun.add_child(_jupiter, PlanetaryBody.PLANETS.jupiter.distance);
        _sun.add_child(_saturn, PlanetaryBody.PLANETS.saturn.distance);
        _sun.add_child(_uranus, PlanetaryBody.PLANETS.uranus.distance);
        _sun.add_child(_neptune, PlanetaryBody.PLANETS.neptune.distance);
        _sun.add_child(_pluto, PlanetaryBody.PLANETS.pluto.distance);

        add(_sun);
        add(_mercury);
        add(_venus);
        add(_earth);
        add(_mars);
        add(_jupiter);
        add(_saturn);
        add(_uranus);
        add(_neptune);
        add(_pluto);


        //setZoom(0.5);
    }
    
    /**
     * Function that is called when this state is destroyed - you might want to 
     * consider setting all objects this state uses to null to help garbage collection.
     */
    override public function destroy():Void
    {
        super.destroy();
    }

    /**
     * Function that is called once every frame.
     */
    override public function update():Void
    {
        super.update();

        if (FlxG.keys.anyJustPressed(['U']))
            FlxG.camera.scroll.x -= 10;

        if (FlxG.keys.anyJustPressed(['I']))
            FlxG.camera.scroll.x += 10;

        if (FlxG.mouse.wheel > 0)
            setZoom2(FlxG.camera.zoom + .1);
        if (FlxG.mouse.wheel < 0)
            setZoom2(FlxG.camera.zoom - .1);
    }

    public function setZoom2(zoom : Float)
    {
        FlxG.camera.zoom = zoom;
        FlxG.camera.width = Math.ceil(FlxG.width / zoom);
        FlxG.camera.height = Math.ceil(FlxG.height / zoom);

        var center_pos : FlxPoint = FlxPoint.weak(FlxG.width / 2, FlxG.height / 2);
        var diff_x : Int = FlxG.width - FlxG.camera.width;
        var diff_y : Int = FlxG.height - FlxG.camera.height;

        if (diff_x != 0 && diff_y != 0)
            FlxG.camera.scroll.set(FlxG.width / 2- (center_pos.x - diff_x / 2), FlxG.height / 2 - (center_pos.y - diff_y / 2));
        else
            FlxG.camera.scroll.set(0, 0);
        //FlxG.camera.scroll.set(FlxG.width / 2 - (FlxG.camera.width - 1024), FlxG.height / 2 - (FlxG.camera.height - 768));

        trace('zoom=$zoom .. game WxH = ${FlxG.width}x${FlxG.height} .. camera WxH = ${FlxG.camera.width}x${FlxG.camera.height}');
        trace('center_pos=$center_pos .. diff=$diff_x, $diff_y');

        

        //FlxG.camera.setPosition(FlxG.mouse.x - FlxG.width / 2, FlxG.mouse.y - FlxG.height / 2);
        //FlxG.camera.scroll.set(FlxG.mouse.x, FlxG.mouse.y);
    }

    public function setZoom(zoom:Float)
    {
        if (zoom < .5) zoom = .5;
        if (zoom > 4) zoom = 4;
        
        zoom = Math.round(zoom * 10) / 10; // corrects float precision problems.
        
        FlxG.camera.zoom = zoom;
        
        #if TRUE_ZOOM_OUT
        zoom += 0.5; // For 1/2 zoom out.
        zoom -= (1 - zoom); // For 1/2 zoom out.
        #end
        
        var zoomDistDiffY;
        var zoomDistDiffX;
        
        
        if (zoom <= 1) 
        {
            zoomDistDiffX = Math.abs((LEVEL_MIN_X + LEVEL_MAX_X) - (LEVEL_MIN_X + LEVEL_MAX_X) / 1 + (1 - zoom));
            zoomDistDiffY = Math.abs((LEVEL_MIN_Y + LEVEL_MAX_Y) - (LEVEL_MIN_Y + LEVEL_MAX_Y) / 1 + (1 - zoom));
            #if TRUE_ZOOM_OUT
            zoomDistDiffX *= 1; // For 1/2 zoom out - otherwise -0.5 
            zoomDistDiffY *= 1; // For 1/2 zoom out - otherwise -0.5
            #else
            zoomDistDiffX *= -.5;
            zoomDistDiffY *= -.5;
            #end
        } else
        {
            zoomDistDiffX = Math.abs((LEVEL_MIN_X + LEVEL_MAX_X) - (LEVEL_MIN_X + LEVEL_MAX_X) / zoom);
            zoomDistDiffY = Math.abs((LEVEL_MIN_Y + LEVEL_MAX_Y) - (LEVEL_MIN_Y + LEVEL_MAX_Y) / zoom);
            #if TRUE_ZOOM_OUT
            zoomDistDiffX *= 1; // For 1/2 zoom out - otherwise 0.5
            zoomDistDiffY *= 1; // For 1/2 zoom out - otherwise 0.5
            #else
            zoomDistDiffX *= .5;
            zoomDistDiffY *= .5;
            #end
        }
        
        FlxG.camera.setBounds(LEVEL_MIN_X - zoomDistDiffX, 
                               LEVEL_MIN_Y - zoomDistDiffY,
                               (LEVEL_MAX_X + Math.abs(LEVEL_MIN_X) + zoomDistDiffX * 2),
                               (LEVEL_MAX_Y + Math.abs(LEVEL_MIN_Y) + zoomDistDiffY * 2),
                               false);
        //
        //if (zoom > 1)
            //cameraOverlay.scale.make(1 / zoom, 1 / zoom);
                            
    }
}