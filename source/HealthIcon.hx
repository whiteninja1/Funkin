package;

import flixel.FlxSprite;
import sys.FileSystem;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;
	public var icontype = 0;
	private var widtharray:Array<Int>;
	private var numberstuff:Int;
	private var iconheight:Int;
	private var icon:FlxSprite;
	private var newchar = '';
	private var icontypenumber:Int;
	var stuff = false;

	public function new(char:String = 'face', isPlayer:Bool = false, credits:Bool = false)
	{
		super();
		if(credits == true)
		{
			stuff = credits;
			if(!FileSystem.exists(Paths.image('credits/' + char)))
			{
				icon = loadGraphic(Paths.image('icons/icon-face'), true, 150, 150);
			}
			else
			{
				icon = loadGraphic(Paths.image('credits/' + char));
			}
		}
		else
		{
			if(char == 'bf-car')
			{
				newchar = 'bf';
			}
			else if(char == 'bf-christmas')
			{
				newchar = 'bf';
			}
			else if(char == 'mom-car')
			{
				newchar = 'mom';
			}
			else if(char == 'senpai-angry')
			{
				newchar = 'senpai';
			}
			else if(char == 'monster-christmas')
			{
				newchar = 'monster';
			}
			else
			{
				newchar = char;
			}
			if(!FileSystem.exists(Paths.image('icons/icon-' + newchar)))
			{
				icon = loadGraphic(Paths.image('icons/icon-face'), true, 150, 150);
			}
			else
			{	
				icon = loadGraphic(Paths.image('icons/icon-' + newchar), true, 150, 150);
			}
			iconheight = Math.round(icon.height / 150);
			if(icon.width >= 0 && icon.width <= 149)
			{
				widtharray = [0];
				icontype = 0;
			}
			if(icon.width >= 150 && icon.width <= 299)
			{
				widtharray = [0, 1];
				icontype = 1;
			}
			if(icon.width >= 300)
			{
				widtharray = [0, 1, 2];
				icontype = 2;
			}
			else
			{	
				widtharray = [0, 1];
				icontype = 1;
			}
			icontypenumber = icontype + 1;
			numberstuff = Math.round(icon.width);
			if(!FileSystem.exists(Paths.image('icons/icon-' + newchar)))
			{
				icon = loadGraphic(Paths.image('icons/icon-face'), true, numberstuff, iconheight * 150);
			}
			else
			{	
				icon = loadGraphic(Paths.image('icons/icon-' + newchar), true, numberstuff, iconheight * 150);
			}
			antialiasing = true;
			animation.add(newchar, widtharray, 0, false, isPlayer);
			animation.play(newchar);
			scrollFactor.set();
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if(stuff == true)
		{
			if (sprTracker != null)
				setPosition(sprTracker.x + sprTracker.width + 5, sprTracker.y + 15);
		}
		else
		{
			if (sprTracker != null)
				setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
		}
	}
}
