Config = {}

-- Densidades | Densities
Config.DensityMultiplier = 0.25
Config.DensityParkedMultiplier = 0.10
Config.SuperCarDensity = 0.30 -- Ajusta esta densidad para los coches superdeportivos | Adjust this density for super sports cars

-- Modelos de superdeportivos | Supercar models
Config.SuperCars = {
    "adder",
    "t20"
}

-- Modelo de NPC |  NPC Model
Config.NpcModel = "a_m_y_business_01"

-- Zonas donde los coches pueden aparecer (coordenadas y radio) | Areas where cars can appear (coordinates and radius)
Config.SpawnZones = {
    {x = 215.0, y = -810.0, z = 30.0, radius = 300.0}, -- Ejemplo de zona permitida
    {x = -500.0, y = 500.0, z = 30.0, radius = 200.0}  -- Otro ejemplo
}

-- Zonas donde los coches no pueden aparecer (coordenadas y radio) | Areas where cars cannot appear (coordinates and radius)
Config.BlacklistZones = {
    {x = 425.0, y = -980.0, z = 30.0, radius = 100.0}, -- Ejemplo de zona de blacklist
    {x = -1000.0, y = 1000.0, z = 30.0, radius = 150.0} -- Otro ejemplo
}
