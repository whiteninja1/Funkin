package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxObject;

using StringTools;

class CreditsState extends MusicBeatState
{
	private var curSelected:Int = 0;
	private var iconArray:Array<HealthIcon> = [];
	private var ynumber = 0;
	private var creditgroup:FlxTypedGroup<Alphabet>;
	var unselectedlist:Array<Array<String>> = [];
	var selectedlist:Array<Array<String>> = [];
	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG'));
	var camerapositions:Array<Int> = [];
	var camerapositionstuff:Int = 260;
	var menuitemnumber = 0;
	var swagGoodArray:Array<Array<String>> = [];

	override function create()
	{
		var fullText:Dynamic = Assets.getText(Paths.txt('credits'));
		var firstArray:Array<String> = fullText.split('\n');

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Credits", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		add(bg);

		creditgroup = new FlxTypedGroup<Alphabet>();
		add(creditgroup);

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('|'));
		}

		for (i in swagGoodArray)
		{
			var text:Alphabet;
			if(i.length <= 1)
			{
				text = new Alphabet(0, (70 * menuitemnumber) + 30, i[0], true, false);
			}
			else
			{
				text = new Alphabet(0, (70 * menuitemnumber) + 30, i[0], false, false);
			}
			text.isMenuItem = true;
			text.targetY = menuitemnumber;
			creditgroup.add(text);
			var icon:HealthIcon = new HealthIcon(i[1], false, true);
			icon.sprTracker = text;
			iconArray.push(icon);
			add(icon);
			if(i.length <= 1)
			{
				text.numberstuff = 50;
				remove(icon);
				unselectedlist.push(i);
			}
			else
			{
				selectedlist.push(i);
			}
			menuitemnumber += 1;
		}

		changeSelection(1);
		changeSelection(-1);

		super.create();
	}

	override function update(elapsed:Float)
	{
		for (item in creditgroup.members)
		{
			item.screenCenter(X);
		}
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			FlxG.openURL(swagGoodArray[curSelected][2]);
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = swagGoodArray.length - 1;
		if (curSelected >= swagGoodArray.length)
			curSelected = 0;

		var bullShit:Int = 0;

		if(swagGoodArray[curSelected].length >= 2)
		{
			for (i in 0...iconArray.length)
			{
				iconArray[i].alpha = 0.6;
			}
		
			iconArray[curSelected].alpha = 1;
		}

		FlxTween.color(bg, 0.5, bg.color, CoolUtil.healthbarcolor(iconArray[curSelected]), {type: FlxTweenType.PERSIST, ease: FlxEase.sineInOut});

		for (item in creditgroup.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;
	
			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));
			if(item.length <= 1)
				item.alpha = 1;
			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
			if(swagGoodArray[curSelected].length <= 1)
				item.alpha = 1;
		}
		if(swagGoodArray[curSelected].length <= 1)
			changeSelection(change);
	}
}
