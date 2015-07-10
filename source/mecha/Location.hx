package mecha;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import openfl.Assets;

class Location extends FlxSubState
{
    public var tilemap:FlxTilemap;
    public var walkMap:FlxTilemap;
    public var objectsMap:FlxTilemap;
    public var objects:FlxGroup;
    public var light:FlxGroup;
    public var doors:FlxGroup;
    public var hero:Hero;

    public var interFace:Interface;

    override public function create()
    {
        super.create();
        FlxG.worldBounds.set();

        interFace = new Interface();
        interFace.create();
        subState = interFace;

        tilemap = new FlxTilemap();
        tilemap.loadMap(Assets.getText("assets/data/mapCSV_arx_main.csv"), Assets.getBitmapData("assets/data/tiles.png"), 8, 8, 0, 0, 0, 128);

        objects = new FlxGroup();
        light = new FlxGroup();
        doors = new FlxGroup();

        walkMap = new FlxTilemap();
        walkMap.loadMap(Assets.getText("assets/data/mapCSV_arx_walk.csv"), Assets.getBitmapData("assets/data/tiles.png"), 8, 8);

        objectsMap = new FlxTilemap();
        objectsMap.loadMap(Assets.getText("assets/data/mapCSV_arx_objects.csv"), Assets.getBitmapData("assets/data/objects.png"), 8, 8);
        var sprite:FlxSprite;
        var points:Array<FlxPoint>;

        points = objectsMap.getTileCoords(21, false);
        for (point in points)
        {
            sprite = new FlxSprite(point.x - 16, point.y - 16, "assets/data/light.png");
            light.add(sprite);
        }
        points = objectsMap.getTileCoords(8, false);
        for (point in points)
        {
            sprite = new Door(point.x, point.y, this);
            doors.add(sprite);
        }

        points = objectsMap.getTileCoords(9, false);
        for (point in points)
        {
            sprite = new Sink(point.x, point.y);
            objects.add(sprite);
            objectsMap.setTile(Std.int(point.x / 8), Std.int(point.y / 8), 0);
        }

        points = objectsMap.getTileCoords(10, false);
        for (point in points)
        {
            sprite = new Bed(point.x, point.y);
            objects.add(sprite);
            objectsMap.setTile(Std.int(point.x / 8), Std.int(point.y / 8), 0);
        }

        points = objectsMap.getTileCoords(11, false);
        for (point in points)
        {
            sprite = new Cliff(point.x, point.y);
            objects.add(sprite);
            objectsMap.setTile(Std.int(point.x / 8), Std.int(point.y / 8), 0);
        }

        objects.add(new Computer(88 * 8, 89 * 8));


        hero = new Hero(100 * 8, 65 * 8, this);

        add(new Rain());
        add(tilemap);
        add(objectsMap);
        add(objects);
        add(hero);
        add(doors);
        add(light);

        persistentUpdate = true;

        Global.load();
        Global.save();

        FlxG.sound.playMusic("assets/data/sounds/rain.wav");
        add(new Noise(87 * 8, 112 * 8));
    }

    override private function tryUpdate():Void
    {   
        if (_requestSubStateReset)
        {
            _requestSubStateReset = false;
            resetSubState();
        }
        else if (subState != null)
        {
            subState.tryUpdate();
        }

        if (persistentUpdate || (subState == null))
        {
            update();
        }
    }
}

class Rain extends FlxGroup
{
    public function new()
    {
        super();
        var x = 0;
        var y = 0;
        while (x < FlxG.width)
        {
            y = 0;
            while (y < FlxG.height + 16)
            {
                add(new RainDrop(x, y));
                y += 16;
            }
            x += 16;
        }
    }

    override public function update():Void
    {
        super.update();
    }
}

class RainDrop extends FlxSprite
{
    public function new(X:Float, Y:Float)
    {
        super(X, Y);
        loadGraphic("assets/data/rain.png", true, 16, 16, false);
        animation.randomFrame();
        scrollFactor.set(0, 0);
        velocity.y = 128;
    }

    override public function update():Void
    {
        super.update();
        if (y > FlxG.height)
        {
            y -= FlxG.height + 16;
            animation.randomFrame();
        }
    }
}

class Noise extends FlxSound
{
    override public function new(X:Float, Y:Float)
    {
        super();
        loadEmbedded("assets/data/sounds/noise.wav", true);
        play();
        setPosition(X, Y);
    }

    override public function update():Void
    {
        super.update();
        proximity(x, y, Global.hero, 128);
    }
}