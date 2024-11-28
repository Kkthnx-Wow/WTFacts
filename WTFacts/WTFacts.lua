-- Addon Table
local _, namespace = ...
local WTFacts = namespace:CreateFrame("Frame")
namespace:RegisterSettings("WTFactsDB", {
	{
		key = "enabled",
		type = "toggle",
		title = "Enable WTFacts",
		tooltip = "Enable or disable the WTFacts addon.",
		default = true,
	},
	{
		key = "cooldown",
		type = "slider",
		title = "Fact Cooldown (minutes)",
		tooltip = "Set the cooldown period for facts (in minutes).",
		default = 10,
		minValue = 1,
		maxValue = 60,
		valueStep = 1,
		valueFormat = function(value)
			return string.format("%d min", value)
		end,
	},
	{
		key = "delay",
		type = "slider",
		title = "Message Delay (seconds)",
		tooltip = "Set the delay for sending the message after triggering (in seconds).",
		default = 2,
		minValue = 1,
		maxValue = 5,
		valueStep = 1,
		valueFormat = function(value)
			return string.format("%d sec", value)
		end,
	},
})

print("Settings registered successfully.")

-- Register Callbacks for Settings
namespace:RegisterOptionCallback("enabled", function(value)
	if value then
		print("|cff00ff00WTFacts Enabled!|r")
	else
		print("|cff00ff00WTFacts Disabled!|r")
	end
end)

namespace:RegisterOptionCallback("cooldown", function(value)
	print(string.format("|cff00ff00WTFacts Cooldown set to %d minutes.|r", value))
end)

namespace:RegisterOptionCallback("delay", function(value)
	print(string.format("|cff00ff00WTFacts Message Delay set to %d seconds.|r", value))
end)

