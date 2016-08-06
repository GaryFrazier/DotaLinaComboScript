-- Sample adventure script

-- Create the class for the game mode, unused in this example as the functions for the quest are global
if CAddonAdvExGameMode == nil then
	CAddonAdvExGameMode = class({})
end


-- If something was being created via script such as a new npc, it would need to be precached here
function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end


-- Create the game mode class when we activate
function Activate()
	GameRules.AddonAdventure = CAddonAdvExGameMode()
	GameRules.AddonAdventure:InitGameMode()
    
    ListenToGameEvent("dota_player_pick_hero", OnHeroPicked, nil)
    InitializePlayers() 
end

function OnHeroPicked (event)
    local hero = EntIndexToHScript(event.heroindex)
    GiveItem(hero, "item_arcane_boots")
    GiveItem(hero, "item_blink")
    GiveItem(hero, "item_cyclone")
    GiveItem(hero, "item_ultimate_scepter")
    hero:AddExperience(99999, 0,false,false)
end

function GiveItem (hero, itemName)
    if hero:HasRoomForItem(itemName, true, true) then
       local item = CreateItem(itemName, hero, hero)
       item:SetPurchaseTime(0)
       hero:AddItem(item)
    end
 end

function InitializePlayers()
    local ursa = Entities:FindByName(nil, "targetUrsa")
    
    ursa:AddExperience(99999, 0,false,false)
    ursa:UpgradeAbility(ursa:GetAbilityByIndex(2))
    ursa:UpgradeAbility(ursa:GetAbilityByIndex(2))
    ursa:UpgradeAbility(ursa:GetAbilityByIndex(2))
    ursa:UpgradeAbility(ursa:GetAbilityByIndex(2))
    ursa:SetBaseStrength(50)
    
    GiveItem(ursa, "item_moon_shard")
    GiveItem(ursa, "item_moon_shard")
    GiveItem(ursa, "item_moon_shard")
    GiveItem(ursa, "item_rapier")
    GiveItem(ursa, "item_rapier")
    GiveItem(ursa, "item_rapier")
    
end

-- Begins processing script for the custom game mode.  This "template_example" contains a main OnThink function.
function CAddonAdvExGameMode:InitGameMode()
	print( "Adventure Example loaded." )
end


-- Quest entity that will contain the quest data so it can be referenced later
local entQuestKillBoss = nil


-- Call this function from Hammer to start the quest.  Checks to see if the entity has been created, if not, create the entity
-- See "adventure_example.vmap" for syntax on accessing functions
function QuestKillBoss()
	if entQuestKillBoss == nil then
		entQuestKillBoss = SpawnEntityFromTableSynchronous( "quest", { name = "KillBoss", title = "#quest_boss_kill" } )
	end
end


-- Call this function to end the quest.  References the previously created quest if it has been created, if not, should do nothing
function QuestKillBossComplete()
	if entQuestKillBoss ~= nil then
		entQuestKillBoss:CompleteQuest()
	end
end