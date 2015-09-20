//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	IgiLoad v0.9.10_RC_e_(Arma3_1.32)																		//
//	Version info: This is not official version of IgiLoad it is only WIP (RC)								//
//	Author: Igi_PL																							//
//	Web: http://www.igipl.net/																				//
//	Version date: 2014.10.16																				//
//																											//
//	USE:																									//
//	1. In mission "init.sqf" add line: "0 = execVM "IgiLoad\IgiLoadInit.sqf";".								//
//	2. In vehicles "INITIALIZATION" field type: "0 = [this] execVM "IgiLoad\IgiLoad.sqf";"					//
//	3. Unload from script or trigger:																		//
//		a) Unloading cargo from script. Force unload: "0 = [Car, true, "L"] spawn IL_Do_Unload;"			//
//		b) Unloading cargo from script. Force unload: "0 = [Car, true] spawn IL_Do_Unload;"					//
//		c) Unloading cargo from script. Force unload: "0 = [Car] spawn IL_Do_Unload;"						//
//	4. Loading cargo from script. Force load: "0 = [Car, [typeOf Box], "B", true, Box] spawn IL_Do_Load;"	//
//																											//
//	Ways from points 1 and 2 can not be used simultaneously!!!												//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

waitUntil { time > 0 };
IL_Script_Inst = time;
//	VARIABLES
_obj_main = _this select 0;
_obj_main_type = (typeOf _obj_main);

if (isnil "IL_Variables") then
{
	IL_Variables = true;
	//Check new vehicles time
	IL_Check_Veh_Min = 30;
	IL_Check_Veh_Max = 60;
	//Dealing with cargo damage
	//-1 - do nothing
	//0 - set to 0
	//1 - keep such as before loading/unloading
	IL_CDamage = 1;
	//AddAction menu position
	IL_Action_LU_Priority = 30; //Load and (para)unload
	IL_Action_O_Priority = 0;	//Open and close
	IL_Action_S_Priority = 0; //Setup
	//Maximum capacity for vehicles
	IL_Num_Slots_OFFROAD = -2;
	IL_Num_Slots_VAN = -3;
	IL_Num_Slots_MOHAWK = -7;
	IL_num_Slots_CHINOOK = -8;
	IL_Num_Slots_KAMAZ = -4;
	IL_Num_Slots_TEMPEST = -5;
	IL_Num_Slots_HEMTT = -6;
	IL_Num_Slots_MH9 = -1;
	IL_Num_Slots_C130J = -12;
	IL_Num_Slots_C17 = -22;
	//Player addScore after loading and unloading
	IL_Load_Score = 20;
	//Para unload score = 2 * IL_Unload_Score
	IL_Unload_Score = 10;
	//The minimum altitude for the drop with parachute
	IL_Para_Drop_ATL = 50;
	IL_Para_Jump_ATL = 30;
	//The minimum altitude for parachute opening
	IL_Para_Drop_Open_ATL = 150;
	IL_Para_Jump_Open_ATL = 150;
	//Parachute get velocity from player or cargo
	IL_Para_Drop_Velocity = true;
	IL_Para_Jump_Velocity = true;
	//Set smoke and light for parachute drop.
	IL_Para_Smoke = true;
	IL_Para_Light = true;
	//Additional smoke after landing
	IL_Para_Smoke_Add = true;
	//Additional light after landing
	IL_Para_Light_Add = true;
	//Smoke and light color
	IL_Para_Smoke_Default = "SmokeshellGreen";
	IL_Para_Light_Default = "Chemlight_green";
	IL_Para_Smoke_Veh = "SmokeshellBlue";
	IL_Para_Light_Veh = "Chemlight_blue";
	//This allows for loading or unloading, if a player is in the area of loading or copilot
	IL_Can_Inside = true;
	IL_Can_CoPilot = true;
	IL_Can_Outside = true;
	//IL_SDistU = 20;//No longer needed
	IL_SDistL = 2.5;
	IL_SDistL_Heli_offset = 1;
	//Load and unload (not para) max speed in km/h
	IL_LU_Speed = 10;
	//Load and unload (not para) max height in m
	IL_LU_Alt = 3;
	//Enable or disable usable cargo ramp in CH-49
	IL_Ramp = true;
	//Enable change of vehicle mass
	IL_Mass = true;

	
	IL_Supported_Vehicles_OFFROAD = ["Exile_Car_Offroad_Repair_Civillian", "Exile_Car_Offroad_Repair_Red", "Exile_Car_Offroad_Repair_Beige", "Exile_Car_Offroad_Repair_White", "Exile_Car_Offroad_Repair_Blue", "Exile_Car_Offroad_Repair_DarkRed", "Exile_Car_Offroad_Repair_BlueCustom", "Exile_Car_Offroad_Repair_Guerilla01", "Exile_Car_Offroad_Repair_Guerilla02", "Exile_Car_Offroad_Repair_Guerilla03", "Exile_Car_Offroad_Repair_Guerilla04", "Exile_Car_Offroad_Repair_Guerilla05", "Exile_Car_Offroad_Repair_Guerilla06", "Exile_Car_Offroad_Repair_Guerilla07", "Exile_Car_Offroad_Repair_Guerilla08", "Exile_Car_Offroad_Repair_Guerilla09", "Exile_Car_Offroad_Repair_Guerilla10", "Exile_Car_Offroad_Repair_Guerilla11", "Exile_Car_Offroad_Repair_Guerilla12", "Exile_Car_Offroad_Red", "Exile_Car_Offroad_Beige", "Exile_Car_Offroad_White", "Exile_Car_Offroad_Blue", "Exile_Car_Offroad_DarkRed", "Exile_Car_Offroad_BlueCustom", "Exile_Car_Offroad_Guerilla01", "Exile_Car_Offroad_Guerilla02", "Exile_Car_Offroad_Guerilla03", "Exile_Car_Offroad_Guerilla04", "Exile_Car_Offroad_Guerilla05", "Exile_Car_Offroad_Guerilla06", "Exile_Car_Offroad_Guerilla07", "Exile_Car_Offroad_Guerilla08", "Exile_Car_Offroad_Guerilla09", "Exile_Car_Offroad_Guerilla10", "Exile_Car_Offroad_Guerilla11", "Exile_Car_Offroad_Guerilla12", "Exile_Car_Offroad_Rusty1", "Exile_Car_Offroad_Rusty2", "Exile_Car_Offroad_Rusty3"];
	IL_Supported_Vehicles_VAN = ["Exile_Car_Van_Black", "Exile_Car_Van_White", "Exile_Car_Van_Red", "Exile_Car_Van_Guerilla01", "Exile_Car_Van_Guerilla02", "Exile_Car_Van_Guerilla03", "Exile_Car_Van_Guerilla04", "Exile_Car_Van_Guerilla05", "Exile_Car_Van_Guerilla06", "Exile_Car_Van_Guerilla07", "Exile_Car_Van_Guerilla08", "Exile_Car_Van_Box_Black", "Exile_Car_Van_Box_White", "Exile_Car_Van_Box_Red", "Exile_Car_Van_Box_Guerilla01", "Exile_Car_Van_Box_Guerilla02", "Exile_Car_Van_Box_Guerilla03", "Exile_Car_Van_Box_Guerilla04", "Exile_Car_Van_Box_Guerilla05", "Exile_Car_Van_Box_Guerilla06", "Exile_Car_Van_Box_Guerilla07", "Exile_Car_Van_Box_Guerilla08"];
	IL_Supported_Vehicles_HEMTT = ["Exile_Car_HEMMT"];
	IL_Supported_Vehicles_KAMAZ = ["I_Truck_02_covered_F","I_Truck_02_transport_F","Exile_Car_Zamak"];
	IL_Supported_Vehicles_TEMPEST = ["Exile_Car_Tempest"];
	IL_Supported_Vehicles_MOHAWK = ["Exile_Chopper_Mohawk_FIA"];
	IL_Supported_Vehicles_CHINOOK = ["Exile_Chopper_Huron_Black", "Exile_Chopper_Huron_Green"];
	IL_Supported_Vehicles_MH9 = ["Exile_Chopper_Hummingbird_Green","Exile_Chopper_Hummingbird_Civillian_Blue","Exile_Chopper_Hummingbird_Civillian_Red","Exile_Chopper_Hummingbird_Civillian_ION","Exile_Chopper_Hummingbird_Civillian_BlueLine","Exile_Chopper_Hummingbird_Civillian_Digital", "Exile_Chopper_Hummingbird_Civillian_Elliptical", "Exile_Chopper_Hummingbird_Civillian_Furious","Exile_Chopper_Hummingbird_Civillian_GrayWatcher", "Exile_Chopper_Hummingbird_Civillian_Jeans", "Exile_Chopper_Hummingbird_Civillian_Light", "Exile_Chopper_Hummingbird_Civillian_Shadow", "Exile_Chopper_Hummingbird_Civillian_Sheriff", "Exile_Chopper_Hummingbird_Civillian_Speedy","Exile_Chopper_Hummingbird_Civillian_Sunset", "Exile_Chopper_Hummingbird_Civillian_Vrana", "Exile_Chopper_Hummingbird_Civillian_Wasp", "Exile_Chopper_Hummingbird_Civillian_Wave"];
	IL_Supported_Vehicles_C130J = [];
	IL_Supported_Vehicles_C17 = [];

	IL_Supported_Vehicles_All = IL_Supported_Vehicles_C130J + IL_Supported_Vehicles_C17 + IL_Supported_Vehicles_MH9 + IL_Supported_Vehicles_MOHAWK + IL_Supported_Vehicles_KAMAZ + IL_Supported_Vehicles_TEMPEST + IL_Supported_Vehicles_HEMTT + IL_Supported_Vehicles_VAN + IL_Supported_Vehicles_OFFROAD + IL_Supported_Vehicles_CHINOOK;
	IL_Para_Drop_Vehicles = IL_Supported_Vehicles_MH9 + IL_Supported_Vehicles_MOHAWK + IL_Supported_Vehicles_C130J + IL_Supported_Vehicles_C17 + IL_Supported_Vehicles_CHINOOK;

	IL_Supported_Bicycles = ["Exile_Bike_OldBike", "Exile_Bike_MountainBike", "Exile_Bike_Crosser"];
	IL_Supported_HEMTT = ["Exile_Car_HEMMT"];
	IL_Supported_KAMAZ = ["I_Truck_02_covered_F","I_Truck_02_transport_F","Exile_Car_Zamak"];
	IL_Supported_TEMPEST = ["Exile_Car_Tempest"];
	IL_Supported_Strider = ["I_MRAP_03_hmg_F","Exile_Car_Strider"];
	IL_Supported_Hunter = ["B_MRAP_01_hmg_F","Exile_Car_Hunter"];
	IL_Supported_Ifrit = ["O_MRAP_02_hmg_F", "Exile_Car_Ifrit"];
	IL_Supported_UGV = ["B_UGV_01_rcws_F", "B_UGV_01_F", "O_UGV_01_rcws_F", "O_UGV_01_F", "I_UGV_01_rcws_F", "I_UGV_01_F"];
	IL_Supported_VAN = ["Exile_Car_Van_Black", "Exile_Car_Van_White", "Exile_Car_Van_Red", "Exile_Car_Van_Guerilla01", "Exile_Car_Van_Guerilla02", "Exile_Car_Van_Guerilla03", "Exile_Car_Van_Guerilla04", "Exile_Car_Van_Guerilla05", "Exile_Car_Van_Guerilla06", "Exile_Car_Van_Guerilla07", "Exile_Car_Van_Guerilla08", "Exile_Car_Van_Box_Black", "Exile_Car_Van_Box_White", "Exile_Car_Van_Box_Red", "Exile_Car_Van_Box_Guerilla01", "Exile_Car_Van_Box_Guerilla02", "Exile_Car_Van_Box_Guerilla03", "Exile_Car_Van_Box_Guerilla04", "Exile_Car_Van_Box_Guerilla05", "Exile_Car_Van_Box_Guerilla06", "Exile_Car_Van_Box_Guerilla07", "Exile_Car_Van_Box_Guerilla08", "Exile_Car_Van_Fuel_Black", "Exile_Car_Van_Fuel_White", "Exile_Car_Van_Fuel_Red", "Exile_Car_Van_Fuel_Guerilla01", "Exile_Car_Van_Fuel_Guerilla02", "Exile_Car_Van_Fuel_Guerilla03"];
	IL_Supported_OFFROAD = ["Exile_Car_Offroad_Red", "Exile_Car_Offroad_Beige", "Exile_Car_Offroad_White", "Exile_Car_Offroad_Blue", "Exile_Car_Offroad_DarkRed", "Exile_Car_Offroad_BlueCustom", "Exile_Car_Offroad_Guerilla01", "Exile_Car_Offroad_Guerilla02", "Exile_Car_Offroad_Guerilla03", "Exile_Car_Offroad_Guerilla04", "Exile_Car_Offroad_Guerilla05", "Exile_Car_Offroad_Guerilla06", "Exile_Car_Offroad_Guerilla07", "Exile_Car_Offroad_Guerilla08", "Exile_Car_Offroad_Guerilla09", "Exile_Car_Offroad_Guerilla10", "Exile_Car_Offroad_Guerilla11", "Exile_Car_Offroad_Guerilla12", "Exile_Car_Offroad_Rusty1", "Exile_Car_Offroad_Rusty2", "Exile_Car_Offroad_Rusty3", "Exile_Car_Offroad_Armed_Guerilla01", "Exile_Car_Offroad_Armed_Guerilla02", "Exile_Car_Offroad_Armed_Guerilla03",  "Exile_Car_Offroad_Armed_Guerilla04", "Exile_Car_Offroad_Armed_Guerilla05", "Exile_Car_Offroad_Armed_Guerilla06", "Exile_Car_Offroad_Armed_Guerilla07", "Exile_Car_Offroad_Armed_Guerilla08", "Exile_Car_Offroad_Armed_Guerilla09", "Exile_Car_Offroad_Armed_Guerilla10", "Exile_Car_Offroad_Armed_Guerilla11", "Exile_Car_Offroad_Armed_Guerilla12", "Exile_Car_Offroad_Repair_Civillian", "Exile_Car_Offroad_Repair_Red", "Exile_Car_Offroad_Repair_Beige", "Exile_Car_Offroad_Repair_White", "Exile_Car_Offroad_Repair_Blue", "Exile_Car_Offroad_Repair_DarkRed", "Exile_Car_Offroad_Repair_BlueCustom", "Exile_Car_Offroad_Repair_Guerilla01", "Exile_Car_Offroad_Repair_Guerilla02", "Exile_Car_Offroad_Repair_Guerilla03", "Exile_Car_Offroad_Repair_Guerilla04", "Exile_Car_Offroad_Repair_Guerilla05", "Exile_Car_Offroad_Repair_Guerilla06", "Exile_Car_Offroad_Repair_Guerilla07", "Exile_Car_Offroad_Repair_Guerilla08", "Exile_Car_Offroad_Repair_Guerilla09", "Exile_Car_Offroad_Repair_Guerilla10", "Exile_Car_Offroad_Repair_Guerilla11", "Exile_Car_Offroad_Repair_Guerilla12"];
	IL_Supported_SUV = ["Exile_Car_SUV_Red", "Exile_Car_SUV_Black", "Exile_Car_SUV_Grey", "Exile_Car_SUV_Orange"];
	IL_Supported_Hatchback = ["Exile_Car_Hatchback_Beige", "Exile_Car_Hatchback_Green", "Exile_Car_Hatchback_Blue", "Exile_Car_Hatchback_BlueCustom", "Exile_Car_Hatchback_BeigeCustom", "Exile_Car_Hatchback_Yellow", "Exile_Car_Hatchback_Grey", "Exile_Car_Hatchback_Black", "Exile_Car_Hatchback_Dark", "Exile_Car_Hatchback_Rusty1", "Exile_Car_Hatchback_Rusty2", "Exile_Car_Hatchback_Rusty3", "Exile_Car_Hatchback_Sport_Red", "Exile_Car_Hatchback_Sport_Blue", "Exile_Car_Hatchback_Sport_Orange", "Exile_Car_Hatchback_Sport_White", "Exile_Car_Hatchback_Sport_Beige", "Exile_Car_Hatchback_Sport_Green"];
	IL_Supported_Hummvee = ["rc_hmmwv", "HMMWV2", "HMMWV_M1035", "M1114_AGS_ACR", "HMMWV_M1151_M2", "HMMWV2_M2", "HMMWV2_MK19", "HMMWV2_TOW", "HMMWV", "HMMWV_M2", "HMMWV_MK19", "HMMWV_TOW", "DAR_M1152", "DAR_M1151", "DAR_M1151_Deploy", "DAR_M115_MK19", "DAR_M1167", "DAR_M1165_GMV", "DAR_M1151Woodland", "DAR_M115_MK19Woodland", "DAR_M1167Woodland", "DAR_M1152Woodland", "DAR_M1151WoodlandUA", "B_mas_HMMWV_M2", "B_mas_HMMWV_M134", "B_mas_HMMWV_SOV", "B_mas_HMMWV_SOV_M134", "B_mas_HMMWV_TOW", "B_mas_HMMWV_MK19", "B_mas_HMMWV_UNA", "B_mas_HMMWV_MEV", "B_mas_HMMWV_M2_des", "B_mas_HMMWV_M134_des", "B_mas_HMMWV_SOV_des", "B_mas_HMMWV_SOV_M134_des", "B_mas_HMMWV_TOW_des", "B_mas_HMMWV_MK19_des", "B_mas_HMMWV_UNA_des", "B_mas_HMMWV_MEV_des"];
	IL_Supported_Quadbike = ["Exile_Bike_QuadBike_Black", "Exile_Bike_QuadBike_Blue", "Exile_Bike_QuadBike_Red", "Exile_Bike_QuadBike_White", "Exile_Bike_QuadBike_Nato", "Exile_Bike_QuadBike_Csat", "Exile_Bike_QuadBike_Fia", "Exile_Bike_QuadBike_Guerilla01", "Exile_Bike_QuadBike_Guerilla02"];
	IL_Supported_Supply_Crate = ["B_supplyCrate_F", "IG_supplyCrate_F", "O_supplyCrate_F", "I_supplyCrate_F", "C_supplyCrate_F" ];
	IL_Supported_Veh_Ammo = ["Box_NATO_AmmoVeh_F", "Box_East_AmmoVeh_F", "Box_IND_AmmoVeh_F", "Land_CargoBox_V1_F", "ASC_B_box", "I_CargoNet_01_ammo_F", "O_CargoNet_01_ammo_F", "B_CargoNet_01_ammo_F"];
	IL_Supported_Barrel = [/*"Land_BarrelEmpty_F", "Land_BarrelEmpty_grey_F", "Land_BarrelSand_F", "Land_BarrelSand_grey_F", "Land_BarrelTrash_F", "Land_BarrelTrash_grey_F", "Land_BarrelWater_F", "Land_BarrelWater_grey_F", "Land_MetalBarrel_F"*/];//, "Land_MetalBarrel_empty_F", "MetalBarrel_burning_F"];
	IL_Supported_Tank = [/*"Land_WaterBarrel_F", "Land_WaterTank_F"*/];
	IL_Supported_Rubberboat = ["Exile_Boat_RubberDuck_CSAT", "Exile_Boat_RubberDuck_Digital", "Exile_Boat_RubberDuck_Orange", "Exile_Boat_RubberDuck_Blue", "Exile_Boat_RubberDuck_Black"];
	IL_Supported_SDV = ["Exile_Boat_SDV_CSAT", "Exile_Boat_SDV_Digital", "Exile_Boat_SDV_Grey"];
	IL_Supported_Box_H1 = ["Box_NATO_Wps_F", "Box_East_Wps_F", "Box_IND_Wps_F", "Box_East_WpsLaunch_F", "Box_NATO_WpsLaunch_F", "Box_IND_WpsLaunch_F", "Box_IND_WpsSpecial_F", "Box_East_WpsSpecial_F", "Box_NATO_WpsSpecial_F", "Box_mas_all_rifle_Wps_F", "Box_mas_us_rifle_Wps_F", "Box_mas_ru_rifle_Wps_F", "Box_mas_mar_NATO_equip_F", "Box_mas_mar_NATO_Wps_F"];
	IL_Supported_Box_H2 = ["Box_NATO_AmmoOrd_F", "Box_East_AmmoOrd_F", "Box_IND_AmmoOrd_F", "Box_NATO_Grenades_F", "Box_East_Grenades_F", "Box_IND_Grenades_F", "Box_NATO_Ammo_F", "Box_East_Ammo_F", "Box_IND_Ammo_F", "Box_IND_Support_F", "Box_East_Support_F", "Box_NATO_Support_F"];
	IL_Supported_Cargo20 = ["Land_Cargo20_blue_F", "Land_Cargo20_brick_red_F", "Land_Cargo20_cyan_F", "Land_Cargo20_grey_F", "Land_Cargo20_light_blue_F", "Land_Cargo20_light_green_F", "Land_Cargo20_military_green_F", "Land_Cargo20_orange_F", "Land_Cargo20_red_F", "Land_Cargo20_sand_F", "Land_Cargo20_white_F", "Land_Cargo20_yellow_F"];
	IL_Supported_TaruPods = ["Land_Pod_Heli_Transport_04_ammo_F", "Land_Pod_Heli_Transport_04_bench_F", "Land_Pod_Heli_Transport_04_box_F", "Land_Pod_Heli_Transport_04_covered_F", "Land_Pod_Heli_Transport_04_fuel_F", "Land_Pod_Heli_Transport_04_medevac_F", "Land_Pod_Heli_Transport_04_repair_F", "B_Slingload_01_Ammo_F", "B_Slingload_01_Medical_F", "B_Slingload_01_Fuel_F", "B_Slingload_01_Repair_F", "B_Slingload_01_Cargo_F"];
	
	
	IL_Supported_Cargo_MH9 = IL_Supported_Supply_Crate + IL_Supported_Barrel ; 

	IL_Supported_Cargo_Veh_Offroad = IL_Supported_Quadbike + IL_Supported_Bicycles;
	IL_Supported_Cargo_NonVeh_Offroad = IL_Supported_Supply_Crate + IL_Supported_Veh_Ammo + IL_Supported_Barrel + IL_Supported_Tank + IL_Supported_Box_H1 + IL_Supported_Box_H2;
	IL_Supported_Cargo_Offroad = IL_Supported_Cargo_Veh_Offroad + IL_Supported_Cargo_NonVeh_Offroad;

	IL_Supported_Cargo_Veh_VAN = IL_Supported_Cargo_Veh_Offroad;
	IL_Supported_Cargo_NonVeh_VAN = IL_Supported_Cargo_NonVeh_Offroad;
	IL_Supported_Cargo_VAN = IL_Supported_Cargo_Veh_VAN + IL_Supported_Cargo_NonVeh_VAN;

	IL_Supported_Cargo_Veh_Kamaz = IL_Supported_Quadbike + IL_Supported_Rubberboat + IL_Supported_SDV + IL_Supported_Hatchback + IL_Supported_UGV + IL_Supported_VAN + IL_Supported_OFFROAD + IL_Supported_SUV;
	IL_Supported_Cargo_NonVeh_Kamaz = IL_Supported_Supply_Crate + IL_Supported_Veh_Ammo + IL_Supported_Barrel + IL_Supported_Tank + IL_Supported_Box_H1 + IL_Supported_Box_H2 + IL_Supported_Cargo20;
	IL_Supported_Cargo_Kamaz = IL_Supported_Cargo_Veh_Kamaz + IL_Supported_Cargo_NonVeh_Kamaz;

	IL_Supported_Cargo_Veh_HEMTT = IL_Supported_Cargo_Veh_Kamaz;
	IL_Supported_Cargo_NonVeh_HEMTT = IL_Supported_Cargo_NonVeh_Kamaz + IL_Supported_TaruPods;
	IL_Supported_Cargo_HEMTT = IL_Supported_Cargo_Veh_HEMTT + IL_Supported_Cargo_NonVeh_HEMTT;

	IL_Supported_Cargo_Veh_TEMPEST = IL_Supported_Cargo_Veh_HEMTT;
	IL_Supported_Cargo_NonVeh_TEMPEST = IL_Supported_Cargo_NonVeh_HEMTT;
	IL_Supported_Cargo_TEMPEST = IL_Supported_Cargo_Veh_TEMPEST + IL_Supported_Cargo_NonVeh_TEMPEST;

	IL_Supported_Cargo_Veh_Mohawk = IL_Supported_Quadbike + IL_Supported_Rubberboat + IL_Supported_SDV + IL_Supported_Hatchback + IL_Supported_UGV;
	IL_Supported_Cargo_NonVeh_Mohawk = IL_Supported_Supply_Crate + IL_Supported_Veh_Ammo + IL_Supported_Barrel + IL_Supported_Tank;
	IL_Supported_Cargo_Mohawk = IL_Supported_Cargo_Veh_Mohawk + IL_Supported_Cargo_NonVeh_Mohawk;

	IL_Supported_Cargo_Veh_CHINOOK = IL_Supported_Cargo_Veh_Mohawk;
	IL_Supported_Cargo_NonVeh_CHINOOK = IL_Supported_Cargo_NonVeh_Mohawk;
	IL_Supported_Cargo_CHINOOK = IL_Supported_Cargo_Veh_CHINOOK + IL_Supported_Cargo_NonVeh_CHINOOK;

	IL_Supported_Cargo_Veh_C130J = IL_Supported_Cargo_Veh_HEMTT + IL_Supported_Strider + IL_Supported_Hunter + IL_Supported_Ifrit + IL_Supported_Hummvee + IL_Supported_HEMTT;
	IL_Supported_Cargo_NonVeh_C130J = IL_Supported_Cargo_NonVeh_Mohawk;
	IL_Supported_Cargo_C130J = IL_Supported_Cargo_Veh_C130J + IL_Supported_Cargo_NonVeh_C130J;

	IL_Supported_Cargo_Veh_C17 = IL_Supported_Cargo_Veh_C130J;
	IL_Supported_Cargo_NonVeh_C17 = IL_Supported_Cargo_NonVeh_C130J;
	IL_Supported_Cargo_C17 = IL_Supported_Cargo_Veh_C17 + IL_Supported_Cargo_NonVeh_C17;
};

