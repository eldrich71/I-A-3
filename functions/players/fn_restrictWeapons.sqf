private ["_allItems", "_class", "_lastIndex", "_i", "_role", "_items", "_restricted", "_primary", "_secondary", "_base", "_x", "_name"];

role = player getVariable ["role", "none"];

_allItems = [];
_restricted = [];
_latestRole = "";

_class = missionConfigFile >> "CfgRespawnInventory";
_lastIndex = ((count _class) - 1);

for "_i" from 0 to _lastIndex do
{
	_role = _class select _i;
	_items = getArray (_role >> "items");
	
	{
		if (!(_x in _allItems)) then
		{
			_allItems = _allItems + [_x];
		};
	} forEach _items;
};

while { true } do
{
	sleep 1;

	if (_latestRole != role) then
	{
		_latestRole = player getVariable ["role", "none"];

		_safeItems = getArray (missionConfigFile >> "CfgRespawnInventory" >> role >> "items");
		_toRemove = [_allItems, {_x in _safeItems}] call BIS_fnc_conditionalSelect;
		_restricted = (_allItems - _toRemove);
	};

	_primary = primaryWeapon player;
	_secondary = secondaryWeapon player;
	_backpack = backpack player;

	{
		_item = _x select 0;
		_config = _x select 1;

		_class = configName (inheritsFrom (configFile >> _config >> _item));
		_base = configName (inheritsFrom (configFile >> _config >> _class));

		if ((_item in _restricted) || (_class in _restricted) || (_base in _restricted)) then
		{
			switch (_config) do
			{
				case "CfgWeapons": { player removeWeapon _item; };
				case "CfgBackpacks": { removeBackpack player; };
			};

			//Needs alternative command for restricted backpack removal
			_name = getText (configFile >> _config >> _item >> "displayName");
			hint parseText format["<t color='#FF0000' size='2.2'>Restricted<br/>Item</t><br/>--------------------<br/>You class you have selected is not qualified to use the %1.<br/><br/>Make sure to play your class!", _name];
		};
	} forEach [[_primary, "CfgWeapons"], [_secondary, "CfgWeapons"], [_backpack, "CfgBackpacks"]];
};