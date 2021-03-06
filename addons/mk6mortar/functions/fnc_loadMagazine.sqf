/*
 * Author: Grey
 * Loads Magazine into static weapon
 *
 * Arguments:
 * 0: static <OBJECT>
 * 1: unit <OBJECT>
 * 2: magazine class to load; if not given the first compatible magazine is loaded <STRING> (default: "")
 *
 * Return Value:
 * None
 *
 * Example:
 * [_target,_player,"ACE_1Rnd_82mm_Mo_HE"] call ace_mk6mortar_fnc_loadMagazine
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_static","_unit",["_magazineClassOptional","",[""]]];
private ["_weapon","_currentMagazine","_count","_magazines","_magazineDetails","_listOfMagNames",
    "_magazineClass","_magazineClassDetails","_parsed","_roundsLeft"];

//If function has been called with an optional classname hten add that magazine to the static weapon. Otherwise add the compatible magazine
if(_magazineClassOptional != "") then {
    _unit removeMagazine _magazineClassOptional;
    [QGVAR(addMagazine), [_static, _magazineClassOptional]] call EFUNC(common,globalEvent);
} else {
    //Get weapon & magazine information of static weapon
    _weapon = (_static weaponsTurret [0]) select 0;
    _currentMagazine = (magazinesAllTurrets _static) select 1;
    _currentMagazineClass = _currentMagazine select 0;
    _count = _currentMagazine select 2;

    //Check all of the players magazines to see if they are compatible with the static weapon. First magazine that is compatible is chosen
    //VKing: This section ought to be double checked.
    _magazines = magazines _unit;
    _magazineDetails = magazinesDetail _unit;
    _listOfMagNames = getArray(configFile >> "cfgWeapons" >> _weapon >> "magazines");
    _magazineClass = "";
    _magazineClassDetails = "";
    _parsed  ="";
    _roundsLeft = 0;
    {
        if (_x in _listOfMagNames) exitWith {
            _magazineClass = _x;
            _magazineClassDetails = _magazineDetails select _forEachIndex;
        };
    } forEach _magazines;
    //If the static weapon already has an empty magazine then remove it
    if (_count == 0) then {
        [QGVAR(removeMagazine), [_static, _currentMagazineClass]] call EFUNC(common,globalEvent);
    };
    //Find out the ammo count of the compatible magazine found
    if (_magazineClassDetails != "") then{
        _parsed = _magazineClassDetails splitString "([]/: )";
        _parsed params ["_type", "", "", "_roundsLeftText", "_maxRoundsText"];
        _roundsLeft = parseNumber _roundsLeftText;
        _magType = _type;
    };

    _unit removeMagazine _magazineClass;
    [QGVAR(addMagazine), [_static, _magazineClass]] call EFUNC(common,globalEvent);
    [QGVAR(setAmmo), _static, [_static, _magazineClass,_roundsLeft]] call EFUNC(common,targetEvent);
};
