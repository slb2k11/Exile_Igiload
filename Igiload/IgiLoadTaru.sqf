/*
This script is based on Xeno Taru mod from NorX Aengell.
http://www.armaholic.com/page.php?id=27532

Original author: NorX Aengell
Rewrite and Epoch adaptation: Slayer

*/

IL_Taru_DevMod = false;

//above this altitude dropping with parachute
IL_Taru_Parachute_Altitude = 70;

//open parachute when altitude is less or equal this parameter
IL_Taru_Parachute_Open_Altitude = 120;
//IL_Taru_Parachute_Altitude must be greater then IL_Taru_Parachute_Open_Altitude

IL_Taru_Disable_Deattaching_Altitude = 3;
//Not posible to deattach when altitude is extrely low, because new position of pod will be under terrain level.
//Recomended values are between 3 and 10.

if (hasInterface && !isDedicated) then {
    if (IL_Taru_DevMod) then {
         diag_log "Igi Load Taru started";
    };

    IL_Taru_Init =
    {
        waituntil
        {
            sleep 2;

            {
                if (isnil {_x getVariable "IL_Taru_Action_Attach"}) then
                {
                    _x setVariable ["IL_Taru_Action_Attach",true,false];

                    IL_Taru_Action_Attach = _x addAction ["<img image='IgiLoad\images\load.paa' /><t color=""#007f0e""> Attach the Pod</t>", "[""attach"",_this] call IL_Taru_Do_Action;", nil, 2, false, true, "",
                    "[_this] call IL_Verify_Heli and {[vehicle _this] call IL_Verify_Pod} and {!([vehicle _this] call IL_Verify_Attached_Object)}"];
                };

                if (isnil {_x getVariable "IL_Taru_Action_Deattach"}) then
                {
                    _x setVariable ["IL_Taru_Action_Deattach",true,false];

                    IL_Taru_Action_Deattach = _x addAction ["<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000""> Detach the Pod</t>", "[""deattach"",_this] call IL_Taru_Do_Action;", nil, 2, false, true, "",
                    "[_this] call IL_Verify_Heli and [_this] call IL_Verify_Altitude and {[vehicle _this] call IL_Verify_Attached_Object}"];
                };

                if (isnil {_x getVariable "IL_Taru_Action_Drop"}) then
                {
                    _x setVariable ["IL_Taru_Action_Drop",true,false];

                    IL_Taru_Action_Drop = _x addAction ["<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff""> Drop the Pod</t>", "[""drop"",_this] call IL_Taru_Do_Action;", nil, 2, false, true, "",
                    "[_this] call IL_Verify_Heli and {[vehicle _this] call IL_Verify_Attached_Object}"];
                };
            } foreach units group player;
        };
    };

    IL_Verify_Attached_Object =
    {
        if (IL_Taru_DevMod) then {
            diag_log "IL_Verify_Attached_Object called";
        };
        _helico = (_this select 0);
        _object_Verifier = false;
        if (count (attachedObjects _helico) isEqualTo 0) exitwith {_object_Verifier};
        {
            if (_x isKindOf "Pod_Heli_Transport_04_base_F") exitwith {_object_Verifier = true;};
        } foreach attachedObjects _helico;
        if (IL_Taru_DevMod) then {
             diag_log format["IL_Verify_Attached_Object returns %1",_object_Verifier];
        };
        _object_Verifier
    };

    IL_Verify_Pod =
    {
        if (IL_Taru_DevMod) then {
            diag_log "IL_Verify_Pod called";
        };
        _pod = getSlingLoad (_this select 0);
        _pod_Verifier = false;
        if (isnull (getSlingLoad vehicle player)) exitwith {_pod_Verifier};
        if (_pod isKindOf "Pod_Heli_Transport_04_base_F") then {_pod_Verifier = true;};
        if (IL_Taru_DevMod) then {
             diag_log format["IL_Verify_Pod returns %1",_pod_Verifier];
        };
        _pod_Verifier
    };

    IL_Verify_Heli =
    {
        if (IL_Taru_DevMod) then {
            diag_log "IL_Verify_Heli called";
        };
        _helico = vehicle (_this select 0);
        _helico_Verifier = false;
        if (_helico isKindOf "Heli_Transport_04_base_F") then {_helico_Verifier = true;};
        if (IL_Taru_DevMod) then {
             diag_log format["IL_Verify_Heli returns %1",_helico_Verifier];
        };
        _helico_Verifier
    };

    IL_Verify_Altitude = {
        if (IL_Taru_DevMod) then {
            diag_log "IL_Verify_Altitude called";
        };
        _helico = vehicle (_this select 0);
        _allow_deattach = false;
        if ((getPosATL _helico) select 2 > IL_Taru_Disable_Deattaching_Altitude) then {_allow_deattach = true;};
        if (IL_Taru_DevMod) then {
             diag_log format["IL_Verify_Altitude returns %1",_allow_deattach];
        };
        _allow_deattach
    };

    IL_Taru_Do_Action =
    {
        _action = _this select 0;
        _helico = "";

        if (typename (_this select 1) isEqualTo "OBJECT") then {_helico = vehicle (_this select 1);};
        if (typename (_this select 1) isEqualTo "ARRAY") then {_helico = vehicle ((_this select 1) select 0);};

        _cables = ropes _helico;

        if (ropeUnwound (_cables select 0)) then
        {
            [_action, _helico] call IL_Pod_Manager;
        };
    };

    IL_Taru_Transmission =
    {
        private ["_soundToPlay", "_helico", "_soundToPlay","_args","_pod"];
        _args = _this select 1;
        _helico = vehicle (_args select 1);
        _soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;

        switch (_args select 0) do {
            case 'rope_unwind': {
                _pod = _args select 2;
                _helico disableCollisionWith _pod;
                {ropeUnwind [_x, _args select 3, _args select 4];} foreach ropes _helico;
                sleep 4;
                _helico enableCollisionWith _pod;
            };
            case 'rope_unwind_and_wait': {
                _pod = _args select 2;
                _helico disableCollisionWith _pod;
                {ropeUnwind [_x, _args select 3, _args select 4];} foreach ropes _helico;
                waituntil {ropeLength ((ropes _helico) select 0) isEqualTo 1};
                sleep 4;
                _helico enableCollisionWith _pod;
            };
            case 'chat_attach': {
                 if (!(player in crew _helico)) exitWith{};
                 ["Success",["Pod successfully attached!"]] call ExileClient_gui_notification_event_addNotification;
            };
            case 'chat_deattach': {
                if (!(player in crew _helico)) exitWith{};
				 ["Success",["Pod successfully dettached!"]] call ExileClient_gui_notification_event_addNotification;
            };
            case 'chat_drop_with_parachute': {
                 if (!(player in crew _helico)) exitWith{};
                 ["Success",["Pod Paradropt!"]] call ExileClient_gui_notification_event_addNotification;
            };
            case 'chat_drop_without_parachute': {
                 if (!(player in crew _helico)) exitWith{};
                 ["Success",["Pod drop without Parachut!"]] call ExileClient_gui_notification_event_addNotification;
            };
            case 'sound_attach': {
                 if (!(player in crew _helico)) exitWith{};
                 _soundToPlay = _soundPath + "IgiLoad\sounds\attach.wss";
                 playSound3D [_soundToPlay, _helico, false, getPosATL _helico, 10, 1, 0];
            };
            case 'sound_deattach': {
                 if (!(player in crew _helico)) exitWith{};
                 _soundToPlay = _soundPath + "IgiLoad\sounds\deattach.wss";
                 playSound3D [_soundToPlay, _helico, false, getPosATL _helico, 10, 1, 0];
            };
            case 'sound_drop': {
                 if (!(player in crew _helico)) exitWith{};
                 _soundToPlay = _soundPath + "IgiLoad\sounds\drop.wss";
                 playSound3D [_soundToPlay, _helico, false, getPosATL _helico, 10, 1, 0];
            };
        };
    };

    waitUntil {!isNull player};
    [] spawn IL_Taru_Init;
    IL_Taru_EH_Respawn = player addEventHandler ["Respawn", "[] spawn IL_Taru_Init;"];
};

