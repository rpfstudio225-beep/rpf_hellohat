------------------------ hat


local dict = 'mech_loco_m@character@arthur@fidgets@hat@normal@unarmed@normal@left_hand'
local anim = 'hat_lhand_b'
local enabled = false
local speed = 4.0
local control = `INPUT_SWITCH_SHOULDER` ---- B for handsup and B egain for lowver Hands

RegisterNetEvent('handsup:toggle')

function IsUsingKeyboard(padIndex)
    return Citizen.InvokeNative(0xA571D46727E2B718, padIndex)
end

function SwitchToUnarmed()
    GiveWeaponToPed_2(PlayerPedId(), `WEAPON_UNARMED`, 0, true, false, 0, false, 0.5, 1.0, 0, false, 0.0, false)
end

function RaiseHands()
    TaskPlayAnim(PlayerPedId(), dict, anim, speed, speed, -1, 25, 0, false, false, false, '', false)
end

function LowerHands()
    StopAnimTask(PlayerPedId(), dict, anim, speed)
end

function ToggleRaiseHands()
    enabled = not enabled

    if not enabled then
        LowerHands()
    end
end

RegisterCommand('hellohat', function(source, args, raw)
    ToggleRaiseHands()
end, false)

AddEventHandler('handsup:toggle', ToggleRaiseHands)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        enabled = false
        LowerHands()
    end
end)

Citizen.CreateThread(function()
    while true do
            if IsControlJustReleased(0, 0x8CC9CD42) then
            ToggleRaiseHands()
            Wait(2000)
            ToggleRaiseHands()
            end
        Citizen.Wait(0)
    end
end)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/handsup', 'Raise/lower your hands', {})

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

    while true do
        Wait(0)

        if enabled then
            DisableControlAction(0, `INPUT_ATTACK`, true)
            DisableControlAction(0, `INPUT_MELEE_ATTACK`, true)
            DisableControlAction(0, `INPUT_MELEE_GRAPPLE_CHOKE`, true)
            DisableControlAction(0, `INPUT_MELEE_GRAPPLE`, true)

            SwitchToUnarmed()

            if not IsEntityPlayingAnim(PlayerPedId(), dict, anim, 25) then
                RaiseHands()
            end
        end
    end
end)


----------