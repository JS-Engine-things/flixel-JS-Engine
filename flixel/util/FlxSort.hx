package flixel.util;

import flixel.FlxObject;

/**
 * Helper class for sort() in FlxTypedGroup, but could theoretically be used on regular arrays as well.
 */
class FlxSort
{
	public static inline var ASCENDING:Int = -1;
	public static inline var DESCENDING:Int = 1;

	/**
	 * You can use this function in FlxTypedGroup.sort() to sort FlxObjects by their y values.
	 */
	public static inline function byY(Order:Int, Obj1:FlxObject, Obj2:FlxObject):Int
	{
		return byValues(Order, Obj1.y, Obj2.y);
	}
	
	/**
	 * You can use this function in FlxTypedGroup.sort() to sort FlxObjects by their z-index values.
	 * The value defaults to 0, but by assigning it you can easily rearrange objects as desired.
	 *
	 * @param order Either `FlxSort.ASCENDING` or `FlxSort.DESCENDING`
	 * @param a The first FlxObject to compare.
	 * @param b The second FlxObject to compare.
	 * @return 1 if `a` has a higher z-index, -1 if `b` has a higher z-index.
	 */
	public static inline function byZIndex(order:Int, a:FlxBasic, b:FlxBasic):Int {
		if (a == null || b == null)
			return 0;
		return byValues(order, a.zIndex, b.zIndex);
	}

	/**
	 * You can use this function as a backend to write a custom sorting function (see byY() for an example).
	 *
	 * @param order The sorting order; use FlxSort.ASCENDING or FlxSort.DESCENDING.
	 * @param value1 First value to compare.
	 * @param value2 Second value to compare.
	 * @return Sorting value: -1, 0, or 1.
	 */
	public static inline function byValues(order:Int, value1:Float, value2:Float):Int {
		return (value1 < value2) ? order : ((value1 > value2) ? -order : 0);
	}
}
