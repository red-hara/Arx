package mecha;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import flixel.tweens.FlxTween;

class Interface extends FlxSubState
{
    public static var used:Bool = false;
    public static var opened:Bool = false;

    public var tab:FlxGroup;

    public var saveIcon:SaveIcon;

    public var useButton:FlxSprite;
    public var fliper:Bool = true;
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

        useButton = new FlxSprite(144+16, -16, "assets/data/gui/useButton.png");
        useButton.scrollFactor.set(0, 0);
        add(useButton);

        tab = new FlxGroup();

        bg = new FlxSprite(-136, -66, "assets/data/gui/guiBg.png");
        bg.scrollFactor.set(0, 0);
        bg.visible = false;
        tab.add(openButton);
        tab.add(bg);

        hungerBar = new Bar(17, 25, bg);
        hungerBar.display(Global.hero.hunger);
        tab.add(hungerBar);

        fatigueBar = new Bar(33, 25, bg);
        fatigueBar.display(Global.hero.fatigue);
        tab.add(fatigueBar);

        lonelinessBar = new Bar(49, 25, bg);
        lonelinessBar.display(Global.hero.loneliness);
        tab.add(lonelinessBar);

        thirstBar = new Bar(65, 25, bg);
        thirstBar.display(Global.hero.thirst);
        tab.add(thirstBar);

        dirtynessBar = new Bar(81, 25, bg);
        dirtynessBar.display(Global.hero.dirtyness);
        tab.add(dirtynessBar);

        urineBar = new Bar(97, 25, bg);
        urineBar.display(Global.hero.urine);
        tab.add(urineBar);

        add(tab);

        saveIcon = new SaveIcon();
        add(saveIcon);
    }

    override public function update():Void
    {
        super.update();
        openButton.x = bg.x + 136;
        openButton.y = bg.y + 66;

        used = opened;

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
                used = true;
                if (!opened)
                {
                    opened = true;
                    openBg();
                }
                else
                {
                    opened = false;
                    closeBg();
                }
            }

            if (!used)
            {
                if (useButton.pixelsOverlapPoint(point))
                {
                    used = true;
                    Global.hero.use();
                }
            }
        }



        if (Global.hero.canUse)
        {
            if (fliper)
            {
                fliper = false;
                FlxTween.linearMotion(useButton, useButton.x, useButton.y, 144, 0, .25, true, {complete: fliperUse, type: FlxTween.ONESHOT});
            }
        }
        else if (fliper)
        {
            fliper = false;
            FlxTween.linearMotion(useButton, useButton.x, useButton.y, 144+16, -16, .25, true, {complete: fliperUse, type: FlxTween.ONESHOT});
        }

        if (bg.visible)
        {
            hungerBar.display(Global.hero.hunger);
            fatigueBar.display(Global.hero.fatigue);
            lonelinessBar.display(Global.hero.loneliness);
            thirstBar.display(Global.hero.thirst);
            dirtynessBar.display(Global.hero.dirtyness);
            urineBar.display(Global.hero.urine);
        }
    }

    public function fliperUse(Tween:FlxTween):Void
    {
        fliper = true;
    }

    public function openBg():Void
    {
        bg.visible = true;
        FlxTween.quadMotion(bg, bg.x, bg.y, 0, 0, 0, 0, .25, true, {type: FlxTween.ONESHOT});
    }

    public function closeBg():Void
    {
        FlxTween.quadMotion(bg, bg.x, bg.y, 0, 0, -136, -66, .25, true, {complete: onClose, type: FlxTween.ONESHOT});
    }

    public function onClose(Tween:FlxTween):Void
    {
        bg.visible = false;
        used = false;
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
        makeGraphic(6, 54 - Std.int(54 / 100 * Percent), 0xff2e1717);
        offset.y = -Math.floor(54 / 100 * Percent) - 0.5;
    }
}

class SaveIcon extends FlxSprite
{
    public function new()
    {
        super(FlxG.width / 2 - 8, 0, "assets/data/gui/save.png");
        scrollFactor.set(0, 0);
        alpha = 0;
    }

    public function pop():Void
    {
        FlxTween.color(this, 1, 0xffffffff, 0xffffffff, 0, 1, {complete: fade, type: FlxTween.ONESHOT});
    }

    public function fade(Tween:FlxTween):Void
    {
        FlxTween.color(this, 1, 0xffffffff, 0xffffffff, 1, 0, {type: FlxTween.ONESHOT});
    }
}