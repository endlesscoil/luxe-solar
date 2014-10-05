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
    private var _earth : PlanetaryBody;
    private var _mars : PlanetaryBody;

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void
    {
        super.create();

        FlxG.camera.antialiasing = true;

        var debug : Bool = true;

        _sun = new PlanetaryBody(50, "Sun", FlxColor.YELLOW, 0.0, 0, debug);
        _sun.center_position = FlxPoint.weak(FlxG.width / 2, FlxG.height / 2);

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