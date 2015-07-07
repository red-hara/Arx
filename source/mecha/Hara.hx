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
        makeGraphic(8, 24, 0xffff8000);
        height = 8;
        offset.set(0, 16);

        FlxG.camera.follow(this, 1);

        var pathPoints:Array<FlxPoint> = location.walkMap.findPath(FlxPoint.get(x + width / 2, y + height / 2),  FlxPoint.get(69 * 8 + 4,  41 * 8 + 4));
        path.start(this, pathPoints, speed);
    }

    override public function update():Void
    {
        super.update();
    }
}