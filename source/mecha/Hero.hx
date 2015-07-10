package mecha;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import Global;

class Hero extends FlxSprite
{
    public var location:Location;
    public var path:FlxPath = new FlxPath();

    public var hunger:Float = 100 * Math.random();
    public var fatigue:Float = 100 * Math.random();
    public var loneliness:Float = 100 * Math.random();
    public var thirst:Float = 100 * Math.random();
    public var dirtyness:Float = 100 * Math.random();
    public var urine:Float = 100 * Math.random();

    public var hungerDelay:Float = 60 * 60 * 12;
    public var fatigueDelay:Float = 60 * 60 * 14;
    public var lonelinessDelay:Float = 60 * 60 * 10;
    public var thirstDelay:Float = 60 * 60 * 12;
    public var dirtynessDelay:Float = 60 * 60 * 16;
    public var urineDelay:Float = 60 * 60 * 12;

    public var speed:Float = 48;
    public var isOnLadder:Bool = false;

    public var action:Void->Void;

    public var cameraObject:FlxObject;

    public var canUse:Bool = false;

    public var activity:Int = WALK;
    public static inline var WALK:Int = 0;
    public static inline var SLEEP:Int = 1;
    public static inline var SIT:Int = 2;
    public static inline var DRINK:Int = 3;

    public function new(X:Float, Y:Float, Location:Location)
    {
        super(X, Y);
        location = Location;

        loadGraphic("assets/data/armor.png", true, 24, 24);
        width = 8;
        height = 8;
        offset.set(8, 16);
        animation.add("stay right", [0]);
        animation.add("stay left", [1]);
        animation.add("walk right", [2, 3, 4, 5, 6, 7], 8);
        animation.add("walk left", [8, 9, 10, 11, 12, 13], 8);
        animation.add("ladder climb", [14, 15, 14, 16], 4);
        animation.add("ladder hang", [14]);
        animation.add("sleep", [17]);
        animation.add("sit", [18]);
        animation.add("use", [19, 20, 21], 2);

        Global.hero = this;

        action = walk;
    }

    public function create():Void
    {
        cameraObject = new FlxObject(x + 4, y + 4);
        FlxG.camera.follow(cameraObject, 0);
        FlxG.camera.update();
        FlxG.camera.followLerp = 8;

        updateAction();
    }

    override public function update():Void
    {
        super.update();
        action();

        canUse = overlaps(location.objects);

        hunger = Math.min(100, 100 * FlxG.elapsed / hungerDelay + hunger);
        fatigue = Math.min(100, 100 * FlxG.elapsed / fatigueDelay + fatigue);
        loneliness = Math.min(100, 100 * FlxG.elapsed / lonelinessDelay + loneliness);
        thirst = Math.min(100, 100 * FlxG.elapsed / thirstDelay + thirst);
        dirtyness = Math.min(100, 100 * FlxG.elapsed / dirtynessDelay + dirtyness);
        urine = Math.min(100, 100 * FlxG.elapsed / urineDelay + urine);
    }

    public function use():Void
    {
        for (member in location.objects.members)
        {
            if (overlaps(member))
            {
                useObject(cast(member, FlxObject));
            }
        }
    }

    public function useObject(Object:FlxObject)
    {
        if (Std.is(Object, Bed))
        {
            if (activity == SLEEP)
            {
                activity = WALK;
            }
            else
            {
                activity = SLEEP;
            }
        }
        if (Std.is(Object, Cliff))
        {
            if (activity == SIT)
            {
                activity = WALK;
                offset.set(8, 16);
            }
            else
            {
                activity = SIT;
            }
        }
        if (Std.is(Object, Sink))
        {
            activity = DRINK;
        }

        updateAction();
    }

    public function drink():Void
    {
        animation.play("use");
        thirst = Math.max(0, -100 * FlxG.elapsed / thirstDelay * 10000 + thirst);
        if (thirst == 0)
        {
            activity = WALK;
            updateAction();
        }
    }

    public function sit():Void
    {
        animation.play("sit");
        offset.set(8, 10);
    }

    public function sleep():Void
    {
        animation.play("sleep");
        fatigue = Math.max(0, -100 * FlxG.elapsed / fatigueDelay * 8 + fatigue);
    }

    public function updateAction():Void
    {
        switch (activity)
        {
            case WALK:
                action = walk;
            case SLEEP:
                action = sleep;
            case SIT:
                action = sit;
            case DRINK:
                action = drink;
        }
    }

    public function walk():Void
    {
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

        //camera part
        if (velocity.x > 0)
        {
            cameraObject.x = x + 32;
        }
        else if (velocity.x < 0)
        {
            cameraObject.x = x - 32;
        }
        if (velocity.y > 0)
        {
            cameraObject.y = y + 16;
        }
        else if (velocity.y < 0)
        {
            cameraObject.y = y - 16;
        }

        //movement part
        if (!Interface.used)
        {
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
                    if (location.walkMap.getTile(Std.int(point.x / 8) - 1 + (i + 1) % 3, Std.int(point.y / 8) - 1 + Std.int(i / 3)) == 0)
                    {
                        path.start(this, location.walkMap.findPath(FlxPoint.get(x + width / 2, y + height / 2), FlxPoint.get((Std.int(point.x / 8) - 1 + (i + 1) % 3) * 8 + 4, (Std.int(point.y / 8) - 1 + Std.int(i / 3)) * 8 + 4)), speed);
                        break;
                    }
                }
            }
        }
    }
}