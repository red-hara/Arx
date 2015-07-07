package mecha;

import flixel.FlxSprite;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;

class Creature extends FlxSprite
{
    public var location:Location;
    public var actionCurrent:Int;
    public var path:FlxPath = new FlxPath();

    public var satiety:Float = 1;
    public var fatigue:Float = 0;

    public var speed:Float = 48;

    public static inline var WALK:Int = 0;

    public function new(X:Float, Y:Float, Location:Location)
    {
        super(X, Y);
        location = Location;
    }
}