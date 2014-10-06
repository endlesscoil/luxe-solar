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
    }   
}