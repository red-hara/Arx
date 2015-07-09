package;

import flash.system.System;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxTimer;
import mecha.Interface;
import mecha.Location;

class ActionState extends FlxState
{
    public var location:Location;
    public var saveTimer:FlxTimer;

    override public function create():Void
    {
        super.create();
        location = new Location();
        openSubState(location);
        bgColor = 0xff000010;
        saveTimer = new FlxTimer(60, saveMethod, 0);
    }

    override public function update():Void
    {
        location.update();

        #if android
            if (FlxG.android.justPressed.BACK)
            {
                Global.save();
            }
        #end
    }

    public function saveMethod(Timer:FlxTimer):Void
    {
        trace("game saved");
        Global.save();
    }
}