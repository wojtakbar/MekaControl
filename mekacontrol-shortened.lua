-- CREDITS TO: ShaeTsuPog, shortened by: wojtakbar ^-^
local rla, boi, trb, ind, mon = peripheral.find("fissionReactorLogicAdapter"), peripheral.find("boilerValve"), peripheral.find("turbineValve"), peripheral.find("inductionPort"), peripheral.find("monitor")
local scramCount = 0
local function regulator()
    local coolant, heated, waste, damage, energy, status = math.ceil((rla.getCoolantFilledPercentage() or 0) * 100), math.ceil((rla.getHeatedCoolantFilledPercentage() or 0) * 100), math.ceil((rla.getWasteFilledPercentage() or 0) * 100), rla.getDamagePercent(), math.ceil((ind.getEnergyFilledPercentage() or 0) * 100), rla.getStatus() and "Online" or "Offline"
    local function renderStatus(coolant, heated, waste, energy) print("ACTIVATED | INFO: " .. "C:" .. string.format("%3.0f", coolant) .. "%", "H:" .. string.format("%3.0f", heated) .. "%", "W:" .. string.format("%3.0f", waste) .. "%", "E:" .. string.format("%3.0f", energy) .. "%") end
    if coolant > 70 and heated < 70 and waste < 70 and damage < 1 and energy < 90 and status == "false" then rla.activate();renderStatus(coolant, heated, waste, energy)
    elseif status == "true" and (coolant <= 70 or heated >= 70 or waste >= 70 or damage >= 1 or energy >= 90) then rla.scram();renderStatus(coolant, heated, waste, energy);scramCount = scramCount + 1 end
end
local function info()
    local fuel, coolant, heated, waste, steam, bheated, bcoolant, bwater, bsteam, status = math.ceil(rla.getFuelFilledPercentage() * 100), math.ceil(rla.getCoolantFilledPercentage() * 100), math.ceil(rla.getHeatedCoolantFilledPercentage() * 100), math.ceil(rla.getWasteFilledPercentage() * 100), math.ceil(trb.getSteamFilledPercentage() * 100), math.ceil(boi.getHeatedCoolantFilledPercentage() * 100), math.ceil(boi.getCooledCoolantFilledPercentage() * 100), math.ceil(boi.getWaterFilledPercentage() * 100), math.ceil(boi.getSteamFilledPercentage() * 100), rla.getStatus() and "Online" or "Offline"
    local function formatEnergy(energy, feByT)
        local localEnergyDisplay = string.format("%.2f", energy)
        if energy < 1000 then localEnergyDisplay = energy .. (feByT and " FE/t" or " FE")
        elseif energy > 1000 and energy < 1e6 then localEnergyDisplay = string.format("%.2f", energy / 1000) .. (feByT and " kFE/t" or " kFE")
        elseif energy > 1e6 and energy < 1e9 then localEnergyDisplay = string.format("%.2f", energy / 1e6) .. (feByT and " MFE/t" or " MFE")
        elseif energy > 1e9 and energy < 1e12 then localEnergyDisplay = string.format("%.2f", energy / 1e9) .. (feByT and " GFE/t" or " GFE")
        elseif energy > 1e12 and energy < 1e15 then localEnergyDisplay = string.format("%.2f", energy / 1e12) .. (feByT and " TFE/t" or " TFE")
        elseif energy > 1e15 then localEnergyDisplay = string.format("%.2f", energy / 1e15) .. (feByT and " PFE/t" or " PFE") end
        return localEnergyDisplay
    end
    local prodDisp, inputDisp, outputDisp, energyDisp, maxEnergyDisp, epercentDisp = formatEnergy(mekanismEnergyHelper.joulesToFE(trb.getProductionRate()), true), formatEnergy(mekanismEnergyHelper.joulesToFE(ind.getLastInput()), true), formatEnergy(mekanismEnergyHelper.joulesToFE(ind.getLastOutput()), true), formatEnergy(mekanismEnergyHelper.joulesToFE(ind.getEnergy()), false), formatEnergy(mekanismEnergyHelper.joulesToFE(ind.getMaxEnergy()), false), math.ceil(ind.getEnergyFilledPercentage() * 100)
    mon.clear()
    mon.setCursorPos(1,1) mon.setTextColor(16) mon.write("Fission Reactor");mon.setCursorPos(1,2) mon.setTextColor(512) mon.write("Status: ") mon.setTextColor(1) mon.write(status);mon.setCursorPos(1,3) mon.setTextColor(32) mon.write("Fuel: ") mon.setTextColor(1) mon.write(fuel .. "%");mon.setCursorPos(1,4) mon.setTextColor(2048) mon.write("Coolant: ") mon.setTextColor(1) mon.write(coolant .. "%");mon.setCursorPos(1,5) mon.setTextColor(4) mon.write("Heated: ") mon.setTextColor(1) mon.write(heated .. "%");mon.setCursorPos(1,6) mon.setTextColor(4096) mon.write("Waste: ") mon.setTextColor(1) mon.write(waste .. "%")
    mon.setCursorPos(1,8) mon.setTextColor(16) mon.write("Thermoelectric Boiler");mon.setCursorPos(1,9) mon.setTextColor(4) mon.write("Heated: ") mon.setTextColor(1) mon.write(bheated .. "%");mon.setCursorPos(1,10) mon.setTextColor(2048) mon.write("Cooled: ") mon.setTextColor(1) mon.write(bcoolant .. "%");mon.setCursorPos(1,11) mon.setTextColor(8) mon.write("Water: ") mon.setTextColor(1) mon.write(bwater .. "%");mon.setCursorPos(1,12) mon.setTextColor(256) mon.write("Steam: ") mon.setTextColor(1) mon.write(bsteam .. "%")
    mon.setCursorPos(1,14) mon.setTextColor(16) mon.write("Industrial Turbine");mon.setCursorPos(1,15) mon.setTextColor(8192) mon.write("Production: ") mon.setTextColor(1) mon.write(prodDisp);mon.setCursorPos(1,16) mon.setTextColor(256) mon.write("Steam: ") mon.setTextColor(1) mon.write(steam .. "%")
    mon.setCursorPos(1,18) mon.setTextColor(16) mon.write("Induction Matrix");mon.setCursorPos(1,19) mon.setTextColor(8192) mon.write("Input: ") mon.setTextColor(1) mon.write(inputDisp);mon.setCursorPos(1,20) mon.setTextColor(8192) mon.write("Output: ") mon.setTextColor(1) mon.write(outputDisp);mon.setCursorPos(1,21) mon.setTextColor(8192) mon.write("Energy: ") mon.setTextColor(1) mon.write(energyDisp .. "/" .. maxEnergyDisp);mon.setCursorPos(1,22) mon.setTextColor(8192) mon.write("Filled: ") mon.setTextColor(1) mon.write(epercentDisp .. "%")
    mon.setCursorPos(1,24) mon.setTextColor(16384) mon.write("SCRAM COUNT: ") mon.write(string.format("%3.0f", scramCount))
end
while true do regulator();info() end
