local math_random = math.random
local table_insert = table.insert

local worm_raffle_table = {
		[1] = {"small-worm-turret", "small-worm-turret", "small-worm-turret", "small-worm-turret", "small-worm-turret", "small-worm-turret"},
		[2] = {"small-worm-turret", "small-worm-turret", "small-worm-turret", "small-worm-turret", "small-worm-turret", "medium-worm-turret"},
		[3] = {"small-worm-turret", "small-worm-turret", "small-worm-turret", "small-worm-turret", "medium-worm-turret", "medium-worm-turret"},
		[4] = {"small-worm-turret", "small-worm-turret", "small-worm-turret", "medium-worm-turret", "medium-worm-turret", "medium-worm-turret"},
		[5] = {"small-worm-turret", "small-worm-turret", "medium-worm-turret", "medium-worm-turret", "medium-worm-turret", "big-worm-turret"},
		[6] = {"small-worm-turret", "medium-worm-turret", "medium-worm-turret", "medium-worm-turret", "medium-worm-turret", "big-worm-turret"},
		[7] = {"medium-worm-turret", "medium-worm-turret", "medium-worm-turret", "medium-worm-turret", "big-worm-turret", "big-worm-turret"},
		[8] = {"medium-worm-turret", "medium-worm-turret", "medium-worm-turret", "medium-worm-turret", "big-worm-turret", "big-worm-turret"},
		[9] = {"medium-worm-turret", "medium-worm-turret", "medium-worm-turret", "big-worm-turret", "big-worm-turret", "big-worm-turret"},
		[10] = {"medium-worm-turret", "medium-worm-turret", "medium-worm-turret", "big-worm-turret", "big-worm-turret", "big-worm-turret"}
	}

local function create_particles(surface, position, amount)					
	for i = 1, amount, 1 do 
		local m = math_random(8, 24)
		local m2 = m * 0.005
		
		surface.create_entity({
			name = "stone-particle",
			position = position,
			frame_speed = 0.1,
			vertical_speed = 0.1,
			height = 0.1,
			movement = {m2 - (math_random(0, m) * 0.01), m2 - (math_random(0, m) * 0.01)}
		})
	end	
end

local function spawn_worm(surface, position)
	local evolution = math.ceil(game.forces.enemy.evolution_factor * 10)
	local raffle = worm_raffle_table[evolution]
	local worm_name = raffle[math.random(1,#raffle)]
	surface.create_entity({name = worm_name, position = position})
end

local function unearthing_worm(surface, position)
	if not surface then return end
	if not position then return end
	if not position.x then return end
	if not position.y then return end
	
	for t = 1, 360, 1 do
		if not global.on_tick_schedule[game.tick + t] then global.on_tick_schedule[game.tick + t] = {} end
				
		global.on_tick_schedule[game.tick + t][#global.on_tick_schedule[game.tick + t] + 1] = {
			func = create_particles,
			args = {surface, position, math.ceil(t * 0.07)}
		}										
		
		if t == 360 then
			global.on_tick_schedule[game.tick + t][#global.on_tick_schedule[game.tick + t] + 1] = {
				func = spawn_worm,
				args = {surface, position}
			}
		end				
	end		
end

return unearthing_worm