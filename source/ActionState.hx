package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import mecha.Location;

class ActionState extends FlxState
{
    public var location:Location;

    override public function create():Void
    {
        super.create();
        location = new Location();
        add(location);
        bgColor = 0xff1c2323;
    }

    override public function update():Void
    {
        super.update();
        
    }
}