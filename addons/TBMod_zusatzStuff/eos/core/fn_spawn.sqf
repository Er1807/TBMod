/*
    Part of the TBMod ( https://github.com/shukari/TBMod )
    Developed by http://tacticalbacon.de
    
    Author:
        bangabob ( https://forums.bohemia.net/forums/topic/144150-enemy-occupation-system-eos/ )
  
    Complete rewrite and modification:
        shukari
        Eric Ruhlnd
*/
if (!isServer) exitWith {{"[TBMod_zusatzStuff] EOS-SPAWN: nur auf Server ausführen" remoteExecCall [_x]} forEach ["systemChat", "diag_log"]};
if (!canSuspend) exitWith {{"[TBMod_zusatzStuff] EOS-SPAWN: nur per spawn aufrufen" remoteExecCall [_x]} forEach ["systemChat", "diag_log"]};

params [
        ["_mkrs", [], [[]]],
        ["_hausInf", [], [[]]],
        ["_patrolInf", [], [[]]],
        ["_lightVeh", [], [[]]],
        ["_armorVeh", [], [[]]],
        ["_statics", [], [[]]],
        ["_helis", [], [[]]],
        ["_settings", [], [[]], 5]
    ];

_hausInf params ["_hiGroups", "_hiSize", ["_hiGroupsIncrease", 0], ["_hiSizeIncrease", 0]];
_patrolInf params ["_piGroups", "_piSize", ["_piGroupsIncrease", 0], ["_piSizeIncrease", 0]];
_lightVeh params ["_lvGroups", "_lvSize", ["_lvGroupsIncrease", 0], ["_lvSizeIncrease", 0]];
_armorVeh params ["_avGroups", ["_avGroupsIncrease", 0]];
_statics params ["_stGroups", ["_stGroupsIncrease", 0]];
_helis params ["_hGroups", "_hSize", ["_hGroupsIncrease", 0], ["_hSizeIncrease", 0]];

waitUntil {!isNil "tb_server" && {!isNull tb_server}};

{
    private _eosMarkers = tb_server getVariable ["EOSmarkers", []];
    _eosMarkers pushBack _x;
    tb_server setVariable ["EOSmarkers", _eosMarkers, true];
    
    [
        _x,
        [_hiGroups, _hiSize, _hiGroupsIncrease, _hiSizeIncrease],
        [_piGroups, _piSize, _piGroupsIncrease, _piSizeIncrease],
        [_lvGroups, _lvSize, _lvGroupsIncrease, _lvSizeIncrease],
        [_avGroups, _avGroupsIncrease], 
        [_stGroups, _stGroupsIncrease], 
        [_hGroups, _hSize, _hGroupsIncrease, _hSizeIncrease],
        _settings
    ] spawn TB_EOS_fnc_core;
}
forEach _mkrs;
