package mecha;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;

class Interface extends FlxSubState
{
    public static var opened:Bool = false;

    public var openButton:FlxSprite;

    override public function create():Void
    {
        super.create();
        openButton = new FlxSprite(0, 0, "assets/data/gui/openButton.png");
        openButton.scrollFactor.set(0, 0);
        add(openButton);
    }

    override public function update():Void
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

            if (openButton.pixelsOverlapPoint(point))
            {
                opened = !opened;
            }
        }
    }
}