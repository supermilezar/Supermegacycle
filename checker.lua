totalFarmScanned = 0
Total_Nuked = 0
totalFossil = 0
nuked = false

emot_safe = "<a:online2:1174926338164002818:>"
emot_nuked = "<a:OFFLINE:1142826338307280997:>"
emot_toxic = "<:toxic:1156965113883017277>"
emot_tready = "<:Excellent:964672053624078407:>"
emot_nready = "<:Verypoor:964672269911748689:>"
emot_api = "<:fire:>"
emot_fossil = "<:Fossil:1156652797752791110:>"

local function countScannedFarm()
    local totalScanned = 0
    for _, _ in pairs(DENZ.FarmList) do
        totalScanned = totalScanned + 1
    end
    return totalScanned
end

function warp(world)
    local negro = 0
    while getBot():getWorld().name:upper() ~= world:upper() and not nuked do
        getBot():sendPacket(3,"action|join_request\nname|"..world:upper().."\ninvitedWorld|0")
        sleep(DENZ.DelayWArp)
        if negro == 5 then
            nuked = true
        else
            negro = negro + 1
        end
    end
end
local function log(text) 
    if DENZ.Input_Txt then
        file = io.open("WORLD STATUS.txt", "a")
        file:write(text.."\n")
        file:close()
    end
end
local function scanFossil()
    local count = 0
    for index,fosil in pairs(getBot():getWorld():getTiles()) do
        if fosil.fg == 3918 then
            count = count + 1
            sleep(1)
        end
    end
    return count
end
local function scanFire()
    local count = 0
    for index,fire in pairs(getBot():getWorld():getTiles()) do
        if fire.fg == 14256 then
            count = count + 1
            sleep(1)
        end
    end
    return count
end
local function scanToxic()
    local count = 0
    for index,toxic in pairs(getBot():getWorld():getTiles()) do
        if toxic.fg == 778 then
            count = count + 1
            sleep(1)
        end
    end
    return count
end
local function scanReady(id)
    local count = 0
    for index,tile in pairs(getBot():getWorld():getTiles()) do
        if tile.fg == id and tile:canHarvest(tile.x,tile.y) then
            count = count + 1
            sleep(1)
        end
    end
    return count
end
local function UnReady(id)
    local count = 0
    for index,tile in pairs(getBot():getWorld():getTiles()) do
        if tile.fg == id and not tile:canHarvest(tile.x,tile.y) then
            count = count + 1
            sleep(1)
        end
    end
    return count
end
local function infokan(description)
    if DENZ.Input_Webhook then
        local script = [[
            $webHookUrl = "]]..DENZ.Webhook..[["
            $content = @{
                "embeds": [{
                    "title": "Information",
                    "description": "]]..description..[[",
                    "color": 16711680
                }]
            }
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Invoke-RestMethod -Uri $webHookUrl -Body ($content | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'
        ]]
        local pipe = io.popen("powershell -command -", "w")
        pipe:write(script)
        pipe:close()
    end
end

log("-----------------------------------------------")
while true do
    for index,farm in pairs(DENZ.FarmList) do
        warp(farm)
        if not nuked then
            treek = scanReady(DENZ.Tree)
            sleep(math.ceil(DENZ.DelayAfk / 3))
            treeks = UnReady(DENZ.Tree)
            sleep(math.ceil(DENZ.DelayAfk / 3))
            posil = scanFossil()
            sleep(math.ceil(DENZ.DelayAfk / 3))
            toxic = scanToxic()
            sleep(math.ceil(DENZ.DelayAfk / 3))
            fire = scanFire()
            sleep(math.ceil(DENZ.DelayAfk / 3))
            if posil > 0 then
                totalFossil = totalFossil + posil
            end
            infokan("# Check farm DEENZ")
            log("Farm ".. farm .. " scanned")
            log(farm:upper().." <a:online2:1174926338164002818>SAFE | ".."[**"..treek.."**] <:Excellent:964672053624078407>Ready [**"..treeks.."**] <:Verypoor:964672269911748689>unReady  | [**"..posil.."**] <:FossilRock:1156652797752791110>Fossil[**"..toxic.."**] <:toxic:1156965113883017277>Toxic  [**"..fire.."**] Api")
            infokan(farm:upper().." <a:online2:1174926338164002818>SAFE | ".."[**"..treek.."**] <:Excellent:964672053624078407>Ready [**"..treeks.."**] <:Verypoor:964672269911748689>unReady  | [**"..posil.."**] <:FossilRock:1156652797752791110>Fossil[**"..toxic.."**] <:toxic:1156965113883017277>Toxic  [**"..fire.."**] Api")
            sleep(100)
        else
            log(farm:upper().."** |  <:gtNuke:975725039490064384>NUKED**")
            infokan(farm:upper().."** |  <:gtNuke:975725039490064384>NUKED**")
            sleep(100)
            nuked = false
            Total_Nuked = Total_Nuked + 1
            local totalScanned = countScannedFarm()
        end
    end
    if not DENZ.Loop then
        infokan("**Total Nuked [**"..Total_Nuked.."**] World**")
        log("Total Nuked "..Total_Nuked.." World\n")
        infokan("**Total Fossil ["..totalFossil.."]**")
        log("Total Nuked "..TotalFossil.." World\n")
        infokan("**Total World ["..totalScanned.."]**")
        log("Total World "..totalScanned.." World\n")
        break
    end
end
