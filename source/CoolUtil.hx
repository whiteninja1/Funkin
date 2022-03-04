package;

import lime.utils.Assets;
import flixel.FlxSprite;
import flixel.util.FlxColor;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];
	public static var discordtext:String = sys.io.File.getContent(Paths.txt('discord'));
	public static var discordstuff:Array<String> = discordtext.split('\n');
	public static var huh:String = sys.io.File.getContent(Paths.txt('titleText'));
	public static var titletext:Array<String> = huh.split('\n');
	public static var textfile:String = sys.io.File.getContent(Paths.txt('menubuttons'));
	public static var buttonslines = textfile.split('\n');
	public static var menubuttonsxy:Array<Array<Int>> = [];

	public static function difficultyString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static function healthbarcolor(sprite:FlxSprite)
	{
		var countByColor:Map<Int, Int> = [];
		for (col in 0...sprite.frameWidth) {
			for (row in 0...sprite.frameHeight) {
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if (colorOfThisPixel != 0) {
					if (countByColor.exists(colorOfThisPixel)) {
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					} else if (countByColor[colorOfThisPixel] != 13520687 - (2 * 13520687)) {
						countByColor[colorOfThisPixel] = 1;
					}
				}
			}
		}
		var maxCount = 0;
		var maxKey:Int = 0; // after the loop this will store the max color
		countByColor[FlxColor.BLACK] = 0;
		for (key in countByColor.keys()) {
			if (countByColor[key] >= maxCount) {
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}
}
