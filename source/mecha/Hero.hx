package mecha;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxPath;
import flixel.util.FlxPoint;
import Global;

class Hero extends FlxSprite
{
    public var location:Location;
    public var path:FlxPath = new FlxPath();

    public var hunger:Float = 50 * Math.random();
    public var fatigue:Float = 50 * Math.random();
    public var loneliness:Float = 50 * Math.random();
    public var thirst:Float = 50 * Math.random();
    public var dirtyness:Float = 50 * Math.random();
    public var urine:Float = 50 * Math.random();

    public var death:Float = 0;

    public var hungerDelay:Float = 60 * 60 * 20;
    public var fatigueDelay:Float = 60 * 60 * 14;
    public var lonelinessDelay:Float = 60 * 60 * 10;
    public var thirstDelay:Float = 60 * 60 * 8;
    public var dirtynessDelay:Float = 60 * 60 * 9;
    public var urineDelay:Float = 60 * 60 * 18;
    public var deathDelay:Float = 60 * 60;

    public var speed:Float = 48;
    public var isOnLadder:Bool = false;

    public var action:Void->Void;

    public var cameraObject:FlxObject;

    public var canUse:Bool = false;

    public var activity:Int = WALK;
    public static inline var DEATH:Int = -1;
    public static inline var WALK:Int = 0;
    public static inline var SLEEP:Int = 1;
    public static inline var SIT:Int = 2;
    public static inline var DRINK:Int = 3;
    public static inline var COMPUTER:Int = 4;
    public static inline var EAT:Int = 5;
    public static inline var URINATE:Int = 6;
    public static inline var SHOWER:Int = 7;

    public var text:FallingText;

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
        animation.add("use", [19, 20, 19, 21], 2);
        animation.add("urinate", [22]);
        animation.add("shower", [23]);
        animation.add("layDead", [24]);

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

        if (death == 0)
        {
            canUse = overlaps(location.objects);

            hunger = Math.min(100, 100 * FlxG.elapsed / hungerDelay + hunger);
            fatigue = Math.min(100, 100 * FlxG.elapsed / fatigueDelay + fatigue);
            loneliness = Math.min(100, 100 * FlxG.elapsed / lonelinessDelay + loneliness);
            thirst = Math.min(100, 100 * FlxG.elapsed / thirstDelay + thirst);
            dirtyness = Math.min(100, 100 * FlxG.elapsed / dirtynessDelay + dirtyness);
            urine = Math.min(100, 100 * FlxG.elapsed / urineDelay + urine);
            if (hunger + fatigue + loneliness + dirtyness + urine >= 350)
            {
                death = 100;
            }
        }
        else
        {
            if (location.interFace.monitor.opened)
            {
                location.interFace.monitor.close();
            }

            hunger = 100;
            fatigue = 100;
            loneliness = 100;
            thirst = 100;
            dirtyness = 100;
            urine = 100;

            activity = DEATH;
            updateAction();

            canUse = false;
            death = Math.max(0, death - 100 * FlxG.elapsed / deathDelay);
            if (death == 0)
            {
                hunger = 50 * Math.random();
                fatigue = 50 * Math.random();
                loneliness = 50 * Math.random();
                thirst = 50 * Math.random();
                dirtyness = 50 * Math.random();
                urine = 50 * Math.random();
                activity = WALK;
                updateAction();
            }
        }
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
        if (Std.is(Object, Computer))
        {
            if (activity == COMPUTER)
            {
                activity = WALK;
                location.interFace.monitor.close();
            }
            else
            {
                activity = COMPUTER;
            }
        }
        if (Std.is(Object, Portal))
        {
            text = new FallingText(x + 4, y - 24, "no power");
        }
        if (Std.is(Object, Mushroom))
        {
            activity = EAT;
            text = new FallingText(x + 4, y - 32, "gross");
        }
        if (Std.is(Object, Toilet))
        {
            activity = URINATE;
        }
        if (Std.is(Object, Shower))
        {
            activity = SHOWER;
        }

        updateAction();
    }

    public function shower():Void
    {
        animation.play("shower");
        dirtyness = Math.max(0, -100 * FlxG.elapsed / dirtynessDelay * 2000 + dirtyness);
        if (dirtyness == 0)
        {
            activity = WALK;
            updateAction();
        }
    }

    public function urinate():Void
    {
        animation.play("urinate");
        urine = Math.max(0, -100 * FlxG.elapsed / urineDelay * 10000 + urine);
        if (urine == 0)
        {
            activity = WALK;
            updateAction();
        }
    }

    public function eat():Void
    {
        animation.play("use");
        hunger = Math.max(0, -100 * FlxG.elapsed / hungerDelay * 5000 + hunger);
        if (hunger == 0)
        {
            activity = WALK;
            updateAction();
        }
    }

    public function computer():Void
    {
        animation.play("use");
    }

    public function drink():Void
    {
        animation.play("use");
        thirst = Math.max(0, -100 * FlxG.elapsed / thirstDelay * 5000 + thirst);
        urine = Math.min(100, 100 * FlxG.elapsed / urineDelay * 100 + urine);
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

    public function layDead():Void
    {
        animation.play("layDead");
        if (text == null)
        {
            text = new FallingText(x + 4, y - 32, "Will be back in " + Std.string(Std.int(Math.ceil(death))) + "...");
        }

    }

    public function updateAction():Void
    {
        switch (activity)
        {
            case DEATH:
                action = layDead;
            case WALK:
                action = walk;
            case SLEEP:
                action = sleep;
            case SIT:
                action = sit;
            case DRINK:
                action = drink;
            case COMPUTER:
                action = computer;
                location.interFace.monitor.open();
            case EAT:
                action = eat;
            case URINATE:
                action = urinate;
            case SHOWER:
                action = shower;
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

class FallingText extends FlxText
{
    public function new(X:Float, Y:Float, Text:String)
    {
        super(X - 32, Y, 64, Text);
        setFormat("assets/data/Micro.ttf");
        alignment = "center";
        color = 0xff529ba2;
        Global.hero.location.add(this);
        FlxTween.color(this, 3, 0xff529ba2, 0xff529ba2, 1, 0, {complete: remove, type: FlxTween.ONESHOT});
    }

    public function remove(Tween:FlxTween):Void
    {
        Global.hero.location.remove(this).destroy();
        Global.hero.text = null;
    }
}