-- Fact List
local facts = {
	"In WoW, chickens are smarter than they look. There's a secret questline if you /chicken at one!",
	"There's a gnome NPC in Northrend who complains about how cold it is—he's not wrong.",
	"The first player to hit max level in WoW Classic did it by grinding mobs for days straight.",
	"Death Knights start at level 55 because lore-wise, they 'skipped' normal life. Convenient!",
	"The Karazhan Chess Event has caused more wipes than actual bosses in that raid.",
	"During the WoW beta, Mages could teleport other players... anywhere. Chaos ensued.",
	"The most expensive mount in WoW history is the Mighty Caravan Brutosaur, aka the 'Longboi.'",
	"Some of the NPCs in Booty Bay are named after pirates from real history.",
	"Goblin engineering is so volatile that early WoW players blew themselves up crafting items!",
	"There’s a rare spawn in Tanaris called Caliph Scorpidsting. He drops a scorpion that isn’t even a pet.",
	"In early WoW, jumping off Thunder Bluff accidentally was a rite of passage for Taurens.",
	"Some fishing spots in Azeroth are so rare they only appear during in-game weather events.",
	"Vanilla WoW had no in-game map markers. You just had to remember where stuff was.",
	"The original Naxxramas raid had bosses so hard that most guilds never finished it.",
	"In Outland, you can find an NPC named 'Haris Pilton' selling overpriced bags. Yes, that's a joke.",
	"Players in early WoW loved to kite world bosses into major cities for laughs... and mass deaths.",
	"The Scarab Lord title from Ahn'Qiraj is one of the rarest in WoW history.",
	"Shaman totems once had to be placed individually—and they could be destroyed by enemies.",
	"There's a turtle NPC named Lvl ?? Elite who is a parody of TMNT in Pandaria.",
	"The first level 60 player in Vanilla WoW took about 10 days of /played time.",
	"In the Wrath pre-patch, the zombie plague turned every player into a griefing machine.",
	"Rogues in Vanilla could one-shot people using Ambush if they stacked enough Agility.",
	"Frost Mages used to kite raid bosses indefinitely during glitches. Blizzard patched it out.",
	"You can find a small tribute to StarCraft inside the Engineering profession.",
	"Players in early WoW would duel in front of Stormwind for hours, betting gold on matches.",
	"The dance for male Trolls is based on Michael Jackson's 'Thriller.'",
	"In Azeroth, all female Draenei canonically wear high heels. Always ready for a party.",
	"Warlocks in Vanilla were so OP that guilds demanded you level one for raids.",
	"The Leeroy Jenkins meme originated from a player in Upper Blackrock Spire. Never forget.",
	"Blizzard once turned a player’s cat into an in-game NPC as a memorial.",
	"There's a secret pet in the game called 'Mr. Bigglesworth' that references Naxxramas' boss Kel'Thuzad.",
	"In the Barrens, there's a neutral Kodo skeleton NPC named 'Old Blanchy’s Cousin.'",
	"The toy 'Piccolo of the Flaming Fire' makes everyone nearby dance. Perfect for raid trolling.",
	"Murlocs were added to Warcraft lore late in development because devs wanted 'something weirder.'",
	"There’s a waterfall in Pandaria that has a hidden cave with an abandoned tea set.",
	"If you spam the /moo emote as a Tauren, sometimes you get a special response.",
	"The sword 'Ashbringer' was teased for years before finally being added in Wrath of the Lich King.",
	"Players in Classic WoW created 'bridges' by standing on each other to reach secret places.",
	"The most infamous quest in Vanilla was 'Deep Ocean, Vast Sea'—because no one had water breathing.",
	"There’s a rare mob in the Jade Forest that has a pet panda named after a Blizzard employee.",
	"Goblins have a secret motto: 'Time is money, friend!' It’s not so secret anymore.",
	"Some WoW zones like Azshara were originally supposed to be major cities but were scrapped.",
	"The 'Dancing Troll Village' is a hidden zone with NPCs partying 24/7. It's amazing.",
	"If you jump enough times as a Gnome, other players might ask you to stop. It’s too cute.",
	"The loading screen tips have a 0.01% chance to display 'You are not prepared!' as a joke.",
	"The infamous 'Barrens Chat' was where most Chuck Norris jokes were born in WoW.",
	"You can find NPCs in Dalaran who look suspiciously like Harry Potter characters.",
	"In Vanilla, people spent hours farming for rare mounts like the Baron Rivendare's Deathcharger.",
	"There's a secret underwater cave in Zangarmarsh with glowing mushrooms.",
	"The Black Temple was once a sanctuary for the Draenei before Illidan took it over.",
	"During the Cataclysm, most players forgot about Gilneas after leveling through it.",
	"Blizzard once released a patch that accidentally made hunters' pets invincible in PvP.",
	"The first world-first raid boss kill was Ragnaros in Molten Core.",
	"A fish in Pandaria has the name 'Wish-Fish' and drops a wish-granting item... sometimes.",
	"Goblins used to explode their own mounts for fun before it was patched out.",
	"The game still references Kael'thas Sunstrider's infamous line, 'Tempest Keep was merely a setback!'",
	"The pet Pepe has costumes for different in-game holidays, including a pirate hat!",
	"In Karazhan, there's an upside-down room where gravity clearly doesn't exist.",
	"The legendary cloak questline in Mists of Pandaria made players hate running LFR repeatedly.",
	"There's a rare mount in Nazjatar that drops from a crab called 'Snapdragon.'",
	"The Auction House was originally so buggy that gold duping exploits became rampant.",
	"In Legion, players could solo older raids and collect every artifact appearance.",
	"There’s a toy called the 'Disco Ball' that turns every nearby player into a dancer.",
	"The Goldshire innkeeper has one of the most haunted WoW locations upstairs. Don’t visit at night.",
	"The pandas in Valley of the Four Winds sometimes wave at you if you emote back.",
	"There's a legendary trinket called 'The Skull of Gul'dan,' but Gul'dan isn't amused.",
	"The Wand of Animation lets you bring objects to life. Some players use it for mischief.",
	"In Dalaran, there’s a vendor who sells cheese that’s 'aged for a millennium.' Expensive, though.",
	"You can find a penguin pet in Northrend that waddles around without a care in the world.",
	"Some early raid bosses used to have unlootable corpses if players killed them incorrectly.",
	"The game’s original developers hid jokes in item tooltips, like 'This sword doesn’t actually exist.'",
	"Mages in early WoW used to make a killing selling food and water to players.",
	"There’s a rare vanity pet called 'Bananas' that’s a baby monkey wearing a diaper.",
	"In Legion, NPCs sometimes broke the fourth wall and commented on how many heroes exist.",
	"A Tauren NPC in Thunder Bluff plays a flute version of 'My Heart Will Go On' by Celine Dion.",
	"The Darkmoon Faire has an eerie forest with glowing eyes that follow you.",
	"There’s a gnome NPC in Gnomeregan who complains about the radiation being 'totally safe.'",
	"Before mounts, players used to joke that Druids had the first 'vehicle'—Travel Form.",
	"There's a secret fishing spot in Booty Bay that increases your chance for rare catches.",
	"In early WoW, players used to sit around campfires for no reason other than vibes.",
	"The Horde airship captains occasionally argue over the intercom. It's worth eavesdropping on.",
	"Some Forsaken NPCs still reference their human lives in odd and unsettling ways.",
	"The Tiny Green Ragdoll toy is one of the creepiest items you can place in your Garrison.",
	"The original Dark Portal event caused crashes when too many players showed up.",
	"In the original WoW beta, Dwarves could play as Mages, but it was removed before launch.",
	"There’s a graveyard in Duskwood with headstones that tell jokes if you read them.",
	"The Ashbringer sword was rumored for years before it became a real item in Wrath of the Lich King.",
	"The TCG loot card 'Spectral Tiger' is still one of the most sought-after mounts in WoW.",
	"Murlocs have their own language, but no one has successfully translated it—yet.",
	"A hidden NPC in Stranglethorn Vale sells bananas to players. Why? No one knows.",
	"The Zandalari Trolls’ Dazar'alor temple is one of the tallest structures in WoW.",
	"You can sometimes hear NPCs gossiping about players in inns if you stand close enough.",
	"Gnomes used to have a racial ability called 'Escape Artist' that was great in PvP.",
	"If you swim far enough out to sea, fatigue will kill you faster than any shark can.",
	"The Ironforge airport is a hidden area that has existed since Vanilla WoW.",
	"The legendary Thunderfury sword was often memed in trade chat as 'Thunderfury, Blessed Blade of the Windseeker.'",
	"You can find penguins in Northrend who will slide down icy slopes if you wait long enough.",
	"During the MoP expansion, the Tillers farm was a hidden favorite for casual players.",
	"The term 'Leeroy Jenkins' is now officially in the Merriam-Webster dictionary as a meme.",
	"The Scarlet Crusade has some of the most morally questionable NPCs in WoW.",
	"Blizzard once added a toy that spawns a tiny disco floor for everyone to dance on.",
	"Hogger is so infamous that he has his own raid encounter in the Hearthstone game.",
	"If you duel in the Gurubashi Arena, everyone can loot your corpse if you die.",
	"There’s a hidden tribute to Robin Williams in Draenor: a genie NPC called 'Robin.'",
	"The Fel Reaver in Outland has a surprising amount of fan art, despite traumatizing players.",
	"Goblins invented rockets, but they never patented them. That’s why everyone uses them.",
	"The Stormwind park district was destroyed in Cataclysm and only rebuilt years later.",
	"The Pandaren racial ability, 'Bouncy,' reduces fall damage by 50%. Pandas are just chill like that.",
	"There’s a rare gnome in Borean Tundra who rides a mechanical spider mount.",
	"The legendary weapon Sulfuras was inspired by Norse mythology’s hammer of the gods.",
	"Darkmoon Faire NPCs have some of the creepiest dialogue in the game. Read it closely.",
	"Worgen used to be a part of the Scythe of Elune storyline before they became playable.",
	"The Moonkin form for Druids is lovingly called 'Boomkin' by the community.",
	"In WoW Classic, players had to carry quivers for arrows or they couldn’t attack as Hunters.",
	"The Wind Rider mounts used by the Horde are inspired by lions with bat wings.",
	"There’s a secret bar hidden in Booty Bay where NPCs argue over pirate treasure.",
	"If you /wave at certain NPCs, they will wave back. Try it on a guard!",
	"The 'Underbelly' in Dalaran is a hot spot for PvP... and for fishing rare items.",
	"You can still find remains of Old God minions buried deep within Silithus.",
	"Mount Hyjal was inaccessible in Vanilla but had a hidden entrance that players exploited.",
	"In Vanilla WoW, you had to craft resistance gear to survive certain raid encounters.",
	"There’s a giant skeleton in the Shimmering Flats that might belong to a forgotten titan.",
	"The Plaguelands were once a thriving human kingdom before the Scourge wiped it out.",
	"A rare toy called the 'Flame Eater' lets you breathe fire on other players.",
	"The Blackrock Orcs were originally allies of the Horde but betrayed them for power.",
	"Players who complete 'Insane in the Membrane' earn one of the hardest titles in the game.",
	"The Tuskarr fishing villages in Northrend have some of the coziest vibes in the game.",
	"The Deadmines dungeon has a hidden parrot named Captain Cookie who can drop loot.",
	"The neutral Pandaren starting zone is technically a giant turtle named Shen-zin Su.",
	"You can find NPCs in Azeroth arguing about which came first, the murloc or the egg.",
	"In Classic WoW, it could take weeks to gather enough materials for a single raid attempt.",
	"The Reins of the Grey Riding Camel is one of the most difficult mounts to obtain, requiring rare NPC hunting in Uldum.",
	"Goblins were added as a playable race because of their popularity as quirky NPCs.",
	"The Onyxia Wipe Animation became a viral sensation, based on an actual raid leader’s meltdown.",
	"The Scepter of the Shifting Sands questline is one of the longest and most epic in WoW history.",
	"The Un’Goro Crater in Kalimdor is inspired by real-life prehistoric locations like the Galápagos Islands.",
	"In Outland, some NPCs still reference the Burning Crusade as if it’s happening right now.",
	"The Zandalari Trolls’ empire predates the Sundering and the splitting of Azeroth into continents.",
	"The original WoW Alpha included fully functional flying mounts, but they were removed for Vanilla.",
	"The Emerald Dream was originally planned as an expansion but ended up being raid content instead.",
	"Khadgar’s beard is so iconic that players often joke about him hiding magic items in it.",
	"In Wrath of the Lich King, players could accidentally kite raid bosses into Dalaran, causing chaos.",
	"Some Tauren NPCs reference the phrase 'bull market,' a nod to financial humor.",
	"The model for Gnomish Engineers’ devices was inspired by old steampunk aesthetics.",
	"There’s a rare mob called 'The Rake' that became famous for being the best Hunter pet in Classic WoW.",
	"During Brewfest, players can complete a quest that involves riding a ram and stealing kegs.",
	"You can find a broken statue of Arthas hidden in Icecrown, symbolizing his tragic fall.",
	"The toy 'Wand of Simulated Life' lets players bring inanimate objects to life temporarily.",
	"There’s a secret chicken farm in Hillsbrad Foothills where chickens wander free.",
	"The Timeless Isle in Pandaria is filled with Easter eggs, including a giant rubber ducky.",
	"Some of the worgen NPCs in Gilneas quote lines from Victorian literature.",
	"The Forsaken’s plague experiments often reference real-world toxicology practices.",
	"In the Battle for Azeroth expansion, you can find NPCs making fun of previous expansions’ plot holes.",
	"Murlocs have a higher chance to drop green items than most other mobs in the game.",
	"Blizzard once added a 'Dance Studio' in patch notes as an April Fool’s joke.",
	"The Darkmoon Rabbit is a hidden world boss inspired by Monty Python.",
	"The title 'Salty' can be earned by completing the most difficult fishing achievements in WoW.",
	"There’s a hidden underwater cave in Vashj’ir filled with glowing jellyfish.",
	"Some rare spawns in Northrend drop vanity pets instead of gear or crafting materials.",
	"The game’s original developers used to run events on live servers disguised as NPCs.",
	"During Wrath pre-patch events, the zombie plague could completely wipe out entire cities.",
	"The Wandering Isle’s name refers to the fact that it floats and travels across the ocean.",
	"There’s a miniature version of Stormwind Keep hidden in the Deeprun Tram tunnel.",
	"The Ethereal race is based on sci-fi depictions of energy beings.",
	"In Moonglade, you can find ancient trees with faces carved into their bark.",
	"Some of the jokes told by Troll NPCs in the game are puns on real-world Rastafarian culture.",
	"The Haunted Memento from Naxxramas summons a shadowy ghost to follow players around.",
	"Goblins are the only race in WoW to have their own functional rocket transport network.",
	"The Barrens used to have an NPC named 'Mankrik’s Wife' before she disappeared.",
	"The dungeon Scholomance is named after a legendary school of black magic from folklore.",
	"You can find a small shrine to Uther the Lightbringer in the Plaguelands.",
	"There’s a rare spawn named 'Time-Lost Proto-Drake' that hunters have searched for years to tame.",
	"Draenei spaceships are powered by magic crystals called Naaru cores.",
	"The Lunar Festival holiday event is based on the Chinese New Year.",
	"The Whispering Forest in Tirisfal Glades has a secret event where faerie dragons perform a ritual.",
	"The Silithid race in WoW is inspired by the insect-like Zerg from StarCraft.",
	"Gnomes were added as a playable race partly as comic relief for the Alliance.",
	"During Legion, Demon Hunters could double-jump, making them the most agile class in the game.",
	"Did you know that Thrall’s name means 'slave' in Old Norse?",
	"There’s a hidden NPC named Captain Placeholder that used to stand in for unfinished content.",
	"The underwater zone Vashj’ir was Blizzard’s first fully aquatic environment.",
	"Some mobs in WoW Classic dropped gray items with hilariously long names just for fun.",
	"The Argent Tournament grounds in Northrend were originally going to be a raid zone.",
	"The Jinyu race in Pandaria can 'listen' to the water to predict the future.",
	"Every playable class in WoW has at least one spell inspired by Dungeons & Dragons mechanics.",
	"The Zandalari Trolls' Loa gods are based on real-world voodoo and spiritual traditions.",
	"You can find an NPC named 'Haris Pilton' selling overpriced bags as a parody of Paris Hilton.",
	"The Blingtron 4000 robot distributes gifts, but it’s also been known to start wars between players.",
	"The Fel Reaver in Hellfire Peninsula is infamous for sneaking up on distracted players.",
	"Players who earn the title 'The Insane' must max out reputations with factions that despise each other.",
	"There’s a secret location in Icecrown where a ghostly mage trains forever in solitude.",
	"Some bosses in raids will taunt players by using their own voice lines against them.",
	"The Turtle Mount is a rare fishing drop and was one of the first mounts added via fishing.",
	"The Dark Portal was originally created by the orc warlock Gul’dan to invade Azeroth.",
	"A quest in the Barrens involves investigating why kodos mysteriously vanish into the desert.",
	"The Sha of Pandaria represent negative emotions like anger, fear, and doubt.",
	"Vanilla WoW had no transmog system, and players had to deal with mismatched armor sets.",
	"In the original WoW beta, players could kill quest-giving NPCs, breaking quests for everyone.",
	"Teldrassil, the World Tree, was corrupted by an Old God shortly after it was grown.",
	"The Wandering Isle, the Pandaren starting zone, is carried on the back of a giant turtle.",
	"Some rare mobs drop vanity items like cooking hats or pirate costumes.",
	"In Winterspring, you can still find NPCs referencing the epic Wintersaber grind.",
	"The 'Lazy Peons' in the Orc starting zone are a callback to a Warcraft III mission.",
	"Frost Mages were nicknamed 'ice cannons' for their powerful crowd control abilities in PvP.",
	"The questline to obtain the legendary weapon Atiesh required raiding and months of dedication.",
	"The original AQ War Effort event required entire servers to work together to unlock the raid.",
	"Rogues in Vanilla WoW could pickpocket unique items like lockboxes and junk.",
	"The Timeless Isle features unique items that transform players into frogs, birds, or other animals.",
	"The goblins' obsession with explosives has caused more than one in-game accident.",
	"The city of Suramar in Legion is based on the height of Nightborne civilization.",
	"The Forsaken faction was originally neutral but became Horde after Sylvanas joined them.",
	"The Cataclysm expansion flooded the Thousand Needles zone, creating a massive saltwater lake.",
	"Arthas’ horse, Invincible, is one of the most sought-after mounts in the game.",
	"The Forsaken use blight bombs in battle, a strategy derived from their plague experiments.",
	"Blizzard once hosted an in-game memorial for a player who passed away.",
	"The town of Goldshire is infamous on certain RP servers for… unconventional activities.",
	"There’s a gnome NPC in the Brawler’s Guild who references the Rocky movies.",
	"The first raid boss in WoW, Onyxia, has over 50 voice lines to taunt players.",
	"The Murloc language was created by sound designers gargling water into a microphone.",
	"The music in Grizzly Hills is so beloved that it’s often played outside the game.",
	"The city of Dalaran has moved three times in WoW’s history.",
	"The Scarlet Crusade believes all non-humans are infected with undeath.",
	"The Alliance and Horde fight over resources in Silithus, even though it’s a barren wasteland.",
	"The Emerald Nightmare raid was based on corrupted versions of zones in the Emerald Dream.",
	"There’s a rare fish in Stranglethorn Vale called the Dezian Queenfish that’s purely decorative.",
	"The toy ‘Piccolo of the Flaming Fire’ forces everyone nearby to dance.",
	"During Brewfest, players can fight a boss named Coren Direbrew to earn unique mounts.",
	"The PvP title ‘High Warlord’ was one of the hardest titles to earn in Vanilla WoW.",
	"The Worgen curse originated from a druidic ritual gone wrong.",
	"In Moonglade, you can find a giant turtle that’s over 10,000 years old.",
	"The original design for Death Knights in Vanilla WoW was an alternate hero class that started at level 1.",
	"The toy ‘Robo-Gnomebulator’ temporarily turns players into gnomish robots.",
	"The Goblin Zeppelin is powered by Goblin ingenuity—and a lot of duct tape.",
	"Mages were the first class to have teleportation spells for instant travel.",
	"In Pandaria, you can find a hidden shrine dedicated to a cat named Socks.",
	"Draenei crystals are infused with holy energy, which makes them glow.",
	"There’s a hidden cave in the Badlands filled with skeletons and treasure maps.",
	"The underwater ruins of Vashj'ir are remnants of an ancient Naga empire.",
	"The Aldor and Scryer factions in Shattrath used to fight openly in the city.",
	"Hunters used to need ammunition to shoot their ranged weapons, taking up bag space.",
	"There’s a secret tribute to a Blizzard employee in the Storm Peaks, featuring their favorite pet.",
	"The giant trees in Ashenvale are thousands of years old and protected by the Night Elves.",
	"An NPC in Nagrand references the famous line ‘This is not my beautiful house!’ from the Talking Heads song.",
	"The Crystalsong Forest is named after the powerful crystals growing throughout the zone.",
	"Arakkoa from Outland were originally guardians of the Apexis Crystals.",
	"During Children’s Week, you can take orphans on adventures across Azeroth.",
	"The Blackrock Spire dungeon is a massive fortress with hidden corridors and Easter eggs.",
	"There’s a hidden cave in Azshara where developers left untextured walls as an inside joke.",
	"The Lost Vikings, a classic Blizzard game, is referenced by NPCs in several WoW locations.",
	"In Legion, players could loot hidden artifact appearances by solving puzzles.",
	"The mount ‘Big Love Rocket’ is one of the rarest in-game items, only available during Love is in the Air.",
	"The Timbermaw Hold faction in Felwood has some of the hardest-to-please furbolgs in the game.",
	"The Zhevras in the Barrens are based on zebras but have unique horns.",
	"During the Cataclysm, Deathwing scarred Azeroth permanently with massive earthquakes.",
	"The Exodar is a crashed spaceship that the Draenei turned into their capital.",
	"Naga were once Night Elves, transformed after the Well of Eternity exploded.",
	"In Mechagon, you can build your own customizable mechanical mounts.",
	"The Darkmoon Faire features a roller coaster you can actually ride.",
	"The Emerald Dream is a vision of Azeroth untouched by mortal hands.",
	"The Maelstrom is the site of the original Well of Eternity’s destruction.",
	"Blizzard once hid an NPC named Jon in Shadowmoon Valley as a tribute to a long-time player.",
	"The N’Zoth boss fight in Ny’alotha featured mechanics based on Lovecraftian horror.",
	"The Wailing Caverns was originally going to be a solo dungeon.",
	"A hidden vendor in Winterspring sells a pattern for a Frostsaber mount.",
	"The Deeprun Tram connects Stormwind and Ironforge but also has a giant underwater tunnel.",
	"Each expansion of WoW introduced at least one major lore character as a raid boss.",
	"You can find the remains of a crashed goblin airship in Azshara.",
	"The Scarlet Monastery’s leaders were fanatics who thought undeath could be cured.",
	"The Sholazar Basin in Northrend was inspired by the Un’Goro Crater in Kalimdor.",
	"Tauren totems are carved with symbols that tell their tribe’s history.",
	"A bug in Vanilla WoW once allowed hunters to tame boss-level mobs.",
	"The infamous Corrupted Blood incident became a case study for epidemiologists.",
	"An NPC in Dalaran tells players he’s been polymorphed into a sheep for years.",
	"The Kalu’ak in Northrend are Tuskarr fishermen who also build intricate carvings.",
	"There’s a secret hatch in Uldum referencing the TV show Lost.",
	"The Drakkari trolls sacrificed their own gods to protect themselves from the Scourge.",
	"Blizzard developers used to host trivia contests during in-game events.",
	"The Hearthstone card game started as a simple WoW mini-game concept.",
	"The PvP Arena system was introduced in The Burning Crusade expansion.",
	"The Dancing Troll Village in Hinterlands is a hidden location with non-stop music.",
	"The Tauren capital, Thunder Bluff, is built on giant mesas for protection against enemies.",
	"Some Night Elf ruins in Azeroth still hold ancient moonwell water with magical properties.",
	"The Argent Dawn faction was formed to protect Azeroth from undead threats after the Third War.",
	"The Burning Legion’s soldiers come from countless conquered worlds across the cosmos.",
	"An NPC in Booty Bay references the Pirates of the Caribbean movie franchise.",
	"The Pandaren racial ability ‘Epicurean’ increases the stat boost from food.",
	"In Wrath of the Lich King, players could duel on the edges of Dalaran and knock each other off.",
	"The Eternal Palace in Nazjatar is the seat of Queen Azshara’s power.",
	"In Orgrimmar, the Auction House has secret goblin tunnels connecting different areas.",
	"You can find a rare chicken in Elwynn Forest that starts a hidden quest if you /chicken at it.",
	"The Saronite ore found in Northrend is said to be the blood of Yogg-Saron.",
	"The Old Gods whisper to players during certain quests, often sowing doubt and fear.",
	"The Midsummer Fire Festival celebrates Azeroth’s longest days with bonfires and fireworks.",
	"There’s a hidden tribute to StarCraft in Azshara, with zergling-like creatures near the shoreline.",
	"The Forsaken Apothecaries conduct experiments in alchemy to create plagues and poisons.",
	"The Demon Hunter’s ability to glide comes from their spectral wings.",
	"The toy ‘Super Simian Sphere’ transforms players into a glowing ape inside a magical bubble.",
	"The Firelands raid features Ragnaros reborn, this time with legs!",
	"In the Barrens, you can find a mysterious oasis guarded by aggressive creatures.",
	"The Garrison system in Warlords of Draenor lets players build and customize their own base.",
	"The Timeless Isle in Pandaria has a mysterious shrine where you can ask for fortunes.",
	"The underwater zone Nazjatar was ruled by Queen Azshara for millennia.",
	"A hidden NPC in the Grizzly Hills serenades players with a fishing song.",
	"The Black Temple raid was originally Illidan’s fortress and training ground for Demon Hunters.",
	"Goblins are known for their explosive mining techniques, which sometimes backfire spectacularly.",
	"The Vrykul of Northrend believe only the strongest warriors deserve to ascend to Valhalla.",
	"The Netherstorm in Outland is a region torn apart by chaotic arcane energy.",
	"The toy ‘Gnomish X-Ray Specs’ lets players see everyone as skeletons.",
	"Some of the Zandalari Trolls’ architecture predates the Sundering of Azeroth.",
	"The Siege of Orgrimmar raid marked the end of Garrosh Hellscream’s reign as Warchief.",
	"In Classic WoW, players had to manually discover flight paths by visiting them in person.",
	"There’s a hidden panda NPC in Pandaria who offers wise advice and riddles.",
	"The underwater ruins in Vashj’ir were once part of a thriving Kaldorei empire.",
	"The Scarlet Halls dungeon is a training ground for the Scarlet Crusade’s new recruits.",
	"The Brawler’s Guild features increasingly difficult solo challenges for players to conquer.",
	"In Draenor, you can fish up a shark mount called the ‘Riding Shark.’",
	"The Hozen of Pandaria have their own unique language, often filled with monkey-themed slang.",
	"The Timeless Isle is filled with random events, including a mysterious ghost ship.",
	"The Dark Portal is one of the oldest structures in Azeroth, built by the Orcs to invade.",
	"Some Murlocs in Elwynn Forest wear fishing hats, suggesting they’ve adapted to human habits.",
	"The Blood Elf capital, Silvermoon, still bears scars from Arthas’ attack during the Third War.",
	"The Wrathion NPC in Mists of Pandaria is one of the last uncorrupted Black Dragons.",
	"The Lost Isles, the Goblin starting zone, is full of references to pop culture, including Indiana Jones.",
	"The toy ‘Sack of Starfish’ summons flying starfish to follow players around.",
	"The Iron Horde in Warlords of Draenor used primitive weapons enhanced by technology.",
	"The Legion invasion events brought infernals crashing down into random zones, causing chaos.",
	"The troll city of Zul’Gurub was once a raid but is now a 5-player dungeon.",
	"During Hallow’s End, you can trick-or-treat for rare items and spooky rewards.",
	"The mount ‘Headless Horseman’s Steed’ only drops during the Hallow’s End event.",
	"Some Forsaken NPCs in Tirisfal Glades still wear the armor they died in.",
	"The Pit of Saron dungeon in Icecrown is a frozen mine used by the Scourge.",
	"The music in Storm Peaks is inspired by Nordic mythology and landscapes.",
	"During Legion, players could obtain a fishing artifact called the ‘Underlight Angler.’",
	"The Zhevra Plains in the Barrens are home to herds of unique striped creatures.",
	"The rare spawn ‘Loque’nahak’ is a Spirit Beast highly sought after by hunters.",
	"The Void Elves were exiled Blood Elves who embraced the void for power.",
}

