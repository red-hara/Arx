package mecha;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
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
    public var hara:Hara;

    public var interFace:Interface;

    override public function create()
    {
        super.create();
        FlxG.worldBounds.set();

        tilemap = new FlxTilemap();
        tilemap.loadMap(Assets.getText("assets/data/mapCSV_arx_main.csv"), Assets.getBitmapData("assets/data/tiles.png"), 8, 8, 0, 0, 0, 128);

        objects = new FlxGroup();
        light = new FlxGroup();

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
            objects.add(sprite);
        }

        hara = new Hara(57 * 8, 113 * 8, this);

        add(tilemap);
        add(objectsMap);
        add(objects);
        add(hara);
        add(light);

        persistentUpdate = true;

        interFace = new Interface();
        openSubState(interFace);
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

    public function getObjectPoint(Type:Int):FlxPoint
    {
        for (object in objects)
        {
            if (cast(object, Object).type == Type)
            {
                return new FlxPoint(cast(object, Object).x + 4, cast(object, Object).y + 4);
            }
        }
        return new FlxPoint();
    }
}