local AddonName, Addon = ...

Addon.Frames = {}

Addon.Functions = {}

Addon.Events = CreateFrame("Frame")
Addon.Events:SetScript("OnEvent", function(self, event, ...)
	if not self[event] then
		return
	end
	self[event](self, ...)
end)

Addon.Data = {}

Addon.Data.IDS = {
	--hearthstone
	[6948] = "HEARTHSTONE",

	-- MOUNTS
	--horses
	[2411]  = "MOUNTS", [2414]  = "MOUNTS", [5655]  = "MOUNTS", [5656]  = "MOUNTS", [18778] = "MOUNTS", 
	[18776] = "MOUNTS", [18777] = "MOUNTS", [18241] = "MOUNTS", [12353] = "MOUNTS", [12354] = "MOUNTS",
	--kodos
	[15277] = "MOUNTS", [15290] = "MOUNTS", [18793] = "MOUNTS", [18794] = "MOUNTS", [18795] = "MOUNTS", 
	[18247] = "MOUNTS", [15292] = "MOUNTS", [15293] = "MOUNTS",
	-- mechanostriders
	[8563]  = "MOUNTS", [8595]  = "MOUNTS", [13321] = "MOUNTS", [13322] = "MOUNTS", [18772] = "MOUNTS", 
	[18773] = "MOUNTS", [18774] = "MOUNTS", [18243] = "MOUNTS", [13326] = "MOUNTS", [13327] = "MOUNTS",
	-- qiraji battle tanks
	[21218] = "MOUNTS", [21321] = "MOUNTS", [21323] = "MOUNTS", [21324] = "MOUNTS", [21176] = "MOUNTS",
	-- rams
	[5864]  = "MOUNTS", [5872]  = "MOUNTS", [5873]  = "MOUNTS", [18785] = "MOUNTS", [18786] = "MOUNTS", 
	[18787] = "MOUNTS", [18244] = "MOUNTS", [19030] = "MOUNTS", [13328] = "MOUNTS", [13329] = "MOUNTS",
	-- raptors
	[8588]  = "MOUNTS", [8591]  = "MOUNTS", [8592]  = "MOUNTS", [18788] = "MOUNTS", [18789] = "MOUNTS", 
	[18790] = "MOUNTS", [18246] = "MOUNTS", [19872] = "MOUNTS", [8586]  = "MOUNTS", [13317] = "MOUNTS",
	-- sabers
	[8629]  = "MOUNTS", [8631]  = "MOUNTS", [8632]  = "MOUNTS", [18766] = "MOUNTS", [18767] = "MOUNTS", 
	[18902] = "MOUNTS", [18242] = "MOUNTS", [13086] = "MOUNTS", [19902] = "MOUNTS", [12302] = "MOUNTS", 
	[12303] = "MOUNTS", [8628]  = "MOUNTS", [12326] = "MOUNTS",
	-- undead horses
	[13331] = "MOUNTS", [13332] = "MOUNTS", [13333] = "MOUNTS", [13334] = "MOUNTS", [18791] = "MOUNTS", 
	[18248] = "MOUNTS", [13335] = "MOUNTS",
	-- wolves
	[1132]  = "MOUNTS", [5665]  = "MOUNTS", [5668]  = "MOUNTS", [18796] = "MOUNTS", [18797] = "MOUNTS", 
	[18798] = "MOUNTS", [18245] = "MOUNTS", [12330] = "MOUNTS", [12351] = "MOUNTS",

	--KEYSs (not really)
	[9240] = "KEYS", [17191] = "KEYS", [13544] = "KEYS", [12324] = "KEYS", [16309] = "KEYS", 
	[12384] = "KEYS", [20402] = "KEYS",

	--profession TOOLSs
	[7005]  = "TOOLS", [12709] = "TOOLS", [19727] = "TOOLS", [5956]  = "TOOLS", [2901]  = "TOOLS", 
	[6219]  = "TOOLS", [10498] = "TOOLS", [6218]  = "TOOLS", [6339]  = "TOOLS", [11130] = "TOOLS", 
	[11145] = "TOOLS", [16207] = "TOOLS", [9149]  = "TOOLS", [15846] = "TOOLS", [6256]  = "TOOLS", 
	[6365]  = "TOOLS", [6367]  = "TOOLS",

	--enchanting RODSs, separated from TOOLS because can and should be held in enchanting bags
	[6218] = "RODS", [6339] = "RODS", [11130] = "RODS", [11145] = "RODS", [16207] = "RODS",

	--enchanting mats
	-- dust
	[10940] = "ENCH", [11083] = "ENCH", [11137] = "ENCH", [11176] = "ENCH", [16204] = "ENCH",
	-- essence
	[10938] = "ENCH", [10939] = "ENCH", [10998] = "ENCH", [11082] = "ENCH", [11134] = "ENCH", 
	[11135] = "ENCH", [11174] = "ENCH", [11175] = "ENCH", [16202] = "ENCH", [16203] = "ENCH",
	-- shard
	[10978] = "ENCH", [11084] = "ENCH", [11138] = "ENCH", [11139] = "ENCH", [11177] = "ENCH", 
	[11178] = "ENCH", [14343] = "ENCH", [14344] = "ENCH",
	-- crystal
	[20725] = "ENCH",

	-- herbs
	[765]   = "HERBS", [785]   = "HERBS", [2447]  = "HERBS", [2449]  = "HERBS", [2450]  = "HERBS", 
	[2452]  = "HERBS", [2453]  = "HERBS", [3355]  = "HERBS", [3356]  = "HERBS", [3357]  = "HERBS", 
	[3358]  = "HERBS", [3369]  = "HERBS", [3818]  = "HERBS", [3819]  = "HERBS", [3820]  = "HERBS", 
	[3821]  = "HERBS", [4625]  = "HERBS", [8153]  = "HERBS", [8831]  = "HERBS", [8836]  = "HERBS", 
	[8838]  = "HERBS", [8839]  = "HERBS", [8845]  = "HERBS", [8846]  = "HERBS", [13463] = "HERBS", 
	[13464] = "HERBS", [13465] = "HERBS", [13466] = "HERBS", [13467] = "HERBS", [13468] = "HERBS",
	-- seeds
	[17034] = "SEEDS", [17035] = "SEEDS", [17036] = "SEEDS", [17037] = "SEEDS", [17038] = "SEEDS",
	--arrows
	[2512]  = "ARROWS", [2515]  = "ARROWS", [3030]  = "ARROWS", [3464]  = "ARROWS", [9399] = "ARROWS", 
	[11285] = "ARROWS", [12654] = "ARROWS", [18042] = "ARROWS", [19316] = "ARROWS",
	-- bullets
	[2516]  = "BULLETS", [2519]  = "BULLETS", [3033]  = "BULLETS", [3465]  = "BULLETS", [4960]  = "BULLETS", 
	[5568]  = "BULLETS", [8067]  = "BULLETS", [8068]  = "BULLETS", [8069]  = "BULLETS", [10512] = "BULLETS", 
	[10513] = "BULLETS", [11284] = "BULLETS", [11630] = "BULLETS", [13377] = "BULLETS", [15997] = "BULLETS", 
	[19317] = "BULLETS",
	-- souls
	[6265] = "SOULS",
}