if (isnil "IL_Procedures") then
{
	IL_Procedures = true;

	IL_Init_Veh =
	{
		private["_obj", "_obj_type", "_force"];
		_obj = _this select 0;
		_force = if (count _this > 1) then {_this select 1} else {false};
		_obj_type = (typeOf _obj);

		if ((isNil {_obj getVariable "default_mass"}) || (_force)) then
			{
				if (isNil {_obj getVariable "default_mass"}) then
				{
					_obj setVariable["default_mass", getMass _obj, true];
				}
				else
				{
					_obj setMass (_obj getVariable "default_mass");
				};
			};

		if (_obj_type in IL_Supported_Vehicles_C130J) then
		{
			if ((isNil {_obj getVariable "box_num"}) || (_force)) then {_obj setVariable["box_num", 0, true];};
			if ((isNil {_obj getVariable "can_load"}) || (_force)) then {_obj setVariable["can_load", true, true];};
			if ((isNil {_obj getVariable "can_copilot"}) || (_force)) then {_obj setVariable["can_copilot", IL_Can_CoPilot, true];};
			if ((isNil {_obj getVariable "can_outside"}) || (_force)) then {_obj setVariable["can_outside", IL_Can_Outside, true];};
			if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -4.57, true];};
			if ((isNil {_obj getVariable "usable_ramp"}) || (_force)) then {_obj setVariable["usable_ramp", IL_Ramp, true];};
			if (_obj_type == "C130J_Cargo") then
			{
				if ((isNil {_obj getVariable "slots_num"}) || (_force)) then {_obj setVariable["slots_num", IL_Num_Slots_C130J, true];};
				if ((isNil {_obj getVariable "load_offset"}) || (_force)) then {_obj setVariable["load_offset", 8.5, true];};
			}
			else
			{
				if ((isNil {_obj getVariable "slots_num"}) || (_force)) then {_obj setVariable["slots_num", (IL_Num_Slots_C130J / 2) - 1, true];};
				if ((isNil {_obj getVariable "load_offset"}) || (_force)) then {_obj setVariable["load_offset", 13.5, true];};
			};

		};
		if (_obj_type in IL_Supported_Vehicles_C17) then
		{
			if ((isNil {_obj getVariable "box_num"}) || (_force)) then {_obj setVariable["box_num", 0, true];};
			if ((isNil {_obj getVariable "slots_num"}) || (_force)) then {_obj setVariable["slots_num", IL_Num_Slots_C17, true];};
			if ((isNil {_obj getVariable "can_load"}) || (_force)) then {_obj setVariable["can_load", true, true];};
			if ((isNil {_obj getVariable "can_copilot"}) || (_force)) then {_obj setVariable["can_copilot", IL_Can_CoPilot, true];};
			if ((isNil {_obj getVariable "can_outside"}) || (_force)) then {_obj setVariable["can_outside", IL_Can_Outside, true];};
			if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -1.25, true];};
			if ((isNil {_obj getVariable "load_offset"}) || (_force)) then {_obj setVariable["load_offset", 16, true];};
			if ((isNil {_obj getVariable "usable_ramp"}) || (_force)) then {_obj setVariable["usable_ramp", IL_Ramp, true];};
		};
		if (_obj_type in IL_Supported_Vehicles_MOHAWK) then
		{
			if ((isNil {_obj getVariable "box_num"}) || (_force)) then {_obj setVariable["box_num", 0, true];};
			if ((isNil {_obj getVariable "slots_num"}) || (_force)) then {_obj setVariable["slots_num", IL_Num_Slots_MOHAWK, true];};
			if ((isNil {_obj getVariable "can_load"}) || (_force)) then {_obj setVariable["can_load", true, true];};
			if ((isNil {_obj getVariable "can_copilot"}) || (_force)) then {_obj setVariable["can_copilot", IL_Can_CoPilot, true];};
			if ((isNil {_obj getVariable "can_outside"}) || (_force)) then {_obj setVariable["can_outside", IL_Can_Outside, true];};
			if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -2.25, true];};
			if ((isNil {_obj getVariable "load_offset"}) || (_force)) then {_obj setVariable["load_offset", 4.5, true];};
			if ((isNil {_obj getVariable "usable_ramp"}) || (_force)) then {_obj setVariable["usable_ramp", IL_Ramp, true];};
		};
		if (_obj_type in IL_Supported_Vehicles_CHINOOK) then
		{
			if ((isNil {_obj getVariable "box_num"}) || (_force)) then {_obj setVariable["box_num", 0, true];};
			if ((isNil {_obj getVariable "can_load"}) || (_force)) then {_obj setVariable["can_load", true, true];};
			if ((isNil {_obj getVariable "can_copilot"}) || (_force)) then {_obj setVariable["can_copilot", IL_Can_CoPilot, true];};
			if ((isNil {_obj getVariable "can_outside"}) || (_force)) then {_obj setVariable["can_outside", IL_Can_Outside, true];};
			if (_obj_type == "CH_47F") then
			{
				if ((isNil {_obj getVariable "slots_num"}) || (_force)) then {_obj setVariable["slots_num", IL_Num_Slots_CHINOOK - 2, true];};
				if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -3.1, true];};
				if ((isNil {_obj getVariable "load_offset"}) || (_force)) then {_obj setVariable["load_offset", 4.5, true];};
			};
			if (_obj_type == "CH_147F") then
			{
				if ((isNil {_obj getVariable "slots_num"}) || (_force)) then {_obj setVariable["slots_num", IL_Num_Slots_CHINOOK, true];};
				if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -2.55, true];};
				if ((isNil {_obj getVariable "load_offset"}) || (_force)) then {_obj setVariable["load_offset", 5.25, true];};
			};
			if (_obj_type in ["kyo_MH47E_HC", "kyo_MH47E_Ramp", "kyo_MH47E_base"]) then
			{
				if ((isNil {_obj getVariable "slots_num"}) || (_force)) then {_obj setVariable["slots_num", IL_Num_Slots_CHINOOK, true];};
				if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -1.5, true];};
				if ((isNil {_obj getVariable "load_offset"}) || (_force)) then {_obj setVariable["load_offset", 6, true];};
			};
			if ((isNil {_obj getVariable "usable_ramp"}) || (_force)) then {_obj setVariable["usable_ramp", IL_Ramp, true];};
		};
		if (_obj_type in IL_Supported_Vehicles_MH9) then
		{
			if ((isNil {_obj getVariable "box_l"}) || (_force)) then {_obj setVariable["box_l", _obj, true];};
			if ((isNil {_obj getVariable "box_r"}) || (_force)) then {_obj setVariable["box_r", _obj, true];};

			if ((isNil {_obj getVariable "box_num_l"}) || (_force)) then {_obj setVariable["box_num_l", 0, true];};
			if ((isNil {_obj getVariable "box_num_r"}) || (_force)) then {_obj setVariable["box_num_r", 0, true];};
			if ((isNil {_obj getVariable "slots_num_l"}) || (_force)) then {_obj setVariable["slots_num_l", IL_Num_Slots_MH9, true];};
			if ((isNil {_obj getVariable "slots_num_r"}) || (_force)) then {_obj setVariable["slots_num_r", IL_Num_Slots_MH9, true];};
			if ((isNil {_obj getVariable "can_load"}) || (_force)) then {_obj setVariable["can_load", true, true];};
			if ((isNil {_obj getVariable "can_copilot"}) || (_force)) then {_obj setVariable["can_copilot", IL_Can_CoPilot, true];};
			if ((isNil {_obj getVariable "can_outside"}) || (_force)) then {_obj setVariable["can_outside", IL_Can_Outside, true];};
			if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -0.48, true];};
			if ((isNil {_obj getVariable "load_offset"}) || (_force)) then {_obj setVariable["load_offset", 1, true];};
			if ((isNil {_obj getVariable "usable_ramp"}) || (_force)) then {_obj setVariable["usable_ramp", IL_Ramp, true];};
		};
		if (_obj_type in IL_Supported_Vehicles_OFFROAD) then
		{
			if ((isNil {_obj getVariable "box_num"}) || (_force)) then {_obj setVariable["box_num", 0, true];};
			if ((isNil {_obj getVariable "slots_num"}) || (_force)) then {_obj setVariable["slots_num", IL_Num_Slots_OFFROAD, true];};
			if ((isNil {_obj getVariable "can_load"}) || (_force)) then {_obj setVariable["can_load", true, true];};
			if ((isNil {_obj getVariable "can_outside"}) || (_force)) then {_obj setVariable["can_outside", IL_Can_Outside, true];};
			if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -0.65, true];};
			if ((isNil {_obj getVariable "load_offset"}) || (_force)) then {_obj setVariable["load_offset", 1.5, true];};
		};
		if (_obj_type in IL_Supported_Vehicles_VAN) then
		{
			if ((isNil {_obj getVariable "box_num"}) || (_force)) then {_obj setVariable["box_num", 0, true];};
			if ((isNil {_obj getVariable "slots_num"}) || (_force)) then {_obj setVariable["slots_num", IL_Num_Slots_VAN, true];};
			if ((isNil {_obj getVariable "can_load"}) || (_force)) then {_obj setVariable["can_load", true, true];};
			if ((isNil {_obj getVariable "can_outside"}) || (_force)) then {_obj setVariable["can_outside", IL_Can_Outside, true];};
			if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -0.6, true];};
			if ((isNil {_obj getVariable "load_offset"}) || (_force)) then {_obj setVariable["load_offset", 1, true];};
		};
		if (_obj_type in IL_Supported_Vehicles_KAMAZ) then
		{
			if ((isNil {_obj getVariable "box_num"}) || (_force)) then {_obj setVariable["box_num", 0, true];};
			if ((isNil {_obj getVariable "slots_num"}) || (_force)) then {_obj setVariable["slots_num", IL_Num_Slots_KAMAZ, true];};
			if ((isNil {_obj getVariable "can_load"}) || (_force)) then {_obj setVariable["can_load", true, true];};
			if ((isNil {_obj getVariable "can_outside"}) || (_force)) then {_obj setVariable["can_outside", IL_Can_Outside, true];};
			if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -0.8, true];};
			if ((isNil {_obj getVariable "load_offset"}) || (_force)) then {_obj setVariable["load_offset", -0.5, true];};
		};
		if (_obj_type in IL_Supported_Vehicles_TEMPEST) then
		{
			if ((isNil {_obj getVariable "box_num"}) || (_force)) then {_obj setVariable["box_num", 0, true];};
			if ((isNil {_obj getVariable "slots_num"}) || (_force)) then {_obj setVariable["slots_num", IL_Num_Slots_TEMPEST, true];};
			if ((isNil {_obj getVariable "can_load"}) || (_force)) then {_obj setVariable["can_load", true, true];};
			if ((isNil {_obj getVariable "can_outside"}) || (_force)) then {_obj setVariable["can_outside", IL_Can_Outside, true];};
			if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -0.4, true];};
			if ((isNil {_obj getVariable "load_offset"}) || (_force)) then {_obj setVariable["load_offset", 0.5, true];};
		};
		if (_obj_type in IL_Supported_Vehicles_HEMTT) then
		{
			if ((isNil {_obj getVariable "box_num"}) || (_force)) then {_obj setVariable["box_num", 0, true];};
			if ((isNil {_obj getVariable "slots_num"}) || (_force)) then {_obj setVariable["slots_num", IL_Num_Slots_HEMTT, true];};
			if ((isNil {_obj getVariable "can_load"}) || (_force)) then {_obj setVariable["can_load", true, true];};
			if ((isNil {_obj getVariable "can_outside"}) || (_force)) then {_obj setVariable["can_outside", IL_Can_Outside, true];};
			if (_obj_type in ["B_Truck_01_box_F", "Marinir_Truck_01_box_FG"]) then
			{
				if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -0.4, true];};
				if ((isNil {_obj getVariable "load_offset"}) || (_force)) then {_obj setVariable["load_offset", 0.8, true];};
			}
			else
			{
				if ((isNil {_obj getVariable "zload"}) || (_force)) then {_obj setVariable["zload", -0.5, true];};
				if ((isNil {_obj getVariable "load_offset"}) || (_force)) then {_obj setVariable["load_offset", 0, true];};
			};
		};
	};

	IL_Init_Box =
	{
		private["_obj", "_obj_type", "_bbr", "_p0", "_p1"];
		_obj = _this select 0;

		_obj setVariable["attachedPos", 0, true];
		_obj setVariable["attachedTruck", _obj, true];
		_obj setVariable["doors", "N", true];

		_obj setVariable["slots", 1, true];
		_obj setVariable["cargo_offset", 0, true];

		_bbr = boundingBoxReal _obj;
		_p0 = _bbr select 0;
		_p1 = _bbr select 1;
		_obj setVariable["zload_cargo", abs (_p0 select 2), true];

		_obj_type = (typeOf _obj);

		if (_obj_type in IL_Supported_Cargo20) then
		{
			_obj setVariable["slots", 6, true];
			_obj setVariable["cargo_offset", 2.6, true];
			[_obj, 2400] call IL_SetNewMass;
		};

		if (_obj_type in IL_Supported_HEMTT) then
		{
			_obj setVariable["slots", 10, true];
			_obj setVariable["cargo_offset", 4.2, true];
		};

		if (_obj_type in IL_Supported_Hummvee) then
		{
			if (_obj_type in ["M1114_AGS_ACR", "HMMWV_M1151_M2"]) then
			{
				_obj setVariable["slots", 6, true];
				_obj setVariable["cargo_offset", 2.2, true];
			}
			else
			{
				_obj setVariable["slots", 5, true];
				if (_obj_type in ["HMMWV_M1035"]) then
				{
					_obj setVariable["cargo_offset", 1.9, true];
				}
				else
				{
					if (_obj_type in ["rc_hmmwv"]) then
					{
						_obj setVariable["cargo_offset", 2, true];
					}
					else
					{
						_obj setVariable["cargo_offset", 1.9, true];
					};
				};
			};
		};
		if (_obj_type in IL_Supported_Strider) then
		{
			_obj setVariable["slots", 6, true];
			_obj setVariable["cargo_offset", 2.2, true];
		};
		if (_obj_type in IL_Supported_TaruPods) then
        {
            _obj setVariable["slots", 7, true];
            _obj setVariable["cargo_offset", 2.9, true];
        };
		if (_obj_type in IL_Supported_Hunter) then
		{
			_obj setVariable["slots", 7, true];
			_obj setVariable["cargo_offset", 1.5, true];
		};
		if (_obj_type in IL_Supported_Ifrit) then
		{
			_obj setVariable["slots", 7, true];
			_obj setVariable["cargo_offset", 1.3, true];
		};
		if (_obj_type in IL_Supported_VAN) then
		{
			_obj setVariable["slots", 6, true];
			_obj setVariable["cargo_offset", 1.8, true];
		};
		if (_obj_type in IL_Supported_UGV) then
		{
			_obj setVariable["slots", 5, true];
			_obj setVariable["cargo_offset", 2.1, true];
		};
		if (_obj_type in IL_Supported_Hatchback) then
		{
			_obj setVariable["slots", 5, true];
			_obj setVariable["cargo_offset", 1.9, true];
		};
		if (_obj_type in IL_Supported_SUV) then
		{
			_obj setVariable["slots", 6, true];
			_obj setVariable["cargo_offset", 2, true];
		};
		if (_obj_type in IL_Supported_OFFROAD) then
		{
			_obj setVariable["slots", 6, true];
			_obj setVariable["cargo_offset", 2.4, true];
		};
		if (_obj_type in IL_Supported_Rubberboat) then
		{
			_obj setVariable["slots", 5, true];
			_obj setVariable["cargo_offset", 2, true];
		};
		if (_obj_type in IL_Supported_SDV) then
		{
			_obj setVariable["slots", 6, true];
			_obj setVariable["cargo_offset", 1.6, true];
		};
		if (_obj_type in IL_Supported_Quadbike) then
		{
			_obj setVariable["slots", 2, true];
			_obj setVariable["cargo_offset", 0.5, true];
		};
		if (_obj_type in IL_Supported_Veh_Ammo) then
		{
			_obj setVariable["slots", 2, true];
			_obj setVariable["cargo_offset", 0.4, true];
		};
		if (_obj_type in IL_Supported_Tank) then
		{
			if (_obj_type == "Land_WaterTank_F") then
			{
				_obj setVariable["slots", 3, true];
				_obj setVariable["cargo_offset", 1, true];
			}
			else
			{
				_obj setVariable["slots", 2, true];
				_obj setVariable["cargo_offset", 0.4, true];
			};
			_turn = true;
		};
	};

	IL_Server_AddScore =
	{
		if (isServer) then
		{
			((_this select 1) select 0) addScore ((_this select 1) select 1);
		};
	};

	"IL_SetScore" addPublicVariableEventHandler IL_Server_AddScore;


	IL_Score =
	{
		private ["_obj", "_score"];

		_obj = _this select 0;
		_score = _this select 1;

		if (_score != 0) then
		{
			IL_SetScore = [_obj, _score];
			if (isServer) then
			{
				["Cos", IL_SetScore] spawn IL_Server_AddScore;
			}
			else
			{
				publicVariableServer "IL_SetScore";
			};
		};
	};

	IL_Server_SetDir =
	{
		private ["_obj", "_dir"];
		_obj = _this select 1 select 0;
		_dir = _this select 1 select 1;

		if (_dir < 0) then
		{
			_dir = _dir + 360;
		};
		if (_dir > 360) then
		{
			_dir = _dir - 360;
		};

		_obj setDir _dir;
		_obj setPos (getPos _obj);
	};

	"IL_SetDir" addPublicVariableEventHandler IL_Server_SetDir;

	IL_Rotate =
	{
		private ["_obj", "_to", "_change"];

		_obj = _this select 0;
		_to = _this select 1;
		_change = _this select 2;

		_change = (getDir _obj + _change) - getDir _to;

		IL_SetDir = [_obj, _change];
		if (local _obj) then
		{
			["Cos", IL_SetDir] spawn IL_Server_SetDir;
		}
		else
		{
			if (isDedicated) then
			{
				(owner _obj) publicVariableClient "IL_SetDir";
			}
			else
			{
				publicVariableServer "IL_SetDir";
			};
		};
	};

	IL_Server_SetMass =
	{
		private ["_obj", "_mass"];
		_obj = _this select 1 select 0;
		_mass = _this select 1 select 1;
		if ((getMass _obj) != _mass) then
		{
			_obj setMass _mass;
		};
	};

	"IL_SetMass" addPublicVariableEventHandler IL_Server_SetMass;

	IL_GetCargoMass =
	{
		private ["_v", "_cargo_mass"];
		_v = _this select 0;
		_cargo_mass = 0;
		if (count(attachedObjects _v) > 0) then
		{
			{
				_cargo_mass = _cargo_mass + getMass _x;
			} forEach attachedObjects _v;
		};
		_cargo_mass;
	};

	IL_GetDefaultMass =
	{
		private ["_v"];
		_v = _this select 0;
		_v getVariable "default_mass";
	};

	IL_SetNewMass =
	{
		if !(IL_Mass) ExitWith {};
		private ["_v", "_v_def_mass", "_cargo_mass"];
		_v = _this select 0;
		_v_def_mass =  if (count _this > 1) then {_this select 1} else {0};
		_cargo_mass =  if (count _this > 2) then {_this select 2} else {0};

		if (_v_def_mass == 0) then
		{
			_v_def_mass = [_v] call IL_GetDefaultMass;
		};
		if (_cargo_mass == 0) then
		{
			_cargo_mass = [_v] call IL_GetCargoMass;
		};

		if ((getMass _v) != (_v_def_mass + _cargo_mass)) then
		{
			IL_SetMass = [_v, (_v_def_mass + _cargo_mass)];
			if (local _v) then
			{
				["Cos", IL_SetMass] spawn IL_Server_SetMass;
			}
			else
			{
				if (isDedicated) then
				{
					(owner _v) publicVariableClient "IL_SetMass";
				}
				else
				{
					publicVariableServer "IL_SetMass";
				};
			};
		};
	};

	
	IL_Move_Attach=
	{
		private ["_veh", "_obj", "_from", "_to", "_pos", "_step", "_steps", "_from_x", "_from_y", "_from_z", "_to_x", "_to_y", "_to_z", "_x", "_y", "_z", "_i", "_x_step", "_y_step", "_z_step", "_turn"];
		_veh = _this select 0;
		_obj = _this select 1;
		_from = _this select 2;
		_to = _this select 3;
		_step = _this select 4;
		_turn = if (count _this > 5) then {_this select 5} else {false};

		_from_x = _from select 0;
		_from_y = _from select 1;
		_from_z = _from select 2;
		
		_to_x = _to select 0;
		_to_y = _to select 1;
		_to_z = _to select 2;
		
		_x = _to_x - _from_x;
		_y = _to_y - _from_y;
		_z = _to_z - _from_z;
		
		if (((abs _x) > (abs _y)) && ((abs _x) > (abs _z))) then
		{
			_steps = round ((abs _x) / _step);			
		}
		else
		{
			if ((abs _y) > (abs _z)) then
			{
				_steps = round ((abs _y) / _step);				
			}
			else
			{
				_steps = round ((abs _z) / _step);
				
			};
		};

		_i = 0;
		_obj AttachTo [_veh, _from];
		while {_i < _steps} do
		{
			_i = _i + 1;
			_pos = [(((_x / _steps) * _i) + _from_x), (((_y / _steps) * _i) + _from_y), (((_z / _steps) * _i) + _from_z)];
			_obj AttachTo [_veh, _pos];
			if (_turn) then
			{
				[_obj, _veh, -90] call IL_Rotate;
				_turn = false;
			};
			sleep 0.25;
		};

		_obj AttachTo [_veh, _to];
	};

	IL_Create_And_Attach =
	{
		_type = _this select 0;
		_to = _this select 1;
		_x = if (count _this > 2) then {_this select 2} else {0};
		_y = if (count _this > 3) then {_this select 3} else {0};
		_z = if (count _this > 4) then {_this select 4} else {0};
		_m = createVehicle [_type, position _to, [], 0, "CAN_COLLIDE"];
		_m AttachTo [_to,[_x,_y,_z]];
		_m
	};

	IL_Server_Cargo_Para =
	{
		private ["_smoke", "_player_velocity", "_light", "_damage", "_smoke_type", "_chemlight_type", "_cargo_pos", "_last_attach_pos", "_dist", "_velocity", "_tmp"];
		_vars = _this select 1;
		_cargo = _vars select 0;
		_v = _vars select 1;
		_last_attach_pos = _vars select 2;
		_player_velocity = _vars select 3;
		if (((IL_Para_Smoke) || (IL_Para_Smoke_Add)) && (_cargo isKindOf "AllVehicles")) then
		{
			_smoke_type = IL_Para_Smoke_Veh;
		}
		else
		{
			_smoke_type = IL_Para_Smoke_Default;
		};
		if (((IL_Para_Light) || (IL_Para_Light_Add)) && (_cargo isKindOf "AllVehicles")) then
		{
			_chemlight_type = IL_Para_Light_Veh;
		}
		else
		{
			_chemlight_type = IL_Para_Light_Default;
		};

		_cargo_pos = [0,0,-2.3];

		_damage = getDammage _cargo;
		detach _cargo;
		_cargo setVelocity _player_velocity;
		_dist = _v distance _cargo;
		_tmp = [_cargo] spawn
		{
			while {(getPosATL (_this select 0)) select 2 > IL_Para_Drop_Open_ATL} do
			{
				sleep 0.2;
			};
		};
		while {(_v distance _cargo) - _dist < 20} do
		{
			sleep 0.2;
		};
		if (IL_Para_Drop_Open_ATL > 0) then
		{
			while {(getPosATL _cargo) select 2 > (IL_Para_Drop_Open_ATL + ((velocity _cargo) select 2) * -0.5)} do
			{
				sleep 0.2;
			};
		};

        _chute = createVehicle ["B_Parachute_02_F", position _cargo, [], 0, "CAN_COLLIDE"];
        _chute attachTo [_cargo, _cargo_pos];
        detach _chute;

        if (IL_Para_Drop_Velocity) then
        {
            _chute setVelocity _player_velocity;
        };
        _cargo attachTo [_chute, _cargo_pos];

        if (IL_Para_Smoke) then
        {
            _smoke = [_smoke_type, _cargo] call IL_Create_And_Attach;
        };
        if (IL_Para_Light) then
        {
            _light = [_chemlight_type, _cargo] call IL_Create_And_Attach;
        };
        while {(getPos _cargo) select 2 > 2} do
        {
            sleep 0.2;
        };
        detach _cargo;
        if (IL_Para_Smoke) then
        {
            _smoke attachTo [_cargo,[0,0,2]];
            detach _smoke;
        };
        if (IL_Para_Light) then
        {
            _light attachTo [_cargo,[0,0,2]];
            detach _light;
        };
        if (IL_Para_Smoke_Add) then
        {
            _smoke = [_smoke_type, _cargo] call IL_Create_And_Attach;
            _smoke attachTo [_cargo,[0,0,2]];
            detach _smoke;
        };
        if (IL_Para_Light_Add) then
        {
            _light = [_chemlight_type, _cargo] call IL_Create_And_Attach;
            _light attachTo [_cargo,[0,0,2]];
            detach _light;
        };

        _cargo setPosASL getPosASL _cargo;

        if (IL_CDamage == 0) then
        {
            _cargo setDamage 0;
        };

        if (IL_CDamage == 1) then
        {
            _cargo setDamage _damage;
            if (_damage != (getDammage _cargo)) then
            {
                sleep 1;
                _cargo setDamage _damage;
            };
        };
	};

    IL_Cargo_Para = {
        IL_CLient_Cargo_Para = _this;
        if (isServer) then
        {
            IL_CLient_Cargo_Para spawn IL_Server_Cargo_Para;
        }
        else
        {
            [Player, IL_Unload_Score] call IL_Score;
            publicVariableServer "IL_Client_Cargo_Para";
        };
    };
    "IL_Client_Cargo_Para" addPublicVariableEventHandler IL_Cargo_Para;

	IL_Do_Load =
	{
		private["_NoBoxHint", "_v", "_supported_cargo", "_zload", "_x_cargo_offset", "_cargo_offset", "_sdist", "_spoint", "_slot_num", "_counter", "_done", "_obj_lst", "_damage", "_obj_type", "_doors", "_box_num", "_dummy", "_nic", "_turn", "_force", "_cargo"];
		_NoBoxHint = "The box is in the vicinity. Perhaps it is outside of the loading area.";
		_v = _this select 0;
		_supported_cargo = _this select 1;
		_doors = if (count _this > 2) then {_this select 2} else {"B"};
		_force = if (count _this > 3) then {_this select 3} else {false};
		_cargo = if (count _this > 4) then {_this select 4} else {ObjNull};

		_v setVariable["can_load", false, true];
		_zload = _v getVariable "zload";
		_obj_type = (typeOf _v);
		_sdist = 0;

		_counter = 0;
		_done = false;
		_turn = false;

		if ((_obj_type in IL_Supported_Vehicles_VAN) && (_doors == "B")) then
		{
			_sdist = IL_SDistL;
			_spoint = _v modelToWorld [0,-4.5,-1.6];
			_box_num = _v getVariable "box_num";
			_slot_num = _v getVariable "slots_num";
		};
		if ((_obj_type in IL_Supported_Vehicles_OFFROAD) && (_doors == "B")) then
		{
			_sdist = IL_SDistL;
			_spoint = _v modelToWorld [0,-4.5,-1.6];
			_box_num = _v getVariable "box_num";
			_slot_num = _v getVariable "slots_num";
		};
		if ((_obj_type in IL_Supported_Vehicles_KAMAZ) && (_doors == "B")) then
		{
			_sdist = IL_SDistL;
			_spoint = _v modelToWorld [0,-6 - (_v getVariable "load_offset"),0];
			_box_num = _v getVariable "box_num";
			_slot_num = _v getVariable "slots_num";
		};
		if ((_obj_type in IL_Supported_Vehicles_HEMTT) && (_doors == "B")) then
		{
			_sdist = IL_SDistL;
			_spoint = _v modelToWorld [0,-7 - (_v getVariable "load_offset"),0];
			_box_num = _v getVariable "box_num";
			_slot_num = _v getVariable "slots_num";
		};
		if ((_obj_type in IL_Supported_Vehicles_TEMPEST) && (_doors == "B")) then
		{
			_sdist = IL_SDistL;
			_spoint = _v modelToWorld [0,-6.5 - (_v getVariable "load_offset"),0];
			_box_num = _v getVariable "box_num";
			_slot_num = _v getVariable "slots_num";
		};
		if ((_obj_type in IL_Supported_Vehicles_C130J) && (_doors == "B")) then
		{
			_sdist = IL_SDistL + IL_SDistL_Heli_offset;
			_spoint = _v modelToWorld [0,-9,-5.4];
			_box_num = _v getVariable "box_num";
			_slot_num = _v getVariable "slots_num";
		};
		if ((_obj_type in IL_Supported_Vehicles_C17) && (_doors == "B")) then
		{
			_sdist = IL_SDistL + IL_SDistL_Heli_offset;
			_spoint = _v modelToWorld [0,-16.5,-3];
			_box_num = _v getVariable "box_num";
			_slot_num = _v getVariable "slots_num";
		};
		if ((_obj_type in IL_Supported_Vehicles_CHINOOK) && (_doors == "B")) then
		{
			_sdist = IL_SDistL + IL_SDistL_Heli_offset;
			_spoint = _v modelToWorld [0,-9,-3];
			_box_num = _v getVariable "box_num";
			_slot_num = _v getVariable "slots_num";
		};
		if ((_obj_type in IL_Supported_Vehicles_MOHAWK) && (_doors == "B")) then
		{
			_sdist = IL_SDistL + IL_SDistL_Heli_offset;
			_spoint = _v modelToWorld [0,-6,-3];
			_box_num = _v getVariable "box_num";
			_slot_num = _v getVariable "slots_num";
		};
		if ((_obj_type in IL_Supported_Vehicles_MH9) && (_doors == "L")) then
		{
			_sdist = IL_SDistL + IL_SDistL_Heli_offset;
			_spoint = _v modelToWorld [0-3,1.3,-1.3];
			_box_num = _v getVariable "box_num_l";
			_slot_num = _v getVariable "slots_num_l";
		};
		if ((_obj_type in IL_Supported_Vehicles_MH9) && (_doors == "R")) then
		{
			_sdist = IL_SDistL + IL_SDistL_Heli_offset;
			_spoint = _v modelToWorld [0+3,1.3,-1.3];
			_box_num = _v getVariable "box_num_r";
			_slot_num = _v getVariable "slots_num_r";
		};

		if !(_force) then
		{
			_obj_lst = nearestObjects[ _spoint, _supported_cargo, _sdist];
		}
		else
		{
			_obj_lst = [_cargo];
		};

		if (count (_obj_lst) > 0) then
		{
			{
				if (isNil {_x getVariable "attachedPos"}) then
				{
					[_x] call IL_Init_Box;
				};
				if ((typeOf _x) in (IL_Supported_Cargo20 + ["Land_WaterTank_F"])) then
				{
					_turn = true;
				};
				
				
				_lock1 = locked _v;
                _lock2 = locked _x;
                if (_lock1 <= 1) then
                {					
					if (_lock2 <= 1) then
                    {
						if (_obj_type in IL_Supported_Vehicles_MH9) then
						{
						_turn = !_turn;
						};
						if ((_box_num > _slot_num) && !_done) then
						{
						_done = true;
						_counter = (_box_num);
						_zload = (_v getVariable "zload") + (_x getVariable "zload_cargo");
						_cargo_offset = (_v getVariable "load_offset") + (_x getVariable "cargo_offset");
						if ((typeOf _x) in IL_Supported_UGV) then
						{
							_x_cargo_offset = -0.4;
						}
						else
						{
							_x_cargo_offset = 0;
						};
						_damage = getDammage _x;

						if ((typeOf _x) in IL_Supported_SDV) then
						{
							_x animate ["periscope", 3];
							_x animate ["Antenna", 3];
							_x animate ["HideScope", 3];
							_x animate["display_on_R", 1];
							while {_x animationPhase "periscope" < 3} do
							{
								sleep 1;
							};
						};

						if ((_obj_type in IL_Supported_Vehicles_VAN) && (_doors == "B")) then
						{
							[_v, _x, [_x_cargo_offset,-4.5,_zload], [_x_cargo_offset,_counter + 0.25 - _cargo_offset,_zload], 1, _turn] call IL_Move_Attach;
						};
						if ((_obj_type in IL_Supported_Vehicles_OFFROAD) && (_doors == "B")) then
						{
							[_v, _x, [_x_cargo_offset,-4.5,_zload], [_x_cargo_offset,_counter + 0.25 - _cargo_offset,_zload], 1, _turn] call IL_Move_Attach;
						};
						if ((_obj_type in IL_Supported_Vehicles_KAMAZ) && (_doors == "B")) then
						{
							[_v, _x, [_x_cargo_offset,-6 - _cargo_offset,_zload], [_x_cargo_offset,_counter + 0.25 - _cargo_offset,_zload], 1, _turn] call IL_Move_Attach;
						};
						if ((_obj_type in IL_Supported_Vehicles_HEMTT) && (_doors == "B")) then
						{
							[_v, _x, [_x_cargo_offset,-7 - _cargo_offset,_zload], [_x_cargo_offset,_counter + 0.25 - _cargo_offset,_zload], 1, _turn] call IL_Move_Attach;
						};
						if ((_obj_type in IL_Supported_Vehicles_TEMPEST) && (_doors == "B")) then
						{
							[_v, _x, [_x_cargo_offset,-6.5 - _cargo_offset,_zload], [_x_cargo_offset,_counter - _cargo_offset,_zload], 1, _turn] call IL_Move_Attach;
						};
						if ((_obj_type in IL_Supported_Vehicles_C130J)  && (_doors == "B")) then
						{
							[_v, _x, [_x_cargo_offset,-9,-0.93 + _zload], [_x_cargo_offset,-8,-0.93 + _zload], 1, _turn] call IL_Move_Attach;
							[_v, _x, [_x_cargo_offset,-7,-0.93 + _zload], [_x_cargo_offset,-3.5,_zload], 1, _turn] call IL_Move_Attach;
							[_v, _x, [_x_cargo_offset,-2.5,_zload], [_x_cargo_offset,_counter + 17 - _cargo_offset,_zload], 1, _turn] call IL_Move_Attach;
						};
						if ((_obj_type in IL_Supported_Vehicles_C17)  && (_doors == "B")) then
						{
							[_v, _x, [_x_cargo_offset,-16.5,-1.75 + _zload], [_x_cargo_offset,-14,-1.75 + _zload], 1, _turn] call IL_Move_Attach;
							[_v, _x, [_x_cargo_offset,-13,-1.75 + _zload], [_x_cargo_offset,-6.5,_zload], 1, _turn] call IL_Move_Attach;
							[_v, _x, [_x_cargo_offset,-5.5,_zload], [_x_cargo_offset,_counter + 32 - _cargo_offset,_zload], 1, _turn] call IL_Move_Attach;
						};
						if ((_obj_type in IL_Supported_Vehicles_CHINOOK)  && (_doors == "B")) then
						{
							[_v, _x, [_x_cargo_offset,-9,-0.75 + _zload], [_x_cargo_offset,-7,-0.75 + _zload], 1, _turn] call IL_Move_Attach;
							[_v, _x, [_x_cargo_offset,-7,-0.75 + _zload], [_x_cargo_offset,-4,_zload], 1, _turn] call IL_Move_Attach;
							[_v, _x, [_x_cargo_offset,-4,_zload], [_x_cargo_offset,_counter + 9 - _cargo_offset,_zload], 1, _turn] call IL_Move_Attach;
						};
						if ((_obj_type in IL_Supported_Vehicles_MOHAWK)  && (_doors == "B")) then
						{
							[_v, _x, [_x_cargo_offset,-6,-0.75 + _zload], [_x_cargo_offset,-4.5,-0.75 + _zload], 1, _turn] call IL_Move_Attach;
							[_v, _x, [_x_cargo_offset,-4.5,-0.75 + _zload], [_x_cargo_offset,-1.5,_zload], 1, _turn] call IL_Move_Attach;
							[_v, _x, [_x_cargo_offset,-1.5,_zload], [_x_cargo_offset,_counter + 9 - _cargo_offset,_zload], 1, _turn] call IL_Move_Attach;
						};
						if ((_obj_type in IL_Supported_Vehicles_MH9)  && (_doors == "L")) then
						{
							[_v, _x, [_x_cargo_offset-3,1.3,-1.3 + _zload], [_x_cargo_offset-1,-0.2,_zload], 1, _turn] call IL_Move_Attach;
						};
						if ((_obj_type in IL_Supported_Vehicles_MH9)  && (_doors == "R")) then
						{
							[_v, _x, [_x_cargo_offset+3,1.3,-1.3 + _zload], [_x_cargo_offset+1,-0.2,_zload], 1, _turn] call IL_Move_Attach;
						};

						_counter = _counter - (_x getVariable "slots");

						if (_doors == "B") then
						{
							_v setVariable["box_num", _counter, true];
						};
						if ((_obj_type in IL_Supported_Vehicles_MH9)  && (_doors == "L")) then
						{
							_v setVariable["box_num_l", _counter, true];
							_v setVariable["box_l", _x, true];
						};
						if ((_obj_type in IL_Supported_Vehicles_MH9)  && (_doors == "R")) then
						{
							_v setVariable["box_num_r", _counter, true];
							_v setVariable["box_r", _x, true];
						};

						[_v] call IL_SetNewMass;

						if (_x isKindOf "AllVehicles") then
						{
							_x forceSpeed 0;
						};

						_x setVariable["attachedPos", _counter, true];
						_x setVariable["attachedTruck", _v, true];
						_x setVariable["doors", _doors, true];

						if (IL_CDamage == 0) then
						{
							_x setDamage 0;
						};

						if (IL_CDamage == 1) then
						{
							_x setDamage _damage;
							if (_damage != (getDammage _x)) then
							{
								sleep 1;
								_x setDamage _damage;
							};
						};

						_IL_noti = getText(configFile >> "cfgVehicles" >> typeOf _x >> "displayName");
                        ["Success", format ["%1 successfully loaded!",_IL_noti]] call ExileClient_gui_notification_event_addNotification;
						[Player, IL_Load_Score] call IL_Score;
						};
					}
                    else
                    {
                    ["Whoops", ["Locked vehicles can't be loaded!"]] call ExileClient_gui_notification_event_addNotification;
                    };
				}
                else
				{
                ["Whoops", ["Locked vehicles can't load Cargo!"]] call ExileClient_gui_notification_event_addNotification;
				};
				
				if (_done) exitWith {};
			} forEach (_obj_lst);
		
		};
		_v setVariable["can_load", true, true];
	};

	IL_Do_Unload =
	{
		private ["_v", "_para", "_supported_cargo", "_doors", "_counter", "_done", "_obj_lst", "_zload", "_x_cargo_offset", "_cargo_offset", "_obj_type", "_damage", "_nic", "_free_slots", "_turn", "_skip", "_last_attach_pos"];
		_v = _this select 0;
		_para = if (count _this > 1) then {_this select 1} else {false};
		_doors = if (count _this > 2) then {_this select 2} else {"B"};

		_v setVariable["can_load", false, true];
		_counter = 0;
		_done = false;
		_turn = false;
		_skip = true;
		_obj_lst = [];

		_obj_type = (typeOf _v);
		if (_obj_type in IL_Supported_Vehicles_MH9) then
		{
			if (_doors == "L") then
			{
				_obj_lst = [_v getVariable "box_l"];
			}
			else
			{
				_obj_lst = [_v getVariable "box_r"];
			};
		}
		else
		{
			_obj_lst = attachedObjects _v;
		};

		if (count (_obj_lst) > 0) then
		{
			{
				_obj_type = (typeOf _v);

				if (_x getVariable "doors" == _doors) then
				{
					if (_doors == "B") then
					{
						_counter = (_v getVariable "box_num");
					};
					if (_doors == "L") then
					{
						_counter = (_v getVariable "box_num_l");
					};
					if (_doors == "R") then
					{
						_counter = (_v getVariable "box_num_r");
					};
					if (((_x getVariable "attachedTruck") == _v) && ((_x getVariable "attachedPos") == (_counter)) && (_counter < 0) && !_done) then
					{
						_done = true;
						_skip = false;
						_zload = (_v getVariable "zload") + (_x getVariable "zload_cargo");
						_cargo_offset = (_v getVariable "load_offset") + (_x getVariable "cargo_offset");
						_damage = getDammage _x;
						if ((typeOf _x) in IL_Supported_UGV) then
						{
							_x_cargo_offset = -0.4;
						}
						else
						{
							_x_cargo_offset = 0;
						};

						_obj_type = (typeOf _v);
						if ((_obj_type in IL_Supported_Vehicles_VAN) && (_doors == "B")) then
						{
							[_v, _x, [_x_cargo_offset,_counter + 0.25 - _cargo_offset,_zload], [_x_cargo_offset,-4.5,_zload], 1, _turn] call IL_Move_Attach;
						};
						if ((_obj_type in IL_Supported_Vehicles_OFFROAD) && (_doors == "B")) then
						{
							[_v, _x, [_x_cargo_offset,_counter + 0.25 - _cargo_offset,_zload], [_x_cargo_offset,-4.5,_zload], 1, _turn] call IL_Move_Attach;
						};
						if ((_obj_type in IL_Supported_Vehicles_KAMAZ) && (_doors == "B")) then
						{
							[_v, _x, [_x_cargo_offset,_counter + 0.25 - _cargo_offset,_zload], [_x_cargo_offset,-6 - _cargo_offset,_zload], 1, _turn] call IL_Move_Attach;
						};
						if ((_obj_type in IL_Supported_Vehicles_HEMTT) && (_doors == "B")) then
						{
							[_v, _x, [_x_cargo_offset,_counter + 0.25 - _cargo_offset,_zload], [_x_cargo_offset,-7 - _cargo_offset,_zload], 1, _turn] call IL_Move_Attach;
						};
						if ((_obj_type in IL_Supported_Vehicles_TEMPEST) && (_doors == "B")) then
						{
							[_v, _x, [_x_cargo_offset,_counter - _cargo_offset,_zload], [_x_cargo_offset,-6.5 - _cargo_offset,_zload], 1, _turn] call IL_Move_Attach;
						};
						if ((_obj_type in IL_Supported_Vehicles_C130J)  && (_doors == "B")) then
						{
							if !(_para) then
							{
								[_v, _x, [_x_cargo_offset,_counter + 17 - _cargo_offset,_zload], [_x_cargo_offset,-2.5,_zload], 1, _turn] call IL_Move_Attach;
							};
							[_v, _x, [_x_cargo_offset,-3.5,_zload], [_x_cargo_offset,-7,-0.93 + _zload], 1, _turn] call IL_Move_Attach;
							[_v, _x, [_x_cargo_offset,-8,-0.93 + _zload], [_x_cargo_offset,-9,-0.93 + _zload], 1, _turn] call IL_Move_Attach;
							if ((_para) && (_obj_type in IL_Para_Drop_Vehicles)) then
							{
								[_v, _x, [_x_cargo_offset,-10,-0.93 + _zload], [_x_cargo_offset,-12,-0.93 + _zload], 1, _turn] call IL_Move_Attach;
								_last_attach_pos = [_x_cargo_offset,-12,_zload];
							};
						};
						if ((_obj_type in IL_Supported_Vehicles_C17)  && (_doors == "B")) then
						{
							if !(_para) then
							{
								[_v, _x, [_x_cargo_offset,_counter + 32 - _cargo_offset,_zload], [_x_cargo_offset,-5.5,_zload], 1, _turn] call IL_Move_Attach;
							};
							[_v, _x, [_x_cargo_offset,-6.5,_zload], [_x_cargo_offset,-13,-1.75 + _zload], 1, _turn] call IL_Move_Attach;
							[_v, _x, [_x_cargo_offset,-14,-1.75 + _zload], [_x_cargo_offset,-16.5,-1.75 + _zload], 1, _turn] call IL_Move_Attach;
							if ((_para) && (_obj_type in IL_Para_Drop_Vehicles)) then
							{
								[_v, _x, [_x_cargo_offset,-16.5,-1.75 + _zload], [_x_cargo_offset,-19.5,-1.75 + _zload], 1, _turn] call IL_Move_Attach;
								_last_attach_pos = [_x_cargo_offset,-19.5,-1.75 + _zload];
							};
						};
						if ((_obj_type in IL_Supported_Vehicles_CHINOOK)  && (_doors == "B")) then
						{
							if !(_para) then
							{
								[_v, _x, [_x_cargo_offset,_counter + 9 - _cargo_offset,_zload], [_x_cargo_offset,-4,_zload], 1, _turn] call IL_Move_Attach;
							};
							[_v, _x, [_x_cargo_offset,-4,_zload], [_x_cargo_offset,-7,-0.75 + _zload], 1, _turn] call IL_Move_Attach;
							[_v, _x, [_x_cargo_offset,-7,-0.75 + _zload], [_x_cargo_offset,-9,-0.75 + _zload], 1, _turn] call IL_Move_Attach;
							if ((_para) && (_obj_type in IL_Para_Drop_Vehicles)) then
							{
								_last_attach_pos = [_x_cargo_offset,-10,-0.75 + _zload];
							};
						};
						if ((_obj_type in IL_Supported_Vehicles_MOHAWK)  && (_doors == "B")) then
						{
							if !(_para) then
							{
								[_v, _x, [_x_cargo_offset,_counter + 9 - _cargo_offset,_zload], [_x_cargo_offset,-1.5,_zload], 1, _turn] call IL_Move_Attach;
							};
							[_v, _x, [_x_cargo_offset,-1.5,_zload], [_x_cargo_offset,-4.5,-0.75 + _zload], 1, _turn] call IL_Move_Attach;
							[_v, _x, [_x_cargo_offset,-4.5,-0.75 + _zload], [_x_cargo_offset,-6,-0.75 + _zload], 1, _turn] call IL_Move_Attach;
							if ((_para) && (_obj_type in IL_Para_Drop_Vehicles)) then
							{
								_last_attach_pos = [_x_cargo_offset,-6,-0.75 + _zload];
							};
						};
						if ((_obj_type in IL_Supported_Vehicles_MH9)  && (_doors == "L")) then
						{
							[_v, _x, [_x_cargo_offset-1,-0.2,_zload], [_x_cargo_offset-3,1.3,-0.75 + _zload], 1] call IL_Move_Attach;
							if ((_para) && (_obj_type in IL_Para_Drop_Vehicles)) then
							{
								_last_attach_pos = [_x_cargo_offset-3,1.3,-0.75 + _zload];
							};
						};
						if ((_obj_type in IL_Supported_Vehicles_MH9)  && (_doors == "R")) then
						{
							[_v, _x, [_x_cargo_offset+1,-0.2,_zload], [_x_cargo_offset+3,1.3,-0.75 + _zload], 1] call IL_Move_Attach;
							if ((_para) && (_obj_type in IL_Para_Drop_Vehicles)) then
							{
								_last_attach_pos = [_x_cargo_offset+3,1.3,-0.75 + _zload];
							};
						};

						if ((_para) && (_obj_type in IL_Para_Drop_Vehicles)) then
						{
						    _player_velocity = velocity (vehicle player);
							[_x, _v, _last_attach_pos, _player_velocity] spawn IL_Cargo_Para;
						}
						else
						{
							sleep 0.2;
							detach _x;
							_x setVelocity [0, 0, -0.2];
						};

						if (_x isKindOf "AllVehicles") then
						{
							_x forceSpeed -1;
						};

						_counter = _counter + (_x getVariable "slots");
						if (_doors == "B") then
						{
							_v setVariable["box_num", _counter, true];
							_free_slots = abs((_v getVariable "slots_num") - (_v getVariable "box_num"));
						};
						if (_doors == "L") then
						{
							_v setVariable["box_num_l", _counter, true];
							_v setVariable["box_l", _v, true];
							_free_slots = abs((_v getVariable "slots_num_l") - (_v getVariable "box_num_l"));
						};
						if (_doors == "R") then
						{
							_v setVariable["box_num_r", _counter, true];
							_v setVariable["box_r", _v, true];
							_free_slots = abs((_v getVariable "slots_num_r") - (_v getVariable "box_num_r"));
						};

						[_v] call IL_SetNewMass;

						_x setVariable["attachedPos", 0, true];
						_x setVariable["attachedTruck", _x, true];
						_x setVariable["doors", "N", true];

						if (IL_CDamage == 0) then
						{
							_x setDamage 0;
						};

						if (IL_CDamage == 1) then
						{
							_x setDamage _damage;
							if (_damage != (getDammage _x)) then
							{
								sleep 1;
								_x setDamage _damage;
							};
						};
						[Player, IL_Unload_Score] call IL_Score;
						sleep 1;
					};
				};
				_IL_noti = getText(configFile >> "cfgVehicles" >> typeOf _x >> "displayName");
                ["Success", format ["%1 successfully unloaded!",_IL_noti]] call ExileClient_gui_notification_event_addNotification;
						
				if (_done) exitWith {};
			} forEach (_obj_lst);
			if (_skip) then
			{

				if (_counter < 0) then
				{
					_counter = _counter + 1;
				};

				if (_doors == "B") then
				{
					_v setVariable["box_num", _counter, true];
					_free_slots = abs((_v getVariable "slots_num") - (_v getVariable "box_num"));
				};
				if (_doors == "L") then
				{
					_v setVariable["box_num_l", _counter, true];
					_v setVariable["box_l", _v, true];
					_free_slots = abs((_v getVariable "slots_num_l") - (_v getVariable "box_num_l"));
				};
				if (_doors == "R") then
				{
					_v setVariable["box_num_r", _counter, true];
					_v setVariable["box_r", _v, true];
					_free_slots = abs((_v getVariable "slots_num_r") - (_v getVariable "box_num_r"));
				};
			};
		}
		else
		{
			[_v, true] call IL_Init_Veh;
		};
		[_v] call IL_SetNewMass;
		_v setVariable["can_load", true, true];
	};


	IL_Server_GetOut =
	{
		private ["_v", "_player", "_para", "_chute",  "_backpack", "_pos", "_x_offset", "_dist", "_dist_out", "_dist_out_para", "_velocity"];
		_vars = _this select 1;
		_v = _vars select 0;
		_player = _vars select 1;
		_para = if (count _this > 2) then {_this select 2} else {false};

		if ((typeOf _v) in IL_Supported_Vehicles_MH9) then
		{
			_dist_out = 5;
			_dist_out_para = 5;
		};
		if ((typeOf _v) in IL_Supported_Vehicles_MOHAWK) then
		{
			_dist_out = 5;
			_dist_out_para = 11;
		};
		if ((typeOf _v) in IL_Supported_Vehicles_CHINOOK) then
		{
			_dist_out = 7;
			_dist_out_para = 11;
		};
		if ((typeOf _v) in IL_Supported_Vehicles_C130J) then
		{
			_dist_out = 7;
			_dist_out_para = 15;
		};
		if ((typeOf _v) in IL_Supported_Vehicles_C17) then
		{
			_dist_out = 15;
			_dist_out_para = 20;
		};

		_pos = (_v worldToModel (getPosATL _player));
		_x_offset = _pos select 0;
		if (_x_offset < 0) then
		{
			if ((typeOf _v) in IL_Supported_Vehicles_MH9) then
			{
				_x_offset = 90;
			}
			else
			{
				_x_offset = 8;
			};
		}
		else
		{
			if ((typeOf _v) in IL_Supported_Vehicles_MH9) then
			{
				_x_offset = -90;
			}
			else
			{
				_x_offset = -8;
			};
		};

		_player allowDamage false;
		sleep 0.2;
		unassignVehicle _player;
		_player action ["EJECT",vehicle _player];
		sleep 0.5;

		if !(_para) then
		{
			_player setDir ((getDir _v) + 180);
			_pos = ([_v, _dist_out, ((getDir _v) + 180 + _x_offset)] call BIS_fnc_relPos);
			_pos = [_pos select 0, _pos select 1, ((getPosATL _v) select 2)];
			_player setPosATL _pos;
		}
		else
		{
			_pos = ([_v, _dist_out_para, ((getDir _v) + 180 + _x_offset)] call BIS_fnc_relPos);
			_pos = [_pos select 0, _pos select 1, ((getPosATL _v) select 2)];
			_player setPosATL _pos;
			_dist = _v distance _player;
			while {(_v distance _player) - _dist < 20} do
			{
				sleep 0.2;
			};
			if (IL_Para_Jump_Open_ATL > 0) then
			{
				while {(getPosATL _player) select 2 > IL_Para_Jump_Open_ATL} do
				{
					sleep 0.2;
				};
			};
			if !(unitBackpack _player isKindOf "B_Parachute") then
			{
				_chute = createVehicle ["Steerable_Parachute_F", position _player, [], 0, "CAN_COLLIDE"];
				_chute AttachTo [_player, [0,0,0]];
				detach _chute;
				_velocity = velocity _player;
				_player moveInDriver _chute;
				if (IL_Para_Jump_Velocity) then
				{
					_chute setVelocity _velocity;
				};
			};
		};
		_player allowDamage true;
		
	};

    IL_GetOut = {
        private ["_cargo", "_v", "_last_attach_pos"];
        IL_Client_GetOut = _this;
        if (isServer) then
        {
            IL_Client_GetOut spawn IL_Server_GetOut;
        }
        else
        {
            publicVariableServer "IL_Client_GetOut";
        };
    };
    "IL_Client_GetOut" addPublicVariableEventHandler IL_GetOut;

};

