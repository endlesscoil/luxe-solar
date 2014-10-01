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
    private var _test : PlanetaryBody;
    private var _test2 : PlanetaryBody;

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void
    {
        super.create();

        _test = new PlanetaryBody(50, "Earth", FlxColor.CYAN, 0.0, 0, true);
        _test.position = FlxPoint.weak(FlxG.width / 2, FlxG.height / 2);

        var moon1 = new PlanetaryBody(10, "The Moon", FlxColor.WHITE, 1.0, 1, true);
        _test.add_child(moon1, 60);

        var submoon1 = new PlanetaryBody(5, "Moon2", FlxColor.GREEN, 2.5, -1, true);
        moon1.add_child(submoon1, 20);

        _test2 = new PlanetaryBody(100, "Mars", FlxColor.MAROON, 0.0, 0, true);
        _test2.position = FlxPoint.weak(200, 300);

        var moon2 = new PlanetaryBody(50, "Mars Moon", FlxColor.WHITE, 0.5, -1, true);
        _test2.add_child(moon2, 80);

        add(_test);
        add(_test2);
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