IL_Pod_Manager = {
    IL_CLient_Pod_Manager = _this;
    if (isDedicated || isServer) then
    {
        IL_CLient_Pod_Manager spawn IL_Server_Pod_Manager;
    }
    else
    {
        publicVariableServer "IL_CLient_Pod_Manager";
    };
};
"IL_Client_Pod_Manager" addPublicVariableEventHandler IL_Pod_Manager;

IL_Client_Control = {
    private ["_nearBy","_heli","_heli_pos"];
    IL_Server_Client_Control = _this;
    if (hasInterface && !isDedicated) then
    {
        IL_Server_Client_Control spawn IL_Taru_Transmission; Exile_
    }
    else
    {
        _heli = IL_Server_Client_Control select 1;
        _nearBy = (getPosATL _heli) nearEntities [["Exile_Unit_Player","LandVehicle","Ship","Air"], 300];
        {
            if (isPlayer _x) then {
                (owner _x) publicVariableClient "IL_Server_Client_Control";
            };
        } forEach _nearBy;
    };
};
"IL_Server_Client_Control" addPublicVariableEventHandler IL_Client_Control;


if (isDedicated || isServer) then {
    if (IL_Taru_DevMod) then {
         diag_log "Igi Load Taru started";
    };

    IL_Server_Pod_Manager = {
        private ["_args"];
        _args = _this select 1;
        switch (_args select 0) do {
            case "attach": {
                 [_args select 1] spawn IL_Taru_Attach_Pod;
            };
            case "deattach": {
                 [_args select 1] spawn IL_Taru_Deattach_Pod;
            };
            case "drop": {
                 [_args select 1] spawn IL_Taru_Drop_Pod;
            };
        };
    };

    IL_Taru_Attach_Pod =
    {
        _helico = _this select 0;
        _pod = getSlingLoad _helico;
        _mass_of_pod = getmass getSlingLoad _helico;
        _mass_of_heli = getmass _helico;

        if (!isTouchingGround _helico) then
        {

            ["sound_attach", _helico] call IL_Client_Control;
            ["rope_unwind_and_wait", _helico, _pod, 1.9, 1, 1] call IL_Client_Control;
            sleep 1;
            {ropeUnwind [_x, 1.9, 1];} foreach ropes _helico;

            waituntil {ropeLength (ropes _helico select 0) isEqualTo 1};

        };

        _helico disableCollisionWith _pod;
        [] call {
            _pod_type = typeOf _pod;
            if (_pod_type isEqualTo "Land_Pod_Heli_Transport_04_bench_F") exitwith
            {
                _pod attachTo [_helico,[0,0.1,-1.13]];
                _helico setCustomWeightRTD 680;
                _helico setmass _mass_of_pod + _mass_of_heli;
            };

            if (_pod_type isEqualTo "Land_Pod_Heli_Transport_04_covered_F") exitwith
            {
                _pod attachTo [_helico,[-0.1,-1.05,-0.82]];
                _helico setCustomWeightRTD 1413;
                _helico setmass _mass_of_pod + _mass_of_heli;
            };

            if (_pod_type isEqualTo "Land_Pod_Heli_Transport_04_fuel_F") exitwith
            {
                _pod attachTo [_helico,[0,-0.282,-1.25]];
                _helico setCustomWeightRTD 13311;
                _helico setmass _mass_of_pod + _mass_of_heli;
            };

            if (_pod_type isEqualTo "Land_Pod_Heli_Transport_04_medevac_F") exitwith
            {
                _pod attachTo [_helico,[-0.14,-1.05,-0.92]];
                _helico setCustomWeightRTD 1321;
                _helico setmass _mass_of_pod + _mass_of_heli;
            };

            if (_pod_type in ["Land_Pod_Heli_Transport_04_repair_F","Land_Pod_Heli_Transport_04_box_F","Land_Pod_Heli_Transport_04_ammo_F"]) exitwith
            {
                _pod attachTo [_helico,[-0.09,-1.05,-1.1]];
                _helico setCustomWeightRTD 1270;
                _helico setmass _mass_of_pod + _mass_of_heli;
            };
         };

        ["rope_unwind", _helico, _pod, 250, 1] call IL_Client_Control;
        sleep 1;
        {ropeUnwind [_x, 250, 1];} foreach ropes _helico;
        _helico enableCollisionWith _pod;
        ["sound_attach", _helico] call IL_Client_Control;
        ["chat_attach", _helico] call IL_Client_Control;

        if (isnil {_helico getVariable "EH_GetOut_Taru"}) then
        {
            _helico addEventHandler ["Getin", "[_this] spawn IL_Taru_GetIn;"];
            _helico setVariable ["EH_GetIn_Taru", true, false];
        };
    };

    IL_Taru_Deattach_Pod =
    {
        _helico = _this select 0;
        _attached_object = [];
        _mass_of_heli = getmass _helico;
        {
            if (_x isKindOf "Pod_Heli_Transport_04_base_F") exitwith {_attached_object = _x;};
        } foreach attachedObjects _helico;

        _mass_of_pod = getmass _attached_object;
        _helico disableCollisionWith _attached_object;

        [] call {
            _pod_type = typeOf _attached_object;
            if (_pod_type isEqualTo "Land_Pod_Heli_Transport_04_bench_F") exitwith
            {
                _attached_object attachTo [_helico,[0,0.1,-2.83]];
            };

            if (_pod_type isEqualTo "Land_Pod_Heli_Transport_04_covered_F") exitwith
            {
                _attached_object attachTo [_helico,[-0.1,-1.05,-2.52]];
            };

            if (_pod_type isEqualTo "Land_Pod_Heli_Transport_04_fuel_F") exitwith
            {
                _attached_object attachTo [_helico,[0,-0.282,-3.05]];
            };

            if (_pod_type isEqualTo "Land_Pod_Heli_Transport_04_medevac_F") exitwith
            {
                _attached_object attachTo [_helico,[-0.14,-1.05,-2.62]];
            };

            if (_pod_type in ["Land_Pod_Heli_Transport_04_repair_F","Land_Pod_Heli_Transport_04_box_F","Land_Pod_Heli_Transport_04_ammo_F"]) exitwith
            {
                _attached_object attachTo [_helico,[-0.09,-1.05,-2.8]];
            };
        };

        ["rope_unwind", _helico, _attached_object, 1,9, 10] call IL_Client_Control;
        sleep 1;
        {
            ropeUnwind [_x, 1.9, 10];
        } foreach ropes _helico;
        ["sound_deattach", _helico] call IL_Client_Control;

        _helico setCustomWeightRTD 0;
        _helico setmass _mass_of_heli - _mass_of_pod;
        ["sound_deattach", _helico] call IL_Client_Control;
        ["chat_deattach", _helico] call IL_Client_Control;
        detach _attached_object;
        sleep 4;
        _helico enableCollisionWith _attached_object;
        //if (!isTouchingGround _helico) then {waituntil {ropeLength (ropes _helico select 0) isEqualTo 10};};
    };

    IL_Taru_Drop_Pod =
    {
        _helico = _this select 0;
        _attached_object = [];

        {
            if (_x isKindOf "Pod_Heli_Transport_04_base_F") exitwith {_attached_object = _x;};
        } foreach attachedObjects _helico;

        _helico disableCollisionWith _attached_object;
        {ropeCut [_x, 0];} foreach ropes _helico;
        _helico setCustomWeightRTD 0;
        ["sound_drop", _helico] call IL_Client_Control;
        detach _attached_object;
        sleep 4;
        _helico enableCollisionWith _attached_object;

        sleep 0.5;

        if ((getPosATL _attached_object) select 2 >= IL_Taru_Parachute_Altitude) exitwith
        {
            ["chat_drop_with_parachute", _helico] call IL_Client_Control;

            waituntil {(getPosATL _attached_object) select 2 <= IL_Taru_Parachute_Open_Altitude};

            _parachute = createVehicle ["B_Parachute_02_F",getposatl _attached_object, [], 0, "CAN COLLIDE"];
            _parachute attachTo [_attached_object,[0,0,-1]];

            [_attached_object,_parachute,_helico] spawn
            {
                _attached_object = _this select 0;
                _parachute = _this select 1;
                _helico = _this select 2;

                waituntil
                {
                    if ((getPosATL _attached_object) select 2 <= 5) exitwith
                    {
                        detach _attached_object;
                        _vitesse_nacelle = velocity _attached_object;
                        _parachute setVelocity [_vitesse_nacelle select 0 + 1, _vitesse_nacelle select 1 + 1, 0];
                        true
                    };
                    false
                };
            };

            waituntil
            {
                if (getposasl _helico distance getposasl _attached_object >= 50) exitwith
                {
                    detach _parachute;
                    _attached_object attachTo [_parachute,[0,0,-1]];
                    true
                };
                false
            };
        };

        ["chat_drop_without_parachute", _helico] call IL_Client_Control;
    };

    IL_Taru_GetIn =
    {
        _vehicle = _this select 0 select 0;
        if ([_vehicle] call IL_Verify_Heli) then
        {
            if (count attachedObjects _vehicle > 0) then
            {
                _time = time + 2;
                waituntil
                {
                    _vehicle setvelocity [0, 0, 0];
                    if (time > _time or {time > _time + 15}) exitwith {true};
                };
            };
        };
    };

    IL_Save_Pod_Position =
    {
        while{true}do {
            sleep 20;
            {
               sleep 2;
               //when you dropping with parachute or deattaching pod without player, new position of the pod is not saved to db.
               //with following ugly hack we are saving pod position every 20 seconds
               if (_x isKindOf "Pod_Heli_Transport_04_base_F") then {
                  _x call ExileServer_object_vehicle_database_update;
               };
            } forEach vehicles;
        };
    };

    [] spawn IL_Save_Pod_Position;
};
