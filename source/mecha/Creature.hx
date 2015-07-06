package mecha;

import flixel.FlxSprite;

class Creature extends FlxSprite
{
    public var location:Location;

    public function new(X:Float, Y:Float, Location:Location)
    {
        super(X, Y);
        location = Location;
    }
}