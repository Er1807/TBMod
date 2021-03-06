﻿/*
    Part of the TBMod ( https://github.com/shukari/TBMod )
    Developed by http://tacticalbacon.de

    Author: shukari, Eric Ruhland
*/
params [
        ["_save", false, [false]],
        ["_number", 0, [0]],
        ["_dontAddToArray", false, [false]]
    ];

if (!isServer) exitWith {"[TBMod_building] NUR auf dem Server ausführen" remoteExecCall ["systemChat"]};
if !(_number in [1,2,3,4,5]) exitWith {"[TBMod_building] Wähle einen Slot zwischen 1-5" remoteExecCall ["systemChat"]};

if (_save) then
{
    if (isNil "TB_persistent_buildings") then {TB_persistent_buildings = []};
    private _array = [];
    
    {
        _x params ["_obj", "_big"];
        
        if (!isNil "_obj" && {!isNull _obj}) then
        {
            _array pushBack [
                    _big,
                    typeOf _obj,
                    getPosASL _obj,
                    getDir _obj,
                    simulationEnabled _obj,
                    _obj getVariable ["TB_building_addInfos", []]
                ];
        };
    }
    forEach TB_persistent_buildings;
    
    profileNamespace setVariable [format ["TB_persistent_buildings_%1", _number], _array];
    (format ["[TBMod_building] Es wurde alles in Slot %1 gespeichert!", _number]) remoteExecCall ["systemChat"];
}
else //laden
{
    private _array = profileNamespace getVariable [format ["TB_persistent_buildings_%1", _number], []];
    
    if (_array isEqualTo []) exitWith {"[TBMod_building] Nichts zum Laden verfügbar!" remoteExecCall ["systemChat"]};
    if (isNil "TB_persistent_buildings") then {TB_persistent_buildings = []};
    
    {
        _x params ["_big", "_classname", "_pos", "_dir", "_sim", "_addInfos"];
        
        private _obj = createVehicle [_classname, [0,0,0], [], 0, "CAN_COLLIDE"];
        
        _obj setDir _dir;
        _obj setPosASL _pos;
        
        private _params = [_obj];
        _params append _addInfos;
        
        if (_big) then
        {
            _params spawn TB_fnc_initItemBig;
        }
        else
        {
            _params spawn TB_fnc_initItem;
        };
        
        if (!_sim) then {_obj enableSimulationGlobal false};
        
        if (!_dontAddToArray) then {TB_persistent_buildings pushBack [_obj, _big]};
        
        // Medic
        if ((typeOf _obj) in ["Land_Medevac_house_V1_F", "Land_MedicalTent_01_white_generic_open_F"]) then
        {
            _obj setVariable ["ace_medical_isMedicalFacility", true, true];
        };
        
        // Antenne
        if ((typeOf _obj) in ["Land_TTowerSmall_1_F"]) then
        {
            // wait for TFAR FIX
            //[_obj, 10000] call TFAR_antennas_fnc_initRadioTower;
        };
        
        // Antenne
        if ((typeOf _obj) in ["Land_BarGate_F"]) then
        {
            _obj allowDamage false;
            _obj addEventHandler {0};
        };
        
        // Repair
        if ((typeOf _obj) in ["B_Slingload_01_Repair_F"]) then
        {
            _obj enableRopeAttach false;
        };
    }
    forEach _array;
    
    publicVariable "TB_persistent_buildings";
    (format ["[TBMod_building] Es wurde alles aus Slot %1 geladen!", _number]) remoteExecCall ["systemChat"];
};
