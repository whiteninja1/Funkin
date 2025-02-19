package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import sys.FileSystem;

class Paths
{
	inline public static var SOUND_EXT = "ogg";

	static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		if (FileSystem.exists('mods/' + Mod.selectedmod + '/$file') == true)
			return 'mods/' + Mod.selectedmod + '/$file';
		else
			return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		if (FileSystem.exists('mods/' + Mod.selectedmod + '/' + file) == true)
			return 'mods/' + Mod.selectedmod + '/' + file;
		else
			return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String)
	{
		if (FileSystem.exists('mods/' + Mod.selectedmod +'/songs/${song.toLowerCase()}/Voices.$SOUND_EXT') == true)
			return 'mods/' + Mod.selectedmod +'/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
		else
			return 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}

	inline static public function inst(song:String)
	{
		if (FileSystem.exists('mods/' + Mod.selectedmod +'/songs/${song.toLowerCase()}/Inst.$SOUND_EXT') == true)
			return 'mods/' + Mod.selectedmod +'/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
		else
			return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}

	inline static public function image(key:String, ?library:String)
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function font(key:String)
	{
		if (FileSystem.exists('mods/' + Mod.selectedmod +'/fonts/$key') == true)
			return 'mods/' + Mod.selectedmod +'/fonts/$key';
		else
			return 'assets/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	inline static public function modpath()
	{
		var mods:Array<String> = [];
		var directory:String = 'mods/';
		if (sys.FileSystem.exists(directory))
		{
			for (file in sys.FileSystem.readDirectory(directory))
			{
				  if (sys.FileSystem.isDirectory(directory))
				{
					mods.push(haxe.io.Path.addTrailingSlash(directory));
					modpath();
				}
			}
		}
		return mods;
	}

	inline static public function findfile(library:String)
	{
		var foundfiles:Array<String> = [];
		var something = ['assets/'];
		something.push('mods/' + Mod.selectedmod);
		for(i in something)
		{
			var directory:String = i + library;
			if (sys.FileSystem.exists(directory))
			{
				for (file in sys.FileSystem.readDirectory(directory))
				{
					  if (sys.FileSystem.isDirectory(directory))
					{
						foundfiles.push(haxe.io.Path.addTrailingSlash(directory));
						modpath();
					}
				}
			}
		}
		return foundfiles;
	}
}
