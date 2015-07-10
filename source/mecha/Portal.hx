package mecha;

import flixel.FlxSprite;

class Portal extends FlxSprite
{
    public function new(X:Float, Y:Float)
    {
        super(X, Y);
        makeGraphic(8, 8, 0x00000000);
    }
}