_sound = _this select 0;
_obj = if ((count _this) > 1) then { _this select 1 } else { objNull };
_radius = 30;

if (isNull _obj) then
{
	[
		[
			[_sound],
			{ playSound (_this select 0); }
		],
		"BIS_fnc_spawn",
		true,
		false
	] call BIS_fnc_MP;
} else {
	{
		if ((_x distance _obj) <= _radius) then
		{
			[
				[
					[_obj, _sound, _radius],
					{ (_this select 0) say [(_this select 1), (_this select 2)]; }
				],
				"BIS_fnc_spawn",
				_x,
				false
			] call BIS_fnc_MP;
		};
	} forEach playableUnits;
};
