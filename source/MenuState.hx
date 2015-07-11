package;

import flash.system.System;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class MenuState extends FlxState
{
    override public function create():Void
    {
        super.create();
        var text:FlxText = new FlxText(0, FlxG.height / 3, FlxG.width, "Arx 0.9\nTouch to start.");
        text.setFormat("assets/data/Micro.ttf");
        text.alignment = "center";
        text.size = 16;
        text.color = 0xff529ba2;
        text.setBorderStyle(2, 0xff122123);
        add(text);
        bgColor = 0xff000000;
        #if android
            FlxG.mouse.visible = false;
        #end

        Global.loadDialog(-1);
    }
    
    override public function update():Void
    {
        super.update();
        if (FlxG.mouse.justPressed || (FlxG.touches.list.length > 0 && FlxG.touches.list[0].justPressed))
        {
            FlxG.switchState(new ActionState());
        }
    }
}