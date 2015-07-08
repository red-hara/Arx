package mecha;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import Global;

class Hara extends FlxSprite
{
    public var location:Location;
    public var actionCurrent:Int;
    public var path:FlxPath = new FlxPath();

    public var satiety:Float = 1;
    public var fatigue:Float = 0;

    public var speed:Float = 48;
    public var isOnLadder:Bool = false;

    public function new(X:Float, Y:Float, Location:Location)
    {
        super(X, Y);
        location = Location;

        loadGraphic("assets/data/nothing.png", true, 24, 24);
        width = 8;
        height = 8;
        offset.set(8, 16);
        animation.add("stay right", [0]);
        animation.add("stay left", [1]);
        animation.add("walk right", [2, 3, 4, 5, 6, 7], 6);
        animation.add("walk left", [8, 9, 10, 11, 12, 13], 6);
        animation.add("ladder climb", [14, 15, 14, 16], 6);
        animation.add("ladder hang", [14]);

        FlxG.camera.follow(this, 0);

        path.onComplete = onEnd;
    }

    override public function update():Void
    {
        super.update();
        fatigue = Math.min(fatigue + FlxG.elapsed / 100, 1);

        //animation part
        if (velocity.x != 0)
        {
            isOnLadder = false;
        }
        if (velocity.y != 0)
        {
            isOnLadder = true;
        }

        if (isOnLadder)
        {
            if (velocity.y != 0)
            {
                animation.play("ladder climb");
            }
            else
            {
                animation.play("ladder hang");
            }
        }
        else
        {
            if (velocity.x != 0)
            {
                if (velocity.x > 0)
                {
                    facing = FlxObject.RIGHT;
                    animation.play("walk right");
                }
                else
                {
                    facing = FlxObject.LEFT;
                    animation.play("walk left");
                }
            }
            else
            {
                if (facing == FlxObject.RIGHT)
                {
                    animation.play("stay right");
                }
                else
                {
                    animation.play("stay left");
                }
            }
        }

        //movement part
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