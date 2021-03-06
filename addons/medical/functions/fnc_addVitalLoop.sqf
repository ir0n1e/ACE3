/*
 * Author: Glowbal
 * Enabled the vitals loop for a unit.
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 *
 * ReturnValue:
 * None
 *
 * Public: Yes
 */

#include "script_component.hpp"

params ["_unit", ["_force", false]];

if !([_unit] call FUNC(hasMedicalEnabled) || _force) exitWith {};

if !(local _unit) exitWith {
    ["addVitalLoop", _unit, [_unit, _force]] call EFUNC(common,targetEvent);
};

// Quit if the unit already has a vital loop, or is dead, unless it's forced
if ((_unit getVariable[QGVAR(addedToUnitLoop),false] || !alive _unit) && !_force) exitWith{};

// Schedule the loop to be executed again 1 sec later
// @todo: should the loop be started righ away instead?
_unit setVariable [QGVAR(addedToUnitLoop), true, true];
[DFUNC(vitalLoop), [_unit, ACE_time], 1] call EFUNC(common,waitAndExecute);
