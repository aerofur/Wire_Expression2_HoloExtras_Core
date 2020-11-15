E2Lib.RegisterExtension( 'ts_holoextras', false, "Adds extra functionality to E2s Hologram Core." )

local function checkOwner(self)
	return IsValid(self.player)
end

local E2HoloRepo = {}
local PlayerAmount = {}
local BlockList = {}
local scale_queue = {}
local bone_scale_queue = {}
local clip_queue = {}
local vis_queue = {}
local player_color_queue = {}

-- call to remove all queued items for a specific hologram
local function remove_from_queues( holo_ent )
	local function remove_from_queue( queue )
		for _, plyqueue in pairs( queue ) do
			for i=#plyqueue,1,-1 do -- iterate backwards to allow removing
				local Holo = plyqueue[i][1] -- the hologram is always at idx 1
				if Holo.ent == holo_ent then
					table.remove( plyqueue, i ) -- remove it from the queue
				end
			end
		end
	end

	remove_from_queue( scale_queue )
	remove_from_queue( bone_scale_queue )
	remove_from_queue( clip_queue )
	remove_from_queue( vis_queue )
	remove_from_queue( player_color_queue )
end

local function remove_holo( Holo )
	if IsValid(Holo.ent) then
		remove_from_queues( Holo.ent )
		Holo.ent:Remove()
	end
end

-- Removes the holograms from a given entity.
local function clearEntityHolos(self,this)
    for index,Holo in pairs(self.data.holos) do
        if Holo ~= nil then
            if Holo.ent:GetParent() == this then
                remove_holo(Holo)
            end
        end
    end
end

-- This will remove all the holos, even if you dont own the holos. Use this very sparingly.
local function clearEntityHolosRecursive(self,this)
    for index,Holo in pairs(self.data.holos) do
        if Holo ~= nil then
            if Holo.ent:GetParent() == this then
                remove_holo(Holo)
            end
        end
    end
end

local function clearEntityHolo(self,this,index)
    local Holo = self.data.holos[index]
    if Holo ~= nil then
        if Holo.ent:GetParent() == this then
            remove_holo(Holo)
        end
    end
end

e2function number entity:holoDeleteAll()
    if not IsValid(this) then return end
    if not checkOwner(self) then return end
    if BlockList[self.player:SteamID()] == true then return end
    clearEntityHolos(self,this)
end

e2function number entity:holoDeleteAllRecursive()
    if not IsValid(this) then return end
    if not checkOwner(self) then return end
    if BlockList[self.player:SteamID()] == true then return end
    clearEntityHolosRecursive(self,this)
end

e2function number entity:holoDelete(index)
    if not IsValid(this) then return end
    if not checkOwner(self) then return end
    if BlockList[self.player:SteamID()] == true then return end
    clearEntityHolo(self,this,index)
end

__e2setcost(30)
