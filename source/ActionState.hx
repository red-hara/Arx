package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import mecha.Location;
import mecha.Interface;

class ActionState extends FlxState
{
    public var location:Location;
    public var interFace:Interface;

    override public function create():Void
    {
        super.create();
        location = new Location();
        add(location);
        interFace = new Interface();
        add(interFace);
        bgColor = 0xff000010;
    }

    override public function update():Void
    {
        interFace.update();
        location.update();
    }
}