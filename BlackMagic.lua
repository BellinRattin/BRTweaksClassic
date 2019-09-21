local AddonName, Addon = ...

Addon.Frames = {}

Addon.Functions = {}

Addon.Data = {}

Addon.Events = CreateFrame("Frame")
Addon.Events:SetScript("OnEvent", function(self, event, ...)
	if not self[event] then
		return
	end
	self[event](self, ...)
end)