_vsupported = false;
if (_obj_main_type in IL_Supported_Vehicles_MOHAWK) then
{
	
	_vsupported = true;
	[_obj_main] call IL_Init_Veh;

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on CH-49</t>",
	{
		[_this select 0, IL_Supported_Cargo_NonVeh_Mohawk] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-6,-3], IL_Supported_Cargo_NonVeh_Mohawk, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-6,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'CargoRamp_Open' == 1)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load vehicle on CH-49</t>",
	{
		[_this select 0, IL_Supported_Cargo_Veh_Mohawk] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-6,-3], IL_Supported_Cargo_Veh_Mohawk, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-6,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'CargoRamp_Open' == 1)"
	];

	_obj_main addAction [
	"<t color=""#007f0e"">Get in CH-49</t>",
	{
		(_this select 1) moveInCargo (_this select 0);
	},[],IL_Action_LU_Priority,false,true,"",
	"(_this in (nearestObjects[ _target modelToWorld [0,-6,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && ((_target emptyPositions 'cargo') > 0) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'CargoRamp_Open' > 0.43) && (_target getVariable 'usable_ramp')"
	];

	_obj_main addAction [
	"<t color=""#ff0000"">Get out CH-49</t>",
	{
		[_this select 0, _this select 1, false] call IL_GetOut;
	},[],IL_Action_LU_Priority,false,true,"",
	"('cargo' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'CargoRamp_Open' > 0.43) && (_target getVariable 'usable_ramp')"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff""> Eject</t>",
	{
		[_this select 0, _this select 1, true] call IL_GetOut;
	},[],IL_Action_LU_Priority,false,true,"",
	"('cargo' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (((getPosATL _target) select 2) >= IL_Para_Jump_ATL) && (_target animationPhase 'CargoRamp_Open' > 0.43) && (_target getVariable 'usable_ramp')"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from CH-49</t>",
	{
		[_this select 0] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num' < 0) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-6,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'CargoRamp_Open' == 1)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff"">  Unload cargo with parachute</t>",
	{
		[_this select 0, true] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'CargoRamp_Open' == 1)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload_all_para.paa' /><t color=""#a50b00"">  Unload ALL cargo with parachute</t>",
	{
		while {((_this select 0) getVariable "box_num") != 0} do
		{
			[_this select 0, true] call IL_Do_Unload;
		};
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'CargoRamp_Open' == 1)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Open cargo ramp in CH-49</t>",
	{
		_this select 0 animatedoor ['CargoRamp_Open', 1];
	},[],IL_Action_O_Priority,false,true,"",
	"((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-6,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target animationPhase 'CargoRamp_Open' == 0) && (_target getVariable 'can_load')"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Close cargo ramp in CH-49</t>",
	{
		_this select 0 animatedoor ['CargoRamp_Open', 0];
	},[],IL_Action_O_Priority,false,true,"",
	"((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-6,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target animationPhase 'CargoRamp_Open' == 1) && (_target getVariable 'can_load')"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable loading for Co-Pilot</t>",
	{
		(_this select 0) setVariable["can_copilot", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && !(_target getVariable 'can_copilot') && IL_Can_CoPilot)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable loading for Co-Pilot</t>",
	{
		(_this select 0) setVariable["can_copilot", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && (_target getVariable 'can_copilot') && IL_Can_CoPilot)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && !(_target getVariable 'can_outside') && IL_Can_Outside)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_outside') && IL_Can_Outside)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable usable ramp</t>",
	{
		(_this select 0) setVariable["usable_ramp", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && !(_target getVariable 'usable_ramp') && IL_Ramp)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable usable ramp</t>",
	{
		(_this select 0) setVariable["usable_ramp", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'usable_ramp') && IL_Ramp)"
	];
};
if (_obj_main_type in IL_Supported_Vehicles_CHINOOK) then
{
	
	_vsupported = true;
	[_obj_main] call IL_Init_Veh;

	if (typeOf _obj_main == "CH_147F") then
	{
		_obj_main addAction [
		"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on Chinook</t>",
		{
			[_this select 0, IL_Supported_Cargo_NonVeh_CHINOOK] call IL_Do_Load;
		},[],IL_Action_LU_Priority,true,true,"",
		"(count(nearestObjects[ _target modelToWorld [0,-9,-3], IL_Supported_Cargo_NonVeh_CHINOOK, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'ani_ramp' == 1)"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load vehicle on Chinook</t>",
		{
			[_this select 0, IL_Supported_Cargo_Veh_CHINOOK] call IL_Do_Load;
		},[],IL_Action_LU_Priority,true,true,"",
		"(count(nearestObjects[ _target modelToWorld [0,-9,-3], IL_Supported_Cargo_Veh_CHINOOK, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'ani_ramp' == 1)"
		];

		_obj_main addAction [
		"<t color=""#007f0e"">Get in Chinook Ride in back</t>",
		{
			(_this select 1) moveInCargo (_this select 0);
		},[],IL_Action_LU_Priority,false,true,"",
		"(_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && ((_target emptyPositions 'cargo') > 0) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'ani_ramp' > 0.43) && (_target getVariable 'usable_ramp')"
		];

		_obj_main addAction [
		"<t color=""#007f0e"">Get in Chinook</t>",
		{
			(_this select 1) setDir (getDir (_this select 0));
			_pos = ([(_this select 0), 4.5, (getDir (_this select 0))] call BIS_fnc_relPos);
			_pos = [_pos select 0, _pos select 1, ((getPosATL (_this select 0)) select 2) + 1];
			(_this select 1) setPosATL _pos;
		},[],IL_Action_LU_Priority,false,true,"",
		"(_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && ((_target emptyPositions 'cargo') > 0) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'ani_ramp' > 0.43) && (_target getVariable 'usable_ramp')"
		];

		_obj_main addAction [
		"<t color=""#ff0000"">Get out Chinook</t>",
		{
			[_this select 0, _this select 1, false] call IL_GetOut;
		},[],IL_Action_LU_Priority,false,true,"",
		"('cargo' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'ani_ramp' > 0.43) && (_target getVariable 'usable_ramp')"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff""> Eject</t>",
		{
			[_this select 0, _this select 1, true] call IL_GetOut;
		},[],IL_Action_LU_Priority,false,true,"",
		"('cargo' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (((getPosATL _target) select 2) >= IL_Para_Jump_ATL) && (_target animationPhase 'ani_ramp' > 0.43) && (_target getVariable 'usable_ramp')"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from Chinook</t>",
		{
			[_this select 0] call IL_Do_Unload;
		},[],IL_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num' < 0) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'ani_ramp' == 1)"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff"">  Unload cargo with parachute</t>",
		{
			[_this select 0, true] call IL_Do_Unload;
		},[],IL_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'ani_ramp' == 1)"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload_all_para.paa' /><t color=""#a50b00"">  Unload ALL cargo with parachute</t>",
		{
			while {((_this select 0) getVariable "box_num") != 0} do
			{
				[_this select 0, true] call IL_Do_Unload;
			};
		},[],IL_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'ani_ramp' == 1)"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Open cargo ramp in Chinook</t>",
		{
			_this select 0 animatedoor ['ani_ramp', 1];
			_this select 0 animatedoor ['ani_ramp2', 1];
		},[],IL_Action_O_Priority,false,true,"",
		"((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target animationPhase 'ani_ramp' == 0) && (_target getVariable 'can_load')"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Close cargo ramp in Chinook</t>",
		{
			_this select 0 animatedoor ['ani_ramp', 0];
			_this select 0 animatedoor ['ani_ramp2', 0];
		},[],IL_Action_O_Priority,false,true,"",
		"((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target animationPhase 'ani_ramp' == 1) && (_target getVariable 'can_load')"
		];
	};
	if (typeOf _obj_main == "CH_47F") then
	{
		_obj_main addAction [
		"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on Chinook</t>",
		{
			[_this select 0, IL_Supported_Cargo_NonVeh_CHINOOK] call IL_Do_Load;
		},[],IL_Action_LU_Priority,true,true,"",
		"(count(nearestObjects[ _target modelToWorld [0,-9,-3], IL_Supported_Cargo_NonVeh_CHINOOK, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'Ramp' == 1)"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load vehicle on Chinook</t>",
		{
			[_this select 0, IL_Supported_Cargo_Veh_CHINOOK] call IL_Do_Load;
		},[],IL_Action_LU_Priority,true,true,"",
		"(count(nearestObjects[ _target modelToWorld [0,-9,-3], IL_Supported_Cargo_Veh_CHINOOK, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'Ramp' == 1)"
		];

		_obj_main addAction [
		"<t color=""#007f0e"">Get in Chinook Ride in back</t>",
		{
			(_this select 1) moveInCargo (_this select 0);
		},[],IL_Action_LU_Priority,false,true,"",
		"(_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && ((_target emptyPositions 'cargo') > 0) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'Ramp' > 0.43) && (_target getVariable 'usable_ramp')"
		];

		_obj_main addAction [
		"<t color=""#007f0e"">Get in Chinook</t>",
		{
			(_this select 1) setDir (getDir (_this select 0));
			_pos = ([(_this select 0), 4.5, (getDir (_this select 0))] call BIS_fnc_relPos);
			_pos = [_pos select 0, _pos select 1, ((getPosATL (_this select 0)) select 2) + 1];
			(_this select 1) setPosATL _pos;
		},[],IL_Action_LU_Priority,false,true,"",
		"(_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && ((_target emptyPositions 'cargo') > 0) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'Ramp' > 0.43) && (_target getVariable 'usable_ramp')"
		];

		_obj_main addAction [
		"<t color=""#ff0000"">Get out Chinook</t>",
		{
			[_this select 0, _this select 1, false] call IL_GetOut;
		},[],IL_Action_LU_Priority,false,true,"",
		"('cargo' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'Ramp' > 0.43) && (_target getVariable 'usable_ramp')"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff""> Eject</t>",
		{
			[_this select 0, _this select 1, true] call IL_GetOut;
		},[],IL_Action_LU_Priority,false,true,"",
		"('cargo' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (((getPosATL _target) select 2) >= IL_Para_Jump_ATL) && (_target animationPhase 'Ramp' > 0.43) && (_target getVariable 'usable_ramp')"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from Chinook</t>",
		{
			[_this select 0] call IL_Do_Unload;
		},[],IL_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num' < 0) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'Ramp' == 1)"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff"">  Unload cargo with parachute</t>",
		{
			[_this select 0, true] call IL_Do_Unload;
		},[],IL_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'Ramp' == 1)"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload_all_para.paa' /><t color=""#a50b00"">  Unload ALL cargo with parachute</t>",
		{
			while {((_this select 0) getVariable "box_num") != 0} do
			{
				[_this select 0, true] call IL_Do_Unload;
			};
		},[],IL_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'Ramp' == 1)"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Open cargo ramp in Chinook</t>",
		{
			_this select 0 animate ['Ramp', 1];
		},[],IL_Action_O_Priority,false,true,"",
		"((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target animationPhase 'Ramp' == 0) && (_target getVariable 'can_load')"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Close cargo ramp in Chinook</t>",
		{
			_this select 0 animate ['Ramp', 0];
		},[],IL_Action_O_Priority,false,true,"",
		"((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target animationPhase 'Ramp' == 1) && (_target getVariable 'can_load')"
		];
	};
	if (typeOf _obj_main in ["kyo_MH47E_HC", "kyo_MH47E_Ramp", "kyo_MH47E_base"]) then
	{
		_obj_main addAction [
		"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on Chinook</t>",
		{
			[_this select 0, IL_Supported_Cargo_NonVeh_CHINOOK] call IL_Do_Load;
		},[],IL_Action_LU_Priority,true,true,"",
		"(count(nearestObjects[ _target modelToWorld [0,-9,-3], IL_Supported_Cargo_NonVeh_CHINOOK, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'Ani_Ramp' < 0.43)"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load vehicle on Chinook</t>",
		{
			[_this select 0, IL_Supported_Cargo_Veh_CHINOOK] call IL_Do_Load;
		},[],IL_Action_LU_Priority,true,true,"",
		"(count(nearestObjects[ _target modelToWorld [0,-9,-3], IL_Supported_Cargo_Veh_CHINOOK, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'Ani_Ramp' < 0.43)"
		];

		_obj_main addAction [
		"<t color=""#007f0e"">Get in Chinook Ride in back</t>",
		{
			(_this select 1) moveInCargo (_this select 0);
		},[],IL_Action_LU_Priority,false,true,"",
		"(_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && ((_target emptyPositions 'cargo') > 0) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'Ani_Ramp' < 0.43) && (_target getVariable 'usable_ramp')"
		];

		_obj_main addAction [
		"<t color=""#007f0e"">Get in Chinook</t>",
		{
			(_this select 1) setDir (getDir (_this select 0));
			_pos = ([(_this select 0), 4.5, (getDir (_this select 0))] call BIS_fnc_relPos);
			_pos = [_pos select 0, _pos select 1, ((getPosATL (_this select 0)) select 2) + 1];
			(_this select 1) setPosATL _pos;
		},[],IL_Action_LU_Priority,false,true,"",
		"(_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && ((_target emptyPositions 'cargo') > 0) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'Ani_Ramp' < 0.43) && (_target getVariable 'usable_ramp')"
		];

		_obj_main addAction [
		"<t color=""#ff0000"">Get out Chinook</t>",
		{
			[_this select 0, _this select 1, false] call IL_GetOut;
		},[],IL_Action_LU_Priority,false,true,"",
		"('cargo' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'Ani_Ramp' < 0.43) && (_target getVariable 'usable_ramp')"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff""> Eject</t>",
		{
			[_this select 0, _this select 1, true] call IL_GetOut;
		},[],IL_Action_LU_Priority,false,true,"",
		"('cargo' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (((getPosATL _target) select 2) >= IL_Para_Jump_ATL) && (_target animationPhase 'Ani_Ramp' < 0.43) && (_target getVariable 'usable_ramp')"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from Chinook</t>",
		{
			[_this select 0] call IL_Do_Unload;
		},[],IL_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num' < 0) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'Ani_Ramp' < 0.43)"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff"">  Unload cargo with parachute</t>",
		{
			[_this select 0, true] call IL_Do_Unload;
		},[],IL_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'Ani_Ramp' < 0.43)"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload_all_para.paa' /><t color=""#a50b00"">  Unload ALL cargo with parachute</t>",
		{
			while {((_this select 0) getVariable "box_num") != 0} do
			{
				[_this select 0, true] call IL_Do_Unload;
			};
		},[],IL_Action_LU_Priority,false,true,"",
		"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'Ani_Ramp' < 0.43)"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Open cargo ramp in Chinook</t>",
		{
			_this select 0 animate ['Ani_Ramp', 0];
		},[],IL_Action_O_Priority,false,true,"",
		"((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target animationPhase 'Ani_Ramp' == 1) && (_target getVariable 'can_load')"
		];

		_obj_main addAction [
		"<t color=""#0000ff"">Close cargo ramp in Chinook</t>",
		{
			_this select 0 animate ['Ani_Ramp', 1];
		},[],IL_Action_O_Priority,false,true,"",
		"((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target animationPhase 'Ani_Ramp' == 0) && (_target getVariable 'can_load')"
		];
	};

	_obj_main addAction [
	"<t color=""#0000ff"">Enable loading for Co-Pilot</t>",
	{
		(_this select 0) setVariable["can_copilot", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && !(_target getVariable 'can_copilot') && IL_Can_CoPilot)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable loading for Co-Pilot</t>",
	{
		(_this select 0) setVariable["can_copilot", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && (_target getVariable 'can_copilot') && IL_Can_CoPilot)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && !(_target getVariable 'can_outside') && IL_Can_Outside)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_outside') && IL_Can_Outside)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable usable ramp</t>",
	{
		(_this select 0) setVariable["usable_ramp", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && !(_target getVariable 'usable_ramp') && IL_Ramp)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable usable ramp</t>",
	{
		(_this select 0) setVariable["usable_ramp", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'usable_ramp') && IL_Ramp)"
	];
};
if (_obj_main_type in IL_Supported_Vehicles_C130J) then
{
	
	_vsupported = true;
	[_obj_main] call IL_Init_Veh;

	if (_obj_main_type == "C130J") then
	{
		_obj_main addAction [
		"<t color=""#ff0000"">Get out on the side of ramp</t>",
		{
			[_this select 0, _this select 1, false] call IL_GetOut;
		},[],IL_Action_LU_Priority,false,true,"",
		"('cargo' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'ramp_bottom' > 0.43) && (_target getVariable 'usable_ramp')"
		];

		_obj_main addAction [
		"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff""> Eject</t>",
		{
			[_this select 0, _this select 1, true] call IL_GetOut;
		},[],IL_Action_LU_Priority,false,true,"",
		"('cargo' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'ramp_bottom' > 0.9) && (_target getVariable 'usable_ramp')"
		];
	};

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on C-130J</t>",
	{
		[_this select 0, IL_Supported_Cargo_NonVeh_C130J] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-9,-5.4], IL_Supported_Cargo_NonVeh_C130J, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-5.4], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'ramp_bottom' == 1) && (_target animationPhase 'ramp_top' == 1)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load vehicle on C-130J</t>",
	{
		[_this select 0, IL_Supported_Cargo_Veh_C130J] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-9,-5.4], IL_Supported_Cargo_Veh_C130J, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-5.4], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'ramp_bottom' == 1) && (_target animationPhase 'ramp_top' == 1)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from C-130J</t>",
	{
		[_this select 0] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num' < 0) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-9,-5.4], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'ramp_bottom' == 1) && (_target animationPhase 'ramp_top' == 1)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff"">  Unload cargo with parachute</t>",
	{
		[_this select 0, true] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'ramp_bottom' == 1) && (_target animationPhase 'ramp_top' == 1)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload_all_para.paa' /><t color=""#a50b00"">  Unload ALL cargo with parachute</t>",
	{
		while {((_this select 0) getVariable "box_num") != 0} do
		{
			[_this select 0, true] call IL_Do_Unload;
		};
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'ramp_bottom' == 1) && (_target animationPhase 'ramp_top' == 1)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable loading for Co-Pilot</t>",
	{
		(_this select 0) setVariable["can_copilot", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && !(_target getVariable 'can_copilot') && IL_Can_CoPilot)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable loading for Co-Pilot</t>",
	{
		(_this select 0) setVariable["can_copilot", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && (_target getVariable 'can_copilot') && IL_Can_CoPilot)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && !(_target getVariable 'can_outside') && IL_Can_Outside)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_outside') && IL_Can_Outside)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable usable ramp</t>",
	{
		(_this select 0) setVariable["usable_ramp", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && !(_target getVariable 'usable_ramp') && IL_Ramp)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable usable ramp</t>",
	{
		(_this select 0) setVariable["usable_ramp", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'usable_ramp') && IL_Ramp)"
	];
};
if (_obj_main_type in IL_Supported_Vehicles_C17) then
{
	
	_vsupported = true;
	[_obj_main] call IL_Init_Veh;

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on C17</t>",
	{
		[_this select 0, IL_Supported_Cargo_C17] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-16.5,-3.2], IL_Supported_Cargo_NonVeh_C17, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-16.5 + IL_SDistL + IL_SDistL_Heli_offset,-2], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'back_ramp' == 1)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load vehicle on C17</t>",
	{
		[_this select 0, IL_Supported_Cargo_C17] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-16.5,-3.2], IL_Supported_Cargo_Veh_C17, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-16.5 + IL_SDistL + IL_SDistL_Heli_offset,-2], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'back_ramp' == 1)"
	];

	_obj_main addAction [
	"<t color=""#007f0e"">Get in C17</t>",
	{
		(_this select 1) moveInCargo (_this select 0);
	},[],IL_Action_LU_Priority,false,true,"",
	"(_this in (nearestObjects[ _target modelToWorld [0,-16.5 + IL_SDistL + IL_SDistL_Heli_offset,-2], [], IL_SDistL + IL_SDistL_Heli_offset])) && ((_target emptyPositions 'cargo') > 0) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'back_ramp' > 0.43) && (_target getVariable 'usable_ramp')"
	];

	_obj_main addAction [
	"<t color=""#ff0000"">Get out C17</t>",
	{
		[_this select 0, _this select 1, false] call IL_GetOut;
	},[],IL_Action_LU_Priority,false,true,"",
	"('cargo' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'back_ramp' > 0.43) && (_target getVariable 'usable_ramp')"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff""> Eject</t>",
	{
		[_this select 0, _this select 1, true] call IL_GetOut;
	},[],IL_Action_LU_Priority,false,true,"",
	"('cargo' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'back_ramp' > 0.43) && (_target getVariable 'usable_ramp')"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from C17</t>",
	{
		[_this select 0] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-16.5 + IL_SDistL + IL_SDistL_Heli_offset,-2], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt) && (_target animationPhase 'back_ramp' == 1)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff"">  Unload cargo with parachute</t>",
	{
		[_this select 0, true] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'back_ramp' == 1)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload_all_para.paa' /><t color=""#a50b00"">  Unload ALL cargo with parachute</t>",
	{
		while {((_this select 0) getVariable "box_num") != 0} do
		{
			[_this select 0, true] call IL_Do_Unload;
		};
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL) && (_target animationPhase 'back_ramp' == 1)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Open cargo doors in C17</t>",
	{
		_this select 0 animate ['back_ramp', 1];
		_this select 0 animate ['back_ramp_door_main', 1];
		_this select 0 animate ['back_ramp_st', 1];

	},[],IL_Action_O_Priority,false,true,"",
	"((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-16.5 + IL_SDistL + IL_SDistL_Heli_offset,-2], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target animationPhase 'back_ramp' == 0) && (_target getVariable 'can_load')"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Close cargo doors in C17</t>",
	{
		_this select 0 animate ['back_ramp_st', 0];
		_this select 0 animate ['back_ramp', 0];
		_this select 0 animate ['back_ramp_door_main', 0];
	},[],IL_Action_O_Priority,false,true,"",
	"((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || ((_this in (nearestObjects[ _target modelToWorld [0,-16.5 + IL_SDistL + IL_SDistL_Heli_offset,-2], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside'))) && (_target animationPhase 'back_ramp' == 1) && (_target getVariable 'can_load')"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable loading for Co-Pilot</t>",
	{
		(_this select 0) setVariable["can_copilot", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && !(_target getVariable 'can_copilot') && IL_Can_CoPilot)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable loading for Co-Pilot</t>",
	{
		(_this select 0) setVariable["can_copilot", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && (_target getVariable 'can_copilot') && IL_Can_CoPilot)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && !(_target getVariable 'can_outside') && IL_Can_Outside)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_outside') && IL_Can_Outside)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable usable ramp</t>",
	{
		(_this select 0) setVariable["usable_ramp", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && !(_target getVariable 'usable_ramp') && IL_Ramp)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable usable ramp</t>",
	{
		(_this select 0) setVariable["usable_ramp", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'usable_ramp') && IL_Ramp)"
	];
};
if (_obj_main_type in IL_Supported_Vehicles_MH9) then
{
	
	_vsupported = true;
	[_obj_main] call IL_Init_Veh;

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on left MH-9</t>",
	{
		[_this select 0, IL_Supported_Cargo_MH9, "L"] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count (nearestObjects[ _target modelToWorld [0-3,1,-1.3], IL_Supported_Cargo_MH9, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || (((_this in (nearestObjects[ _target modelToWorld [0-3,1,-1.3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num_l' > _target getVariable 'slots_num_l') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on right MH-9</t>",
	{
		[_this select 0, IL_Supported_Cargo_MH9, "R"] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count (nearestObjects[ _target modelToWorld [0+3,1,-1.3], IL_Supported_Cargo_MH9, IL_SDistL + IL_SDistL_Heli_offset]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || (((_this in (nearestObjects[ _target modelToWorld [0+3,1,-1.3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num_r' > _target getVariable 'slots_num_r') && (_target getVariable 'can_load') && (((getPos _target) select 2) <= IL_LU_Alt)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from left MH-9</t>",
	{
		[_this select 0, false, "L"] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num_l' < 0) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || (((_this in (nearestObjects[ _target modelToWorld [0-3,1,-1.3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from right MH-9</t>",
	{
		[_this select 0, false, "R"] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num_r' < 0) && ((IL_Can_Inside && (driver _target == _this)) || (IL_Can_Inside && ('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot')) || (((_this in (nearestObjects[ _target modelToWorld [0+3,1,-1.3], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed) && (((getPos _target) select 2) <= IL_LU_Alt)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff"">  Unload cargo with parachute left MH-9</t>",
	{
		[_this select 0, true, "L"] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num_l' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff"">  Unload cargo with parachute right MH-9</t>",
	{
		[_this select 0, true, "R"] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num_r' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload_all_para.paa' /><t color=""#a50b00"">  Unload ALL cargo with parachute</t>",
	{
		[_this select 0, true, "L"] call IL_Do_Unload;
		[_this select 0, true, "R"] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num_r' < 0) && (_target getVariable 'box_num_l' < 0) && ((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_load') && (((getPosATL _target) select 2) >= IL_Para_Drop_ATL)"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload_para.paa' /><t color=""#b200ff""> Eject</t>",
	{
		[_this select 0, _this select 1, true] call IL_GetOut;
	},[],IL_Action_LU_Priority,false,true,"",
	"('cargo' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (((getPosATL _target) select 2) >= IL_Para_Jump_ATL) && (_target getVariable 'usable_ramp')"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable loading for Co-Pilot</t>",
	{
		(_this select 0) setVariable["can_copilot", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && !(_target getVariable 'can_copilot') && IL_Can_CoPilot)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable loading for Co-Pilot</t>",
	{
		(_this select 0) setVariable["can_copilot", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && (_target getVariable 'can_copilot') && IL_Can_CoPilot)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && !(_target getVariable 'can_outside') && IL_Can_Outside)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'can_outside') && IL_Can_Outside)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable usable ramp</t>",
	{
		(_this select 0) setVariable["usable_ramp", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && !(_target getVariable 'usable_ramp') && IL_Ramp)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable usable ramp</t>",
	{
		(_this select 0) setVariable["usable_ramp", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"(((driver _target == _this) || (('Turret' in (assignedVehicleRole _this)) && (vehicle _this == _target) && (_target getVariable 'can_copilot'))) && (_target getVariable 'usable_ramp') && IL_Ramp)"
	];

};
if (_obj_main_type in IL_Supported_Vehicles_OFFROAD) then
{
	
	_vsupported = true;
	[_obj_main] call IL_Init_Veh;

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on Offroad</t>",
	{
		[_this select 0, IL_Supported_Cargo_NonVeh_OFFROAD] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-4.5,0], IL_Supported_Cargo_NonVeh_OFFROAD, IL_SDistL]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || ((((_this in (nearestObjects[ _target modelToWorld [0,-4.5,0], [], IL_SDistL + IL_SDistL_Heli_offset]))) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load')"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load vehicle on Offroad</t>",
	{
		[_this select 0, IL_Supported_Cargo_Veh_OFFROAD] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-4.5,0], IL_Supported_Cargo_Veh_OFFROAD, IL_SDistL]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || ((((_this in (nearestObjects[ _target modelToWorld [0,-4.5,0], [], IL_SDistL + IL_SDistL_Heli_offset]))) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load')"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from Offroad</t>",
	{
		[_this select 0] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num' < 0) && ((IL_Can_Inside && (driver _target == _this)) || (((_this in (nearestObjects[ _target modelToWorld [0,-4.5,0], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed)"
	];
	_obj_main addAction [
	"<t color=""#0000ff"">Enable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && !(_target getVariable 'can_outside') && IL_Can_Outside)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && (_target getVariable 'can_outside') && IL_Can_Outside)"
	];
};
if (_obj_main_type in IL_Supported_Vehicles_VAN) then
{
	
	_vsupported = true;
	[_obj_main] call IL_Init_Veh;

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on VAN</t>",
	{
		[_this select 0, IL_Supported_Cargo_NonVeh_VAN] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-4.5,0], IL_Supported_Cargo_NonVeh_VAN, IL_SDistL]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || ((((_this in (nearestObjects[ _target modelToWorld [0,-4.5,0], [], IL_SDistL + IL_SDistL_Heli_offset]))) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load')"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load vehicle on VAN</t>",
	{
		[_this select 0, IL_Supported_Cargo_Veh_VAN] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-4.5,0], IL_Supported_Cargo_Veh_VAN, IL_SDistL]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || ((((_this in (nearestObjects[ _target modelToWorld [0,-4.5,0], [], IL_SDistL + IL_SDistL_Heli_offset]))) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load')"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from VAN</t>",
	{
		[_this select 0] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num' < 0) && ((IL_Can_Inside && (driver _target == _this)) || (((_this in (nearestObjects[ _target modelToWorld [0,-4.5,0], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && !(_target getVariable 'can_outside') && IL_Can_Outside)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && (_target getVariable 'can_outside') && IL_Can_Outside)"
	];
};
if (_obj_main_type in IL_Supported_Vehicles_KAMAZ) then
{
	
	_vsupported = true;
	[_obj_main] call IL_Init_Veh;

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on ZAMAK</t>",
	{
		[_this select 0, IL_Supported_Cargo_NonVeh_Kamaz] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-6 - (_target getVariable 'load_offset'),0], IL_Supported_Cargo_NonVeh_Kamaz, IL_SDistL]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || ((((_this in (nearestObjects[ _target modelToWorld [0,-6 - (_target getVariable 'load_offset'),0], [], IL_SDistL + IL_SDistL_Heli_offset]))) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load')"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load vehicle on ZAMAK</t>",
	{
		[_this select 0, IL_Supported_Cargo_Veh_Kamaz] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-6 - (_target getVariable 'load_offset'),0], IL_Supported_Cargo_Veh_Kamaz, IL_SDistL]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || ((((_this in (nearestObjects[ _target modelToWorld [0,-6 - (_target getVariable 'load_offset'),0], [], IL_SDistL + IL_SDistL_Heli_offset]))) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load')"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from ZAMAK</t>",
	{
		[_this select 0] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num' < 0) && ((IL_Can_Inside && (driver _target == _this)) || (((_this in (nearestObjects[ _target modelToWorld [0,-6 - (_target getVariable 'load_offset'),0], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed)"
	];
	_obj_main addAction [
	"<t color=""#0000ff"">Enable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && !(_target getVariable 'can_outside') && IL_Can_Outside)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && (_target getVariable 'can_outside') && IL_Can_Outside)"
	];
};
if (_obj_main_type in IL_Supported_Vehicles_TEMPEST) then
{
	
	_vsupported = true;
	[_obj_main] call IL_Init_Veh;

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on TEMPEST</t>",
	{
		[_this select 0, IL_Supported_Cargo_NonVeh_TEMPEST] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-6.5 - (_target getVariable 'load_offset'),0], IL_Supported_Cargo_NonVeh_TEMPEST, IL_SDistL]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || ((((_this in (nearestObjects[ _target modelToWorld [0,-6.5 - (_target getVariable 'load_offset'),0], [], IL_SDistL + IL_SDistL_Heli_offset]))) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load')"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load vehicle on TEMPEST</t>",
	{
		[_this select 0, IL_Supported_Cargo_Veh_TEMPEST] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-6.5 - (_target getVariable 'load_offset'),0], IL_Supported_Cargo_Veh_TEMPEST, IL_SDistL]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || ((((_this in (nearestObjects[ _target modelToWorld [0,-6.5 - (_target getVariable 'load_offset'),0], [], IL_SDistL + IL_SDistL_Heli_offset]))) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load')"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from TEMPEST</t>",
	{
		[_this select 0] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num' < 0) && ((IL_Can_Inside && (driver _target == _this)) || (((_this in (nearestObjects[ _target modelToWorld [0,-6.5 - (_target getVariable 'load_offset'),0], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed)"
	];
	_obj_main addAction [
	"<t color=""#0000ff"">Enable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && !(_target getVariable 'can_outside') && IL_Can_Outside)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && (_target getVariable 'can_outside') && IL_Can_Outside)"
	];
};
if (_obj_main_type in IL_Supported_Vehicles_HEMTT) then
{
	
	_vsupported = true;
	[_obj_main] call IL_Init_Veh;

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load cargo on HEMTT</t>",
	{
		[_this select 0, IL_Supported_Cargo_NonVeh_HEMTT] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-7 - (_target getVariable 'load_offset'),0], IL_Supported_Cargo_NonVeh_HEMTT, IL_SDistL]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || (((_this in (nearestObjects[ _target modelToWorld [0,-7 - (_target getVariable 'load_offset'),0], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load')"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\load.paa' /><t color=""#007f0e"">  Load vehicle on HEMTT</t>",
	{
		[_this select 0, IL_Supported_Cargo_Veh_HEMTT] call IL_Do_Load;
	},[],IL_Action_LU_Priority,true,true,"",
	"(count(nearestObjects[ _target modelToWorld [0,-7 - (_target getVariable 'load_offset'),0], IL_Supported_Cargo_Veh_HEMTT, IL_SDistL]) > 0) && (abs(speed _target) <= IL_LU_Speed) && ((IL_Can_Inside && (driver _target == _this)) || (((_this in (nearestObjects[ _target modelToWorld [0,-7 - (_target getVariable 'load_offset'),0], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'box_num' > _target getVariable 'slots_num') && (_target getVariable 'can_load')"
	];

	_obj_main addAction [
	"<img image='IgiLoad\images\unload.paa' /><t color=""#ff0000"">  Unload cargo from HEMTT</t>",
	{
		[_this select 0] call IL_Do_Unload;
	},[],IL_Action_LU_Priority,false,true,"",
	"(_target getVariable 'box_num' < 0) && ((IL_Can_Inside && (driver _target == _this)) || (((_this in (nearestObjects[ _target modelToWorld [0,-7 - (_target getVariable 'load_offset'),0], [], IL_SDistL + IL_SDistL_Heli_offset])) && (_target getVariable 'can_outside')))) && (_target getVariable 'can_load') && (abs(speed _target) <= IL_LU_Speed)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Enable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", true, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && !(_target getVariable 'can_outside') && IL_Can_Outside)"
	];

	_obj_main addAction [
	"<t color=""#0000ff"">Disable loading from outside</t>",
	{
		(_this select 0) setVariable["can_outside", false, true];;
	},[],IL_Action_S_Priority,false,true,"",
	"((driver _target == _this) && (_target getVariable 'can_outside') && IL_Can_Outside)"
	];
};