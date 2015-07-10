package;

import mecha.Hero;
import flixel.util.FlxSave;

class Global
{
    public static var hero:Hero;

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

        }

        hero.create();

        saver.flush();
    }
}