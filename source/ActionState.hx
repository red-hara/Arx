package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import mecha.Location;
import mecha.Interface;

class ActionState extends FlxState
{
    public var location:Location;

    override public function create():Void
    {
        super.create();
        location = new Location();
        openSubState(location);
        bgColor = 0xff000010;
    }

    override public function update():Void
    {
        location.update();
    }
}