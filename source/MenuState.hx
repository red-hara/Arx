package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class MenuState extends FlxState
{
	override public function create():Void
	{
		super.create();
		var text:FlxText = new FlxText(0, FlxG.height / 3, FlxG.width, "Arx\nTouch to start.");
    	text.alignment = "center";
		add(text);
		bgColor = 0xff804000;
	}
	
	override public function update():Void
	{
		super.update();
		if (FlxG.keys.pressed.SPACE || (FlxG.touches.list.length > 0 && FlxG.touches.list[0].justPressed))
		{
			FlxG.switchState(new ActionState());
		}
	}	
}