function CreateNamedRenderTargetForModel(name, model)
	local handle = 0
	if not IsNamedRendertargetRegistered(name) then
		RegisterNamedRendertarget(name, 0)
	end
	if not IsNamedRendertargetLinked(model) then
		LinkNamedRendertarget(model)
	end
	if IsNamedRendertargetRegistered(name) then
		handle = GetNamedRendertargetRenderId(name)
	end

	return handle
end

local modeltypes = {
"prop_tv_flat_01",
"prop_tv_flat_michael"
}

local status = false


Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		
		for k,v in pairs(modeltypes) do
			local coords = GetEntityCoords(GetPlayerPed(-1))
			tvmodel = GetClosestObjectOfType(coords, 3.75, GetHashKey(v), false)
			if DoesEntityExist(tvmodel) then 
				if GetDistanceBetweenCoords(coords, GetEntityCoords(tvmodel, true), true) < 3.15 and status == false then
					DisplayHelp("Press ~INPUT_CONTEXT~ to turn on the TV.")
						
					if IsControlJustPressed(1,46) and status == false then
						
						Citizen.Wait(0)
						local status = true
   						local model = GetHashKey(v)
   						local entity = GetClosestObjectOfType(coords, 20.0, model, 0, 0, 0)
   						local handle = CreateNamedRenderTargetForModel("tvscreen", model)

   						RegisterScriptWithAudio(0)
						SetTvChannel(-1)
						LoadTvChannelSequence(2, "PL_STD_CNT", 1) 
   						SetTvVolume(10)
						SetTvChannel(2)
						EnableMovieSubtitles(1)
						PlaySoundFrontend(-1, "MICHAEL_SOFA_TV_ON_MASTER", 0, 1)

						while status do
	   						SetTvAudioFrontend(0)
	   						AttachTvAudioToEntity(entity)
	   						SetTextRenderId(handle)
	   						Set_2dLayer(4)
	   						SetScriptGfxDrawBehindPausemenu(1)
		   					DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
	   		    			SetTextRenderId(GetDefaultScriptRendertargetRenderId())
							SetScriptGfxDrawBehindPausemenu(0)
							Citizen.Wait(0)
							DisplayHelp("Press ~INPUT_CONTEXT~ to turn off the TV.")
							

							if IsControlJustPressed(1,46) and status then
								SetTvChannel(0)  
								EnableMovieSubtitles(0)
								ReleaseAmbientAudioBank()
								status = false
							end
						end
					end
				end
			end	
		end
	end
end) 

function DisplayHelp(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end