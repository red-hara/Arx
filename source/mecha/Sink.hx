package mecha;

import flixel.FlxSprite;

class Sink extends FlxSprite
{
    public function new(X:Float, Y:Float)
    {
        super(X, Y, "assets/data/objects/sink.png");
        height = 8;
        offset.set(0, 8);
    }
}