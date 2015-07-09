package;

import mecha.Hara;
import flixel.util.FlxSave;

class Global
{
    public static var hara:Hara;

    public static function save():Void
    {
        var saver:FlxSave = new FlxSave();
        saver.bind("Arx");

        saver.data.time = Date.now().getTime();
        saver.data.hunger = hara.hunger;
        saver.data.fatigue = hara.fatigue;
        saver.data.loneliness = hara.loneliness;
        saver.data.thirst = hara.thirst;
        saver.data.dirtyness = hara.dirtyness;
        saver.data.urine = hara.urine;
        saver.data.activity = hara.activity;
        saver.data.x = hara.x;
        saver.data.y = hara.y;
        saver.data.facing = hara.facing;
        saver.data.isOnLadder = hara.isOnLadder;

        saver.flush();
    }

    public static function load():Void
    {
        var saver:FlxSave = new FlxSave();
        saver.bind("Arx");
        if (saver.data.time != null)
        {
            var deltaTime:Float = (Date.now().getTime() - saver.data.time)/1000;

            hara.activity = saver.data.activity;
            hara.x = saver.data.x;
            hara.y = saver.data.y;
            hara.facing = saver.data.facing;
            hara.isOnLadder = saver.data.isOnLadder;
            trace(deltaTime);

            if (hara.activity == 1)
            {
                hara.fatigue = Math.max(0, saver.data.fatigue - 100 * deltaTime / hara.fatigueDelay * 8);
            }
            else
            {
                hara.fatigue = Math.min(100, saver.data.fatigue + 100 * deltaTime / hara.fatigueDelay);
            }

            if (hara.activity == 3)
            {
                hara.thirst = Math.max(0, saver.data.thirst - 100 * deltaTime / hara.thirstDelay * 10000);
            }
            else
            {
                hara.thirst = Math.min(100, saver.data.thirst + 100 * deltaTime / hara.thirstDelay);
            }

        }

        hara.create();

        saver.flush();
    }
}