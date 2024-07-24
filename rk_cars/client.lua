local replacedVehicles = {} -- Tabla para almacenar vehículos ya reemplazados

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetVehicleDensityMultiplierThisFrame(Config.DensityMultiplier)
        SetRandomVehicleDensityMultiplierThisFrame(Config.DensityMultiplier)
        SetParkedVehicleDensityMultiplierThisFrame(Config.DensityParkedMultiplier)
        SetPedDensityMultiplierThisFrame(Config.DensityMultiplier)
        SetScenarioPedDensityMultiplierThisFrame(Config.DensityParkedMultiplier, Config.DensityParkedMultiplier)

        SetGarbageTrucks(false) -- Stop garbage trucks from randomly spawning
        SetRandomBoats(false) -- Stop random boats from spawning in the water.
        SetCreateRandomCops(false) -- disable random cops walking/driving around.
        SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
        SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.

        -- Asegúrate de que los modelos de vehículos y peds estén cargados
        for _, model in ipairs(Config.SuperCars) do
            RequestModel(GetHashKey(model))
        end
        RequestModel(GetHashKey(Config.NpcModel))
        while not HasModelLoaded(GetHashKey(Config.SuperCars[1])) or not HasModelLoaded(GetHashKey(Config.SuperCars[2])) or not HasModelLoaded(GetHashKey(Config.NpcModel)) do
            Citizen.Wait(0)
        end

        -- Reemplazar vehículos aleatorios con superdeportivos basados en SuperCarDensity
        for veh in EnumerateVehicles() do
            if not replacedVehicles[veh] and math.random() < Config.SuperCarDensity then
                local pos = GetEntityCoords(veh)
                local heading = GetEntityHeading(veh)
                local newModel = Config.SuperCars[math.random(#Config.SuperCars)]

                -- Crear el vehículo superdeportivo
                local newVeh = CreateVehicle(GetHashKey(newModel), pos.x, pos.y, pos.z, heading, true, false)
                -- Crear un ped y ponerlo dentro del vehículo
                local ped = CreatePedInsideVehicle(newVeh, 4, GetHashKey(Config.NpcModel), -1, true, false)

                -- Hacer que el vehículo y el ped sean entidades de misión para evitar que sean reemplazados de nuevo
                SetEntityAsMissionEntity(newVeh, true, true)
                SetEntityAsMissionEntity(ped, true, true)

                -- Eliminar el vehículo original
                replacedVehicles[veh] = true
                DeleteVehicle(veh)

                SetEntityAsNoLongerNeeded(newVeh)
                SetPedAsNoLongerNeeded(ped)
            else
                replacedVehicles[veh] = true -- Marca el vehículo como revisado
            end
        end
    end
end)

-- Helper function to enumerate vehicles
function EnumerateVehicles()
    return coroutine.wrap(function()
        local handle, veh = FindFirstVehicle()
        if not veh then
            EndFindVehicle(handle)
            return
        end
        
        local enum = {handle = handle, vehicle = veh}
        local next = true

        repeat
            coroutine.yield(veh)
            next, veh = FindNextVehicle(handle)
        until not next

        EndFindVehicle(handle)
    end)
end
