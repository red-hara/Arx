package mecha;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxPath;
import Global;

class Hara extends FlxSprite
{
    public var location:Location;
    public var actionCurrent:Int = IDLE;
    public var wantTo:Int;
    public var goingTo:Int;
    public var path:FlxPath = new FlxPath();

    public var satiety:Float = 1;
    public var fatigue:Float = 0;

    public var speed:Float = 48;

    public static inline var IDLE:Int = 0;
    public static inline var WALK:Int = 1;
    public static inline var SLEEP:Int = 2;

    public function new(X:Float, Y:Float, Location:Location)
    {
        super(X, Y);
        location = Location;
        makeGraphic(8, 24, 0xffff8000);
        height = 8;
        offset.set(0, 16);

        FlxG.camera.follow(this, 1);

        path.onComplete = onEnd;
    }

    override public function update():Void
    {
        super.update();
        trace(fatigue);
        fatigue = Math.min(fatigue + FlxG.elapsed / 100, 1);
        if (fatigue > 0.9)
        {
            wantTo = SLEEP;
        }

        if (actionCurrent == IDLE)
        {
            if (path.finished)
            {
                var freePoints:Array<FlxPoint> = location.walkMap.getTileCoords(0);
                trace(freePoints);
                var pathPoints:Array<FlxPoint> = location.walkMap.findPath(FlxPoint.get(x + width / 2, y + height / 2),  freePoints[Std.int(freePoints.length * Math.random())]);
                path.start(this, pathPoints, speed);
            }

            if (wantTo == SLEEP && goingTo != SLEEP)
            {
                goingTo = SLEEP;
                path.cancel();
                var pathPoints:Array<FlxPoint> = location.walkMap.findPath(FlxPoint.get(x + width / 2, y + height / 2),  location.getObjectPoint(0));
                path.start(this, pathPoints, speed);
            }
        }
        if (actionCurrent == SLEEP)
        {
            fatigue = Math.max(fatigue - FlxG.elapsed / 10, 0);
            if (fatigue == 0)
            {
                wantTo = IDLE;
            }
        }
    }

    public function onEnd(Path:FlxPath):Void
    {
        actionCurrent = goingTo;
        goingTo = IDLE;
        wantTo = IDLE;
    }
}