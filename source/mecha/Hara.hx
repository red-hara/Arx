package mecha;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import Global;

class Hara extends Creature
{
    public function new(X:Float, Y:Float, Location:Location)
    {
        super(X, Y, Location);
        makeGraphic(8, 8, 0xffff8000);

        FlxG.camera.follow(this);

        var pathPoints:Array<FlxPoint> = location.walkMap.findPath(FlxPoint.get(x + width / 2, y + height / 2),  FlxPoint.get(32 * 8 + 4,  56 * 8 + 4));
        path.start(this, pathPoints);
    }

    override public function update():Void
    {
        super.update();
    }
}