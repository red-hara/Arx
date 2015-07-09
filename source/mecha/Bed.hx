package mecha;

import flixel.FlxSprite;

class Bed extends FlxSprite
{
    public function new(X:Float, Y:Float)
    {
        super(X, Y, "assets/data/objects/bed.png");
        width = 8;
        offset.set(8, 0);
    }
}