package mecha;

import flixel.FlxSprite;
import flixel.FlxG;

class Hara extends Creature
{
    public function new(X:Float, Y:Float, Location:Location)
    {
        super(X, Y, Location);
        makeGraphic(8, 24, 0xffff8000);
        FlxG.camera.follow(this);
    }
}