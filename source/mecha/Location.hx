package mecha;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import openfl.Assets;

class Location extends FlxGroup
{
    public var tilemap:FlxTilemap;
    public var walkMap:FlxTilemap;
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

        add(tilemap);
        add(objects);
        add(middle);

        var objectsMap:FlxTilemap = new FlxTilemap();
        var instances:Array<Int>;
        objectsMap.loadMap(Assets.getText("assets/data/mapCSV_arx_objects.csv"), Assets.getBitmapData("assets/data/tiles.png"), 8, 8);
        instances= objectsMap.getTileInstances(1);
        for (instance in instances)
        {
            objects.add(new Ladder( 8 * instance % objectsMap.widthInTiles, 8 * Std.int(instance / objectsMap.widthInTiles)));
        }

        middle.add(new Hara(36 * 8, 65 * 8, this));
    }

    override public function update():Void
    {
        super.update();
        FlxG.collide(middle, tilemap);
    }
}