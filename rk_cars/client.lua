local replacedVehicles = {} -- Tabla para almacenar vehículos ya reemplazados

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetVehicleDensityMultiplierThisFrame(Config.DensityMultiplier)
        SetRandomVehicleDensityMultiplierThisFrame(Config.DensityMultiplier)
        SetParkedVehicleDensityMultiplierThisFrame(Config.DensityParkedMultiplier)
        SetPedDensityMultiplierThisFrame(Config.DensityMultiplier)
        SetScenarioPedDensityMultiplierThisFrame(Config.DensityParkedMultiplier, Config.DensityParkedMultiplier)

        SetGarbageTrucks(false) -- Evita que los camiones de basura aparezcan aleatoriamente
        SetRandomBoats(false) -- Evita que barcos spawneen aleatoriamente
        SetCreateRandomCops(false) -- desactivar policías aleatorios que caminan o conducen.
        SetCreateRandomCopsNotOnScenarios(false) -- desactiva los sonidos de los coches policias y ambulacias aleatorios
        SetCreateRandomCopsOnScenarios(false) -- desactiva los sonidos de los coches policias y ambulacias aleatorios

        -- Asegura de que los modelos de vehículos y peds estan cargados
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
                -- Crear un ped y lo mete dentro del vehículo
                local ped = CreatePedInsideVehicle(newVeh, 4, GetHashKey(Config.NpcModel), -1, true, false)

                SetEntityAsMissionEntity(newVeh, true, true)
                SetEntityAsMissionEntity(ped, true, true)

                -- Elimina el vehículo original
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