-- Cooldown Tracker
local lastFactTime = 0

-- Function to get the appropriate chat channel
local function GetChatChannel()
	-- Check if in a random group (LFG or Party Walk-In) and return the appropriate channel
	if IsPartyLFG() or C_PartyInfo.IsPartyWalkIn() then
		return "INSTANCE_CHAT"
	elseif IsInRaid() then
		return "RAID"
	elseif IsInGroup() then
		return "PARTY"
	else
		return "SAY" -- Default to SAY if not in any group
	end
end

local function FormatTime(seconds)
	if seconds >= 60 then
		local mins = math.floor(seconds / 60)
		local secs = seconds % 60
		return string.format("%d min%s %d sec%s", mins, mins > 1 and "s" or "", secs, secs > 1 and "s" or "")
	else
		return string.format("%d sec%s", seconds, seconds > 1 and "s" or "")
	end
end

-- Function to display a random fact
local function ShowRandomFact()
	if not namespace:GetOption("enabled") then
		print("|cffFF0000[WTFacts]: The addon is currently disabled.|r")
		return
	end

	local currentTime = time()
	local cooldown = namespace:GetOption("cooldown") * 60 -- Convert cooldown to seconds
	local delay = namespace:GetOption("delay") -- Get the delay setting in seconds
	local timeLeft = cooldown - (currentTime - lastFactTime)

	if timeLeft > 0 then
		print(string.format("|cffFFFF00[WTFacts]: The addon is on cooldown. %s remaining.|r", FormatTime(timeLeft)))
		return
	end

	lastFactTime = currentTime -- Update the last fact time
	local randomFact = facts[math.random(#facts)]
	local channel = GetChatChannel()

	-- Notify and send the fact with a delay
	print(string.format("|cff00ff00[WTFacts]: Sending fact in %d seconds...|r", delay))
	C_Timer.After(delay, function()
		SendChatMessage("[WTFacts]: " .. randomFact, channel)
	end)
end

-- Register Events
WTFacts:RegisterEvent("ACHIEVEMENT_EARNED", ShowRandomFact)
WTFacts:RegisterEvent("BOSS_KILL", ShowRandomFact)
WTFacts:RegisterEvent("CHALLENGE_MODE_COMPLETED", ShowRandomFact)
WTFacts:RegisterEvent("LFG_COMPLETION_REWARD", ShowRandomFact)
WTFacts:RegisterEvent("PLAYER_LEVEL_UP", ShowRandomFact)

-- Slash Command for Manual Trigger
namespace:RegisterSlash("/wtfacts", function()
	ShowRandomFact()
end)

-- On Addon Loaded
function namespace:OnLoad()
	print("|cff00ff00WTFacts Loaded!|r Type /wtfacts to manually trigger a fact.")
end

-- On Player Login
function namespace:OnLogin()
	if namespace:GetOption("enabled") then
		print("|cff00ff00WTFacts is enabled.|r You can configure it via the settings panel.")
	else
		print("|cff00ff00WTFacts is currently disabled.|r Enable it via the settings panel.")
	end
end