---------- Buff/nerf existing trains/belts ----------
local beltSpeedMultiplier = 0.25
local beltLikeGroups = {'transport-belt', 'underground-belt', 'splitter'}
for _, groupName in ipairs(beltLikeGroups) do
    for _, entityKind in pairs(data.raw[groupName]) do
        entityKind.speed = entityKind.speed * beltSpeedMultiplier
    end
end

local locomotive = data.raw['locomotive']['locomotive']
locomotive.braking_force = 2*locomotive.braking_force
locomotive.max_power = '2400kW'
locomotive.max_speed = 4 * data.raw['locomotive']['locomotive'].max_speed

local trainCargoMultiplier = 0.25
local cargoWagon = data.raw['cargo-wagon']['cargo-wagon']
local fluidWagon = data.raw['fluid-wagon']['fluid-wagon']
cargoWagon.inventory_size = cargoWagon.inventory_size * trainCargoMultiplier
fluidWagon.capacity = fluidWagon.capacity * trainCargoMultiplier


---------- Adjust recipes to remove the dependence on steel and encourage early trains ----------

local recipe = data.raw.recipe
recipe['locomotive'].ingredients = {
    {'electronic-circuit', 10},
    {'iron-plate', 40},
    {'iron-gear-wheel', 10},
    {'iron-stick', 5},
    {'pipe', 10},
}
recipe['cargo-wagon'].ingredients = {
    {'iron-plate', 20},
    {'iron-gear-wheel', 15},
    {'iron-stick', 5},
}
recipe['rail'].ingredients = {
    {'stone', 2},
    {'iron-stick', 2},
}
recipe['train-stop'].ingredients = {
    {'iron-plate', 5},
    {'iron-stick', 5},
    {'electronic-circuit', 5},
    {'small-lamp', 3}
}
recipe['small-lamp'].ingredients = {
    {'copper-plate', 1},
    {'iron-stick', 1},
    {'electronic-circuit', 1},
}
recipe['rail-signal'].ingredients = {
    {'small-lamp', 3},
    {'electronic-circuit', 1},
    {'iron-plate', 1},
}
recipe['rail-chain-signal'].ingredients = {
    {'small-lamp', 3},
    {'electronic-circuit', 1},
    {'iron-plate', 1},
}
-- Discourage over-use of inserters.
for _,ingredient in pairs(recipe['fast-inserter'].ingredients) do
    ingredient[2] = 2 * ingredient[2]
end

-- Encourage things to be automated by increasing crafting time
local railwayCraftingMultiplier = 4
local trainLikeRecipes = {'locomotive', 'cargo-wagon', 'rail', 'train-stop', 'small-lamp', 'rail-signal', 'rail-chain-signal'}
for _, name in ipairs(trainLikeRecipes) do
    if not recipe[name]['energy_required'] then
        recipe[name].energy_required = .5
    end
    recipe[name].energy_required = recipe[name].energy_required * railwayCraftingMultiplier
end

---------- Allow cheap researching automated trains without further dependency ----------

local technology = data.raw['technology']
technology['railway'].prerequisites = {}  --'basic-electronics'
technology['automated-rail-transportation'].prerequisites = {'railway', 'optics'}
for _,techName in ipairs({'railway','automated-rail-transportation','rail-signals', 'optics'}) do 
    technology[techName].unit.count = 1
    technology[techName].unit.ingredients = {{"automation-science-pack", 1}}
end

-- ---------- Define new entities ----------

-- -- Register new entities
-- data:extend({
--     protomotive,
-- })