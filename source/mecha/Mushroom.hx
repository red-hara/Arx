package mecha;

import flixel.FlxSprite;

class Mushroom extends FlxSprite
{
    public function new(X:Float, Y:Float)
    {
        super(X, Y, "assets/data/objects/mushroom.png");
        width = 8;
        height = 8;
        offset.set(1, 10);
    }
}