Addon.Data.CAT = {
	"HEARTHSTONE",
	"MOUNTS",
	"KEYS",
	"TOOLS",
	"RODS",
	"ENCH",
	"HERBS",
	"SEEDS",
	"ARROWS",
	"BULLETS",
	"SOULS",
	"OTHERS",
}

Addon.Data.BAGS = {
	-- arrow bags aka quivers
	[2101]  = "ARROWS", [5439] = "ARROWS", [7278] = "ARROWS", [11362] = "ARROWS", [3573]  = "ARROWS", 
	[3605]  = "ARROWS", [7371] = "ARROWS", [8217] = "ARROWS", [2662]  = "ARROWS", [19319] = "ARROWS", 
	[18714] = "ARROWS",
	--bullets bags aka boh
	[2102] = "BULLETS", [5441] = "BULLETS", [7279] = "BULLETS", [11363] = "BULLETS", [3574]  = "BULLETS", 
	[3604] = "BULLETS", [7372] = "BULLETS", [8218] = "BULLETS", [2663]  = "BULLETS", [19320] = "BULLETS",
	--enchanting bags
	[22246] = "ENCH", [22248] = "ENCH", [22249] = "ENCH",
	--herbs bags
	[22250] = "HERBS", [22251] = "HERBS", [22252] = "HERBS",
	-- souls bags
	[22243] = "SOULS", [22244] = "SOULS", [21340] = "SOULS", [21341] = "SOULS", [21342] = "SOULS",
}


-- NOT USED FOR NOW, KEEP HER FOR SAFEKEEPING
-- character bags ids: 0 is backpak, 1234 are additional bags
local BAGS = {0, 1, 2, 3, 4,}
-- bank bags: -1 is bank itself, 5678910 are additional bags
local BANK = {-1, 5, 6, 7, 8, 9, 10,}