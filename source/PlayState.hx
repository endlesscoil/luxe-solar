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

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void
    {
        super.create();

        _test = new PlanetaryBody(50, "Earth");
        _test.position = FlxPoint.weak(FlxG.width / 2, FlxG.height / 2);
        _test.center_position = FlxPoint.weak(FlxG.width / 2, FlxG.height / 2);

        var moon1 = new PlanetaryBody(10, "The Moon", FlxColor.WHITE);
        _test.add_child(moon1, 40);

        var submoon1 = new PlanetaryBody(5, "Moon2", FlxColor.GREEN);
        moon1.add_child(submoon1, 20);

        add(_test);
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