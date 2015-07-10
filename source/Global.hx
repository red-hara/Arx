package;

import mecha.Hero;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import openfl.Assets;

class Global
{
    public static var hero:Hero;

    public static var log:String = "";
    public static var dialogNumber:Int = -1;
    public static var dialogIndex:Int = 0;
    public static var dialogAmount = 0;
    public static var dialog:Array<String>;
    public static var typeTimer:FlxTimer;

    public static function save():Void
    {
        var saver:FlxSave = new FlxSave();
        saver.bind("Arx");

        saver.data.time = Date.now().getTime();
        saver.data.hunger = hero.hunger;
        saver.data.fatigue = hero.fatigue;
        saver.data.loneliness = hero.loneliness;
        saver.data.thirst = hero.thirst;
        saver.data.dirtyness = hero.dirtyness;
        saver.data.urine = hero.urine;
        saver.data.activity = hero.activity;
        saver.data.x = hero.x;
        saver.data.y = hero.y;
        saver.data.facing = hero.facing;
        saver.data.isOnLadder = hero.isOnLadder;
        saver.data.log = log;
        saver.data.dialogNumber = dialogNumber;
        saver.data.dialogIndex = dialogIndex;

        saver.flush();
    }

    public static function load():Void
    {
        var saver:FlxSave = new FlxSave();
        saver.bind("Arx");
        if (saver.data.time != null)
        {
            var deltaTime:Float = (Date.now().getTime() - saver.data.time)/1000;

            hero.activity = saver.data.activity;
            hero.x = saver.data.x;
            hero.y = saver.data.y;
            hero.facing = saver.data.facing;
            hero.isOnLadder = saver.data.isOnLadder;

            if (hero.activity == 1)
            {
                hero.fatigue = Math.max(0, saver.data.fatigue - 100 * deltaTime / hero.fatigueDelay * 8);
            }
            else
            {
                hero.fatigue = Math.min(100, saver.data.fatigue + 100 * deltaTime / hero.fatigueDelay);
            }

            if (hero.activity == 3)
            {
                hero.thirst = Math.max(0, saver.data.thirst - 100 * deltaTime / hero.thirstDelay * 10000);
            }
            else
            {
                hero.thirst = Math.min(100, saver.data.thirst + 100 * deltaTime / hero.thirstDelay);
            }

            log = saver.data.log;
            dialogNumber = saver.data.dialogNumber;
            dialogIndex = saver.data.dialogIndex;

        }

        hero.create();

        dialog = loadDialog(dialogNumber);

        saver.flush();
    }

    public static function ping():Void
    {
        log += "(@lab): root.ping//144.235.182.100\n";
        typeTimer = new FlxTimer(.5, answer, 1);
    }

    public static function answer(Timer:FlxTimer):Void
    {
        if (dialog[dialogIndex++].length > 0)
        {
            log += "(@hara): " + dialog[dialogIndex - 1] + "\n";
        }
    }

    public static function loadDialog(DialogNumber:Int):Array<String>
    {
        var result:Array<String> = Assets.getText("assets/data/dialogs/" + Std.string(DialogNumber)).split("\n");
        for (i in 0...result.length)
        {
            result[i] = result[i].split("~").join("\n");
        }
        return result;
    }
}