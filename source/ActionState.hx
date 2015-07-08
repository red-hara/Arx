package;

import flash.system.System;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import mecha.Interface;
import mecha.Location;

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

        #if android
            if (FlxG.android.justPressed.BACK)
            {
                Global.save();
                System.exit(0);
            }
        #end
    }
}