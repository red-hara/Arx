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
    public static var dialogAmount = 23;
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
        saver.data.death = hero.death;

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

            hero.hunger = Math.min(100, saver.data.hunger + 100 * deltaTime / hero.hungerDelay);

            if (hero.activity == 1)
            {
                hero.fatigue = Math.max(0, saver.data.fatigue - 100 * deltaTime / hero.fatigueDelay * 8);
            }
            else
            {
                hero.fatigue = Math.min(100, saver.data.fatigue + 100 * deltaTime / hero.fatigueDelay);
            }

            hero.loneliness = Math.min(100, saver.data.loneliness + 100 * deltaTime / hero.lonelinessDelay);

            if (hero.activity == 3)
            {
                hero.thirst = Math.max(0, saver.data.thirst - 100 * deltaTime / hero.thirstDelay * 10000);
            }
            else
            {
                hero.thirst = Math.min(100, saver.data.thirst + 100 * deltaTime / hero.thirstDelay);
            }

            if (hero.activity == 7)
            {
                hero.dirtyness = Math.max(0, saver.data.dirtyness - 100 * deltaTime / hero.dirtynessDelay * 2000);
            }
            else
            {
                hero.dirtyness = Math.min(100, saver.data.dirtyness + 100 * deltaTime / hero.dirtynessDelay);
            }

            hero.urine = Math.min(100, saver.data.urine + 100 * deltaTime / hero.urineDelay);

            if (saver.data.death != 0)
            {
                hero.death = Math.max(.5, saver.data.death - 100 * deltaTime / hero.deathDelay);
            }
            else
            {
                hero.death = 0;
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
        log += "#lab: ping//144.235.182.100\n";
        typeTimer = new FlxTimer(.25, answer, 1);
        hero.loneliness = Math.max(0, hero.loneliness - 10);
    }

    public static function answer(Timer:FlxTimer):Void
    {
        if (dialogIndex < dialog.length)
        {
            if (dialog[dialogIndex++].length > 0)
            {
                log += "#hara: " + dialog[dialogIndex - 1] + "\n";
            }
        }
        else
        {
            dialogIndex = 0;
            dialogNumber = Std.int(dialogAmount * Math.random());
            dialog = loadDialog(dialogNumber);
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