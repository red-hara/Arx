package mecha;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import flixel.tweens.FlxTween;

class Interface extends FlxSubState
{
    public static var opened:Bool = false;

    public var tab:FlxGroup;

    public var openButton:FlxSprite;
    public var bg:FlxSprite;

    public var hungerBar:Bar;
    public var fatigueBar:Bar;
    public var lonelinessBar:Bar;
    public var thirstBar:Bar;
    public var dirtynessBar:Bar;
    public var urineBar:Bar;

    override public function create():Void
    {
        super.create();
        openButton = new FlxSprite(0, 0, "assets/data/gui/openButton.png");
        openButton.scrollFactor.set(0, 0);

        tab = new FlxGroup();

        bg = new FlxSprite(-136, -66, "assets/data/gui/guiBg.png");
        bg.scrollFactor.set(0, 0);
        bg.visible = false;
        tab.add(openButton);
        tab.add(bg);

        hungerBar = new Bar(17, 25, bg);
        hungerBar.display(Global.hara.hunger);
        tab.add(hungerBar);

        fatigueBar = new Bar(33, 25, bg);
        fatigueBar.display(Global.hara.fatigue);
        tab.add(fatigueBar);

        lonelinessBar = new Bar(49, 25, bg);
        lonelinessBar.display(Global.hara.loneliness);
        tab.add(lonelinessBar);

        thirstBar = new Bar(65, 25, bg);
        thirstBar.display(Global.hara.thirst);
        tab.add(thirstBar);

        dirtynessBar = new Bar(81, 25, bg);
        dirtynessBar.display(Global.hara.dirtyness);
        tab.add(dirtynessBar);

        urineBar = new Bar(97, 25, bg);
        urineBar.display(Global.hara.urine);
        tab.add(urineBar);

        add(tab);
    }

    override public function update():Void
    {
        super.update();
        openButton.x = bg.x + 136;
        openButton.y = bg.y + 66;

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
                if (opened)
                {
                    openBg();
                }
                else
                {
                    closeBg();
                }
            }
        }

        hungerBar.display(Global.hara.hunger);
        fatigueBar.display(Global.hara.fatigue);
        lonelinessBar.display(Global.hara.loneliness);
        thirstBar.display(Global.hara.thirst);
        dirtynessBar.display(Global.hara.dirtyness);
        urineBar.display(Global.hara.urine);

    }

    public function openBg():Void
    {
        bg.visible = true;
        FlxTween.quadMotion(bg, bg.x, bg.y, 0, 0, 0, 0, .5, true, {type: FlxTween.ONESHOT});
    }

    public function closeBg():Void
    {
        FlxTween.quadMotion(bg, bg.x, bg.y, 0, 0, -136, -66, .5, true, {complete: onClose, type: FlxTween.ONESHOT});
    }

    public function onClose(Tween:FlxTween):Void
    {
        bg.visible = false;
    }
}

class Bar extends FlxSprite
{
    public var base:FlxSprite;
    public var oX:Float;
    public var oY:Float;

    public function new(X:Float, Y:Float, Base:FlxSprite)
    {
        super(Base.x + X, Base.y + Y);
        scrollFactor.set(0, 0);
        base = Base;
        oX = X;
        oY = Y;
    }

    override public function update():Void
    {
        super.update();
        x = base.x + oX;
        y = base.y + oY;
    }

    public function display(Percent:Float):Void
    {
        makeGraphic(6, Std.int(54 - 54 / 100 * Percent), 0xff2e1717);
        offset.y = -Math.ceil(54 / 100 * Percent) - 0.5;
    }
}