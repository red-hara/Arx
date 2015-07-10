package mecha;

import flixel.FlxObject;

class Computer extends FlxObject
{
    public function new(X:Float, Y:Float)
    {
        super(X, Y);
        width = 8;
        height = 8;
    }
}