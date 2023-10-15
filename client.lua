QBCore = exports['qb-core']:GetCoreObject()

local basla = false
local ui = false
local deadaq = false
local spawnedped = nil

RegisterNetEvent('magic:start', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    deadaq = PlayerData.metadata['isdead']
    if deadaq then
        TriggerEvent('fake:revive')
    end
    SetNuiFocus(true, true)
    Citizen.Wait(500)

    if deadaq then
        TriggerEvent("tgiann:playerdead", true)
        -- TriggerServerEvent('esx_ambulancejob:setDeathStatus', true) 
    end

    local ped = PlayerPedId()
    ClearPedTasks(ped)
    TriggerEvent('baslat')
    local pedcoord = vector3(-1266.9507, -3013.0781, -49.4902)
    local pedheading = 6.5421
    local spawnPos = vector3(-1267.3927, -3007.8667, -48.4902)
    local spawnHeading = 271.5592
    oldcoord = GetEntityCoords(ped)
    SetEntityCoords(ped, -1267.3702, -3003.5459, -49.4900)
    SetEntityHeading(ped, 182.1322)
    FreezeEntityPosition(ped, true)
    RequestModel(GetHashKey("a_f_m_beach_01"))
    while (not HasModelLoaded(GetHashKey("a_f_m_beach_01"))) do
        Citizen.Wait(1)
    end
    RequestModel(GetHashKey("riot"))
    while (not HasModelLoaded(GetHashKey("riot"))) do
        Citizen.Wait(1)
    end
    RequestModel(GetHashKey("mp_m_freemode_01"))
    while (not HasModelLoaded(GetHashKey("mp_m_freemode_01"))) do
        Citizen.Wait(1)
    end
    Citizen.Wait(1500)
    local vehicle = CreateVehicle('riot', spawnPos, spawnHeading, false, true)
    pedaq = CreatePed(0, 'a_f_m_beach_01', pedcoord.x, pedcoord.y, pedcoord.z, pedheading, false, true)
    spawnedped = CreatePed(0, 'mp_m_freemode_01', pedcoord.x, pedcoord.y, pedcoord.z + 4, pedheading, false, true)
    if true then
        hitboxFunc()
    end
    SetEntityAlpha(vehicle, 0)
    SetEntityAlpha(pedaq, 0)
    SetEntityAlpha(spawnedped, 0)
    FreezeEntityPosition(pedaq, true)
    FreezeEntityPosition(spawnedped, true)
    FreezeEntityPosition(vehicle, true)
    pedcan = GetEntityHealth(pedaq)
    GiveWeaponToPed(ped, GetHashKey('WEAPON_COMPACTRIFLE'), 50, false, true)
    SetPedAmmo(ped, GetHashKey('WEAPON_COMPACTRIFLE'), 50)
    SetAmmoInClip(ped, GetHashKey('WEAPON_COMPACTRIFLE'), 10)
    RefillAmmoInstantly(ped)
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    SetCamCoord(cam, -1267.3702, -3003.5459, -47.4900)
    PointCamAtCoord(cam, pedcoord)
    Citizen.Wait(5000)
    TaskShootAtEntity(ped, pedaq, 4000, "FIRING_PATTERN_DELAY_FIRE_BY_ONE_SEC")
    Citizen.Wait(4000)
    pedcan2 = GetEntityHealth(pedaq)
    DeleteVehicle(vehicle)
    DeletePed(pedaq)
    DeletePed(spawnedped)
    SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
    Citizen.Wait(500)
    SetNuiFocus(false, false)
    SendNUIMessage({showUI = false; }) -- Sends a message to the js file.
    basla = false
    SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
    SetEntityCoords(ped, oldcoord)
    FreezeEntityPosition(ped, false)
    Citizen.Wait(1000)
    FreezeEntityPosition(ped, false)
    Citizen.Wait(1500)
    if deadaq then
        SetEntityHealth(PlayerPedId(), 0)
    end
    TriggerServerEvent('GSR:Remove')
end)

RegisterNetEvent('baslat')
AddEventHandler('baslat', function()
    basla = true
    while basla do
        Citizen.Wait(0)
        DisableControlAction(0, 0)
        DisableControlAction(0, 1)
        DisableControlAction(0, 2)
        DisableControlAction(0, 3)
        DisableControlAction(0, 4)
        DisableControlAction(0, 5)
        DisableControlAction(0, 6)
        DisableControlAction(0, 30)
        DisableControlAction(0, 31)
        DisableControlAction(0, 32)
        DisableControlAction(0, 34) 
    end
    SetCamActive(cam, false)
    RenderScriptCams(false, false, 0, true, true)
    cam = nil
    if pedcan2 < pedcan then
        TriggerServerEvent('yolver')
    end
    local ped = PlayerPedId()
    SetEntityCoords(ped, oldcoord)
    FreezeEntityPosition(ped, false)
end)



function RoundNumber(num, numRoundNumber)
    local mult = 10^(numRoundNumber or 0)
    return math.floor(num * mult + 0.5) / mult
end

function hitboxFunc()
    local model = GetEntityModel(spawnedped)
    local min, max = GetModelDimensions(model)

    mindata = 'mindata.X: '.. RoundNumber(min.x, 5)..' mindata.Y: '.. RoundNumber(min.y, 5)..' mindata.Z: '.. RoundNumber(min.z, 5)..' maxdata.X: '..RoundNumber(max.x, 10)..' maxdata.Y: '..RoundNumber(max.y, 10)..' maxdata.Z: '..RoundNumber(max.z, 10)
    -- if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") or GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
        if RoundNumber(min.x, 5) ~= -0.60952 or RoundNumber(min.y, 10) ~= -0.2500000298 or RoundNumber(min.z, 10) ~= -1.2999999523 or RoundNumber(max.x, 10) ~= 0.60998106 or RoundNumber(max.y, 10) ~= 0.2500000298 or RoundNumber(max.z, 10) ~= 0.9449999928 then
        end
    -- end
end
