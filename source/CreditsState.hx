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

using StringTools;

class CreditsState extends MusicBeatState
{
	private var curSelected:Int = 0;
	private var iconArray:Array<HealthIcon> = [];
	private var ynumber = 0;
	private var creditgroup:FlxTypedGroup<Alphabet>;
	var swagGoodArray:Array<Array<String>> = [];
	var unselectedlist:Array<Array<String>> = [];
	var selectedlist:Array<Array<String>> = [];
	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG'));

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
			var text:Alphabet = new Alphabet(0, 0, i[0], true, false);
			text.screenCenter(X);
			text.isMenuItem = true;
			creditgroup.add(text);
			if(i.length <= 1)
			{
				text.y = ynumber + 10;
				ynumber += 100;
			}
			else
			{
				var icon:HealthIcon = new HealthIcon(i[1], false, true);
				icon.sprTracker = text;
				iconArray.push(icon);
				add(icon);
				text.y = ynumber;
				ynumber += 80;
			}
		}

		changeSelection(1);

		super.create();
	}

	override function update(elapsed:Float)
	{
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
			FlxG.openURL(selectedlist[curSelected][2]);
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

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;
		FlxTween.color(bg, 0.5, bg.color, CoolUtil.healthbarcolor(iconArray[curSelected]), {type: FlxTweenType.PERSIST, ease: FlxEase.sineInOut});

		for (item in creditgroup.members)
		{
			if(!swagGoodArray[curSelected].length <= 1)
			{
				item.targetY = bullShit - curSelected;
				bullShit++;

				item.alpha = 0.6;
				// item.setGraphicSize(Std.int(item.width * 0.8));

				if (item.targetY == 0)
				{
					item.alpha = 1;
					// item.setGraphicSize(Std.int(item.width));
				}
			}
			else
			{
				item.targetY = bullShit - curSelected;
				bullShit++;
			}
		}
	}
}
