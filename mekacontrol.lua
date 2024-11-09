-- CREDITS TO: ShaeTsuPog
-- https://github.com/ShaeTsuPog/MekaControl/blob/main/mekacontrol.lua

-- trimmed by: wojtakbar ^-^

local rla = peripheral.find("fissionReactorLogicAdapter")
local boi = peripheral.find("boilerValve")
local trb = peripheral.find("turbineValve")
local ind = peripheral.find("inductionPort")
local mon = peripheral.find("monitor")
local scramCount = 0

local function regulator()
    local coolant = math.ceil(rla.getCoolantFilledPercentage() * 100)
    local heated = math.ceil(rla.getHeatedCoolantFilledPercentage() * 100)
    local waste = math.ceil(rla.getWasteFilledPercentage() * 100)
    local damage = rla.getDamagePercent()
    local energy = math.ceil(ind.getEnergyFilledPercentage() * 100)

    local status = rla.getStatus() and "Online" or "Offline"

    if coolant > 70 and heated < 70 and waste < 70 and damage < 1 and energy < 90 and status == "false"
    then
        rla.activate()
        print("ACTIVATED | INFO: " .. "C:" .. string.format("%3.0f", coolant) .. "%",
            "H:" .. string.format("%3.0f", heated) .. "%", "W:" .. string.format("%3.0f", waste) .. "%",
            "E:" .. string.format("%3.0f", energy) .. "%")
    elseif status == "true" and (coolant <= 70 or heated >= 70 or waste >= 70 or damage >= 1 or energy >= 90)
    then
        rla.scram()
        print("SCRAMMED | INFO: " .. "C:" .. string.format("%3.0f", coolant) .. "%",
            "H:" .. string.format("%3.0f", heated) .. "%", "W:" .. string.format("%3.0f", waste) .. "%",
            "E:" .. string.format("%3.0f", energy) .. "%")
        scramCount = scramCount + 1
    end
end

local function info()
    local fuel = math.ceil(rla.getFuelFilledPercentage() * 100)
    local coolant = math.ceil(rla.getCoolantFilledPercentage() * 100)
    local heated = math.ceil(rla.getHeatedCoolantFilledPercentage() * 100)
    local waste = math.ceil(rla.getWasteFilledPercentage() * 100)
    local steam = math.ceil(trb.getSteamFilledPercentage() * 100)
    local bheated = math.ceil(boi.getHeatedCoolantFilledPercentage() * 100)
    local bcoolant = math.ceil(boi.getCooledCoolantFilledPercentage() * 100)
    local bwater = math.ceil(boi.getWaterFilledPercentage() * 100)
    local bsteam = math.ceil(boi.getSteamFilledPercentage() * 100)

    local status = rla.getStatus() and "Online" or "Offline"

    local function formatEnergy(energy, feByT)
        local localEnergyDisplay = string.format("%.2f", energy)
        if energy < 1000 then
            localEnergyDisplay = energy .. (feByT and " FE/t" or " FE")
        else if energy > 1000 then
            localEnergyDisplay = string.format("%.2f", energy / 1000) .. (feByT and " kFE/t" or " kFE")
        else if energy > 1e6 then
            localEnergyDisplay = string.format("%.2f", energy / 1e6) .. (feByT and " MFE/t" or " MFE")
        else if energy > 1e9 then
            localEnergyDisplay = string.format("%.2f", energy / 1e9) .. (feByT and " GFE/t" or " GFE")
        else if energy > 1e12 then
            localEnergyDisplay = string.format("%.2f", energy / 1e12) .. (feByT and " TFE/t" or " TFE")
        else if energy > 1e15 then
            localEnergyDisplay = string.format("%.2f", energy / 1e15) .. (feByT and " PFE/t" or " PFE")
        end
        return localEnergyDisplay
    end


    local production = mekanismEnergyHelper.joulesToFE(trb.getProductionRate())
    local prodDisp = formatEnergy(production, true)

    local input = mekanismEnergyHelper.joulesToFE(ind.getLastInput())
    local inputDisp = formatEnergy(input, true)


    local output = mekanismEnergyHelper.joulesToFE(ind.getLastOutput())
    local outputDisp = formatEnergy(output, true)

    local energy = mekanismEnergyHelper.joulesToFE(ind.getEnergy())
    local energyDisp = formatEnergy(energy, false)

    local maxEnergy = mekanismEnergyHelper.joulesToFE(ind.getMaxEnergy())
    local maxEnergyDisp = formatEnergy(maxEnergy, false)

    local epercent = math.ceil(ind.getEnergyFilledPercentage() * 100)

    mon.clear()
    mon.setCursorPos(1,1) mon.setTextColor(16) mon.write("Fission Reactor")
    mon.setCursorPos(1,2) mon.setTextColor(512) mon.write("Status: ") mon.setTextColor(1) mon.write(status)
    mon.setCursorPos(1,3) mon.setTextColor(32) mon.write("Fuel: ") mon.setTextColor(1) mon.write(fuel .. "%")
    mon.setCursorPos(1,4) mon.setTextColor(2048) mon.write("Coolant: ") mon.setTextColor(1) mon.write(coolant .. "%")
    mon.setCursorPos(1,5) mon.setTextColor(4) mon.write("Heated: ") mon.setTextColor(1) mon.write(heated .. "%")
    mon.setCursorPos(1,6) mon.setTextColor(4096) mon.write("Waste: ") mon.setTextColor(1) mon.write(waste .. "%")

    mon.setCursorPos(1,8) mon.setTextColor(16) mon.write("Thermoelectric Boiler")
    mon.setCursorPos(1,9) mon.setTextColor(4) mon.write("Heated: ") mon.setTextColor(1) mon.write(bheated .. "%")
    mon.setCursorPos(1,10) mon.setTextColor(2048) mon.write("Cooled: ") mon.setTextColor(1) mon.write(bcoolant .. "%")
    mon.setCursorPos(1,11) mon.setTextColor(8) mon.write("Water: ") mon.setTextColor(1) mon.write(bwater .. "%")
    mon.setCursorPos(1,12) mon.setTextColor(256) mon.write("Steam: ") mon.setTextColor(1) mon.write(bsteam .. "%")

    mon.setCursorPos(1,14) mon.setTextColor(16) mon.write("Industrial Turbine")
    mon.setCursorPos(1,15) mon.setTextColor(8192) mon.write("Production: ") mon.setTextColor(1) mon.write(prodDisp)
    mon.setCursorPos(1,16) mon.setTextColor(256) mon.write("Steam: ") mon.setTextColor(1) mon.write(steam .. "%")

    mon.setCursorPos(1,18) mon.setTextColor(16) mon.write("Induction Matrix")
    mon.setCursorPos(1,19) mon.setTextColor(8192) mon.write("Input: ") mon.setTextColor(1) mon.write(inputDisp)
    mon.setCursorPos(1,20) mon.setTextColor(8192) mon.write("Output: ") mon.setTextColor(1) mon.write(outputDisp)
    mon.setCursorPos(1,21) mon.setTextColor(8192) mon.write("Energy: ") mon.setTextColor(1) mon.write(energyDisp .. "/" .. maxEnergyDisp)
    mon.setCursorPos(1,22) mon.setTextColor(8192) mon.write("Filled: ") mon.setTextColor(1) mon.write(epercent .. "%")

    mon.setCursorPos(1,24) mon.setTextColor(16384) mon.write("SCRAM COUNT: ") mon.write(string.format("%3.0f", scramCount))
end

while true do
    regulator()
    info()
end
