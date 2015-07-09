package mecha;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxMath;

class Door extends FlxSprite
{
    public var location:Location;
    public var fliper:Bool = true;

    public function new(X:Float, Y:Float, Location:Location)
    {
        super(X, Y);
        location = Location;
        loadGraphic("assets/data/door.png", true, 8, 32);
        animation.add("open", [0, 1, 2, 3], 10, false);
        animation.add("close", [3, 2, 1, 0], 10, false);
    }

    override public function update():Void
    {
        super.update();
        if (FlxMath.getDistance(getMidpoint(), location.hara.getMidpoint()) < 24)
        {
            if (fliper)
            {
                animation.play("open");
                FlxG.sound.play("assets/data/sounds/door.wav");
                fliper = false;
            }

        }
        else
        {
            if (!fliper)
            {
                animation.play("close");
                FlxG.sound.play("assets/data/sounds/door.wav");
                fliper = true;
            }
        }
    }
}