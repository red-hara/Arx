package mecha;

import flixel.FlxSprite;
import flixel.util.FlxPoint;

class Creature extends FlxSprite
{
    public var location:Location;
    public var destination:FlxPoint;
    public var actionCurrent:Int;

    public static inline var WALK:Int = 0;

    public function new(X:Float, Y:Float, Location:Location)
    {
        super(X, Y);
        location = Location;
    }
}