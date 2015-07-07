package mecha;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxPath;
import Global;

class Hara extends FlxSprite
{
    public var location:Location;
    public var actionCurrent:Int;
    public var path:FlxPath = new FlxPath();

    public var satiety:Float = 1;
    public var fatigue:Float = 0;

    public var speed:Float = 48;

    public function new(X:Float, Y:Float, Location:Location)
    {
        super(X, Y);
        location = Location;
        makeGraphic(8, 24, 0xffff8000);
        height = 8;
        offset.set(0, 16);

        FlxG.camera.follow(this, 0);

        path.onComplete = onEnd;
    }

    override public function update():Void
    {
        super.update();
        fatigue = Math.min(fatigue + FlxG.elapsed / 100, 1);

        if ((FlxG.touches.list.length > 0 && FlxG.touches.list[0].justPressed) || FlxG.mouse.justPressed)
        {
            var point:FlxPoint;
            if (FlxG.touches.list.length > 0)
            {
                point = new FlxPoint(FlxG.touches.list[0].x, FlxG.touches.list[0].y);
            }
            else
            {
                point = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
            }
            if (location.walkMap.getTile(Std.int(point.x / 8), Std.int(point.y / 8)) == 0)
            {
                path.start(this, location.walkMap.findPath(FlxPoint.get(x + width / 2, y + height / 2), FlxPoint.get(Std.int(point.x / 8) * 8 + 4, Std.int(point.y / 8) * 8 + 4)), speed);
            }
            else for (i in 0...8)
            {
                if (location.walkMap.getTile(Std.int(point.x / 8) - 1 + i % 3, Std.int(point.y / 8) - 1 + Std.int(i / 3)) == 0)
                {
                    path.start(this, location.walkMap.findPath(FlxPoint.get(x + width / 2, y + height / 2), FlxPoint.get((Std.int(point.x / 8) - 1 + i % 3) * 8 + 4, (Std.int(point.y / 8) - 1 + Std.int(i / 3)) * 8 + 4)), speed);
                    break;
                }
            }


        }
    }

    public function onEnd(Path:FlxPath):Void
    {

    }
}