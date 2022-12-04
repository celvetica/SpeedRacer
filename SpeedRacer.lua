local ADDON_NAME, SpeedRacer = ...

local LSM = LibStub("LibSharedMedia-3.0", true);

print("SpeedRacer is here!");

-- "GO!" "Bronze Timekeeper"
-- AREA_POIS_UPDATED


SLASH_SPEEDRACER01 = "/speedracer"
SLASH_SPEEDRACER02 = "/sr"

SlashCmdList["SPEEDRACER"] = function (msg)
    print("SpeedRacer");
end

SpeedRacer.Races = {
    [66786] = "Wingrest Roundabout",
    [66787] = "Wingrest Roundabout - Advanced",
    [66877] = "Fen Flythrough",
    [66878] = "Fen Flythrough - Advanced",
}
-- SpeedRacer.Races[66787] = "Wingrest Roundabout - Advanced";
-- SpeedRacer.Races[66786] = "Wingrest Roundabout";

--[[
function SpeedRacer:CHAT_MSG_SYSTEM(event, msg)
    if msg == "Quest accepted: Wingrest Roundabout - Advanced" then
        print("Start Wingrest Roundabout");
    end
end
--]]

function SpeedRacer:QUEST_ACCEPTED(msg, id)
    print("QUEST_ACCEPTED:", id);

    if SpeedRacer.Races[id] then
        print("Started", SpeedRacer.Races[id]);
    end
    --if id == 66787 then
    --    print("Started WingrestRoundabout - Advanced");
    --end
end

function SpeedRacer:QUEST_REMOVED(msg, id)
    print("QUEST_REMOVED", id);
    if SpeedRacer.Races[id] then
        print("Ended ", SpeedRacer.Races[id]);
    end

    -- until string match is fixed:
    self.Racing = false;
end

function SpeedRacer:CHAT_MSG_MONSTER_SAY(event, msg, sender)
    if sender ~= "Bronze Timekeeper" then
        return
    end

    if msg == "GO!" then
        self.Racing = true;
        print("Start!");
        self.Time = GetTime();
        self.CheckPoints = 0;
        self.CheckPointTimes = {};
    else
        print("msg: ", msg);
        -- local time = string.match(msg, 'Your race time was ([0-9.]*) seconds.*')
        local time, time2 = string.match(msg, 'Your race time was ([0-9.]*) seconds. Your personal best for this race is ([0-9.]*) seconds.');
        if time then
            print("Race Time: ", time);
            print("Personal Best: ", time2);
            self.Racing = false;
        else
            local time = string.match(msg, 'Your race time was ([0-9.]*) seconds. That was your best time yet!');
            print("Race Time: ", time);
            print("New Best!");
            self.Racing = false;
        end
    end
end

function SpeedRacer:AREA_POIS_UPDATED(event)
    if not self.Racing then
        return;
    end

    self.CheckPoints = self.CheckPoints + 1;
    self.CheckPointTimes[self.CheckPoints] = GetTime() - self.Time;
    print("Checkpoint #", self.CheckPoints, self.CheckPointTimes[self.CheckPoints]);
end

function SpeedRacer:Init()
    SpeedRacer.Frame = CreateFrame("Frame", "SpeedRacerMain", UIParent);
    SpeedRacer.Frame:RegisterEvent("CHAT_MSG_MONSTER_SAY");
    -- SpeedRacer.Frame:RegisterEvent("CHAT_MSG_SYSTEM");
    SpeedRacer.Frame:RegisterEvent("QUEST_ACCEPTED");
    SpeedRacer.Frame:RegisterEvent("QUEST_REMOVED");
    SpeedRacer.Frame:RegisterEvent("AREA_POIS_UPDATED");

    SpeedRacer.Frame:SetScript("OnEvent", function(self, event, ...)
        SpeedRacer[event](SpeedRacer, event, ...);
    end)

    SpeedRacer.Racing = false;
    -- SpeedRacer.Time = 0;
    -- SpeedRacer.Checkpoints = 0;
    -- SpeedRacer.CheckpointTimes = {};
end

SpeedRacer:Init();