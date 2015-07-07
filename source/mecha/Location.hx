package mecha;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import openfl.Assets;

class Location extends FlxGroup
{
    public var tilemap:FlxTilemap;
    public var walkMap:FlxTilemap;
    public var objectsMap:FlxTilemap;
    public var objects:FlxGroup;
    public var middle:FlxGroup;

    public function new()
    {
        super();
        FlxG.worldBounds.set();

        tilemap = new FlxTilemap();
        tilemap.loadMap(Assets.getText("assets/data/mapCSV_arx_main.csv"), Assets.getBitmapData("assets/data/tiles.png"), 8, 8, 0, 0, 0, 128);

        middle = new FlxGroup();
        objects = new FlxGroup();

        walkMap = new FlxTilemap();
        walkMap.loadMap(Assets.getText("assets/data/mapCSV_arx_walk.csv"), Assets.getBitmapData("assets/data/tiles.png"), 8, 8);

        objectsMap = new FlxTilemap();
        objectsMap.loadMap(Assets.getText("assets/data/mapCSV_arx_objects.csv"), Assets.getBitmapData("assets/data/objects.png"), 8, 8);
        var object:Object = new Object(60 * 8, 113 * 8);
        object.type = 0;
        objects.add(object);

        add(tilemap);
        add(objects);
        add(objectsMap);
        add(middle);


        middle.add(new Hara(57 * 8, 113 * 8, this));
    }

    override public function update():Void
    {
        super.update();
        FlxG.collide(middle, tilemap);
    }

    public function getObjectPoint(Type:Int):FlxPoint
    {
        for (object in objects)
        {
            if (cast(object, Object).type == Type)
            {
                return new FlxPoint(cast(object, Object).x, cast(object, Object).y);
            }
        }
        return new FlxPoint();
    }
}