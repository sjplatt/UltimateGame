 def set_itad_variable
    Game.all.each do |game|
      Game.update(game.id,:itad=>encode_itad_plain(game.name))
    end
    Dlc.all.each do |dlc|
      Dlc.update(dlc.id,:itad=>encode_itad_plain(dlc.name))
    end
    Package.all.each do |package|
      Package.update(package.id,:itad=>encode_itad_plain(package.name))
    end
    Game.update(Game.find_by(name:"Tomb Raider III").id,:itad=>"tombraideriiiadventuresoflaracroft")
    Game.update(Game.find_by(name:"Fester Mudd: Curse of the Gold - Episode 1").id,:itad=>"festermuddcurseofgold")
    Game.update(Game.find_by(name:"Everquest ®").id,:itad=>
      "everquestfreetoplay")
    Game.update(Game.find_by(name:"CAFE 0 ~The Drowned Mermaid~").id,
      :itad=>"cafe0thedrownedmermaid")
    Game.update(Game.find_by(name:"Nameless ~The one thing you must recall~").id,:itad=>"namelesstheonethingyoumustrecall")
    Game.update(Game.find_by(name:"Schrödinger’s Cat And The Raiders Of The Lost Quark").id,:itad=>"schrodingerscatandraidersoflostquark")
    Game.update(Game.find_by(name:"Supreme League of Patriots - Episode 2: Patriot Frames").id,:itad=>"supremeleagueofpatriotsissueiipatriotframes")
    Game.update(Game.find_by(name:"Winter Voices").id,:itad=>"wintervoicesprologueavalanche")
    Game.update(Game.find_by(name:"Tropico 4: Steam Special Edition").id,:itad=>"tropicoiv")
    Game.update(Game.find_by(name:"Smooth Operators").id,:itad=>"smoothoperatorscallcenterchaos")
    Game.update(Game.find_by(name:"Supreme League of Patriots - Episode 3: Ice Cold in Ellis").id,:itad=>"supremeleagueofpatriotsissueiiiicecoldinellis")
    Game.update(Game.find_by(name:"Supreme League of Patriots").id,:itad=>"supremeleagueofpatriotsissueiapatriotisborn")
    Game.update(Game.find_by(name:"Plants vs. Zombies GOTY Edition").id,:itad=>"plantsvszombiesgameofyearedition")
    Game.update(Game.find_by(name:"Midnight Mysteries: Salem Witch Trials").id,:itad=>"midnightmysteriesiisalemwitchtrials")
    Game.update(Game.find_by(name:"planetarian ~the reverie of a little planet~").id,:itad=>"planetarianthereverieofalittleplanet")
    Game.update(Game.find_by(name:"Gothic 1").id,:itad=>"gothic")
    Game.update(Game.find_by(name:"LEGO Batman").id,:itad=>"legobatmanvideogame")
    #######################################
    Dlc.update(Dlc.find_by(name:"CAFE 0 ~The Drowned Mermaid~ - Japanese Voice Add-On").id,:itad=>"cafe0thedrownedmermaidjapanesevoiceaddon")
    Dlc.update(Dlc.find_by(name:"Rocksmith® 2014 – Sum 41 - “The Hell Song”").id,:itad=>"rocksmithii0iivsumivithehellsong")
    Dlc.update(Dlc.find_by(name:"Rocksmith® 2014 – The Who - “The Seeker”").id,:itad=>"rocksmithii0iivwhotheseeker")
    Dlc.update(Dlc.find_by(name:"Skyrim: High Resolution Texture Pack (Free DLC)").id,:itad=>"skyrimhighresolutiontexturepack")
    Dlc.update(Dlc.find_by(name:"Trainz Simulator DLC: Nickel Plate High Speed Freight Set").id,:itad=>"trainzsimulatoriiinickelplatehighspeedfreightset")
    Dlc.update(Dlc.find_by(name:"Trainz Simulator DLC: BR Class 14").id,:itad=>"trainzsimulatoriiibrclassiiv")
    Dlc.update(Dlc.find_by(name:"Tropico 4: Megalopolis DLC").id,:itad=>"tropicoivmegalopolis")
    Dlc.update(Dlc.find_by(name:"Tropico 4: Voodoo DLC").id,:itad=>"tropicoivvoodoo")
    Dlc.update(Dlc.find_by(name:"Tropico 4: Junta Military DLC").id,:itad=>"tropicoivmilitaryjuntadlc")
    Dlc.update(Dlc.find_by(name:"Tropico 4: Quick-dry Cement DLC").id,:itad=>"tropicoivquickdrycement")
    Dlc.update(Dlc.find_by(name:"After Reset RPG: graphic novel 'The Fall Of Gyes'").id,:itad=>"afterresetrpggraphicnovelthefallofgyes")
    Dlc.update(Dlc.find_by(name:"PAYDAY™ The Heist: Wolfpack DLC").id,:itad=>"paydayheistwolfpack")
    Dlc.update(Dlc.find_by(name:"Tropico 4: Pirate Heaven DLC").id,:itad=>"tropicoivpirateheaven")
    Dlc.update(Dlc.find_by(name:"Tropico 4: Plantador DLC").id,:itad=>"tropicoivplantador")
    Dlc.update(Dlc.find_by(name:"Tropico 4: Vigilante DLC").id,:itad=>"tropicoivvigilante")
    #################################################
    Package.update(Package.find_by(name:"Assassin's Creed Black Flag Digital Gold Edition").id,:itad=>"assassinscreedivblackflaggoldedition")
    Package.update(Package.find_by(name:"Assassin's Creed Black Flag - Season Pass").id,:itad=>"assassinscreedivseasonpass")
    Package.update(Package.find_by(name:"Assassin's Creed Liberation").id,:itad=>"assassinscreedliberationhd")
    Package.where(name:"Assassin's Creed Liberation").each do |pack|
       Package.update(pack.id,:itad=>"assassinscreedliberationhd")
    end
    Package.where(name:"Batman Arkham City GOTY").each do |pack|
      Package.update(pack.id,:itad=>"batmanarkhamcitygameofyearedition")
    end
    Package.update(Package.find_by(name:"Aura: Fate of Ages (NA)").id,:itad=>"aurafateofages")
    Package.update(Package.find_by(name:"Autocraft on Steam").id,:itad=>"autocraft")
    Package.update(Package.find_by(name:"CAFE 0 ~The Drowned Mermaid~").id,:itad=>"cafe0thedrownedmermaid")
    Package.update(Package.find_by(name:"CAFE 0 ~The Drowned Mermaid~ Deluxe").id,:itad=>"cafe0thedrownedmermaiddeluxe")
    Package.update(Package.find_by(name:"Command & Conquer: Kane's Wrath").id,:itad=>"commandandconqueriiikaneswrath")
    Package.update(Package.find_by(name:"CRYENGINE - Wwise Project").id,:itad=>"cryenginewwiseprojectdlc")
    Package.update(Package.find_by(name:"Disney's Princess Enchanted Journey").id,:itad=>"disneyprincessenchantedjourney")
    Package.update(Package.find_by(name:"Chicken Little").id,:itad=>"disneyschickenlittle")
    Package.update(Package.find_by(name:"Chicken Little Ace in Action").id,:itad=>"disneyschickenlittleaceinaction")
    Package.update(Package.find_by(name:"Disney-Pixar Brave").id,:itad=>"disneypixarbravevideogame")
    Package.update(Package.find_by(name:"Cars").id,:itad=>"disneypixarcars")
    Package.update(Package.find_by(name:"Cars Mater-National").id,:itad=>"disneypixarcarsmaternationalchampionship")
    Package.update(Package.find_by(name:"Cars Toon").id,:itad=>"disneypixarcarstoonmaterstalltales")
    Package.update(Package.find_by(name:"Cars Radiator Springs Adventures").id,:itad=>"disneypixarcarsradiatorspringsadventures")
    Package.update(Package.find_by(name:"Finding Nemo").id,:itad=>"disneypixarfindingnemo")
    Package.update(Package.find_by(name:"WALL E").id,:itad=>"disneypixarwalle")
    Package.update(Package.find_by(name:"Dominions 4").id,:itad=>"dominionsivthronesofascension")
    Package.update(Package.find_by(name:"Dungeons of Dredmor Complete").id,:itad=>"dungeonsofdredmorcompletepack")
    Package.update(Package.find_by(name:"Blackguards - Standard Edition").id,:itad=>"blackguards")
    Package.update(Package.find_by(name:"Red Shark: GTA$100,000").id,:itad=>"grandtheftautoonlineredsharkcashcard")
    Package.update(Package.find_by(name:"Tiger Shark: GTA$200,000").id,:itad=>"grandtheftautoonlinetigersharkcashcard")
    Package.update(Package.find_by(name:"Bull Shark: GTA$500,000").id,:itad=>"grandtheftautoonlinebullsharkcashcard")
    Package.update(Package.find_by(name:"Whale Shark: GTA$3,500,000").id,:itad=>"grandtheftautoonlinewhalesharkcashcard")
    Package.update(Package.find_by(name:"Megalodon Shark: GTA$8,000,000").id,:itad=>"grandtheftautoonlinemegalodonsharkcashcard")
    Package.update(Package.find_by(name:"Half-Life 1").id,:itad=>"halflife")
    Package.update(Package.find_by(name:"Hotline Miami 2").id,:itad=>"hotlinemiamiiiwrongnumber")
    Package.update(Package.find_by(name:"Tomb Raider III").id,:itad=>"tombraideriiiadventuresoflaracroft")
    Package.update(Package.find_by(name:"Tom Clancy's Ghost Recon Future Soldier - Standard").id,:itad=>"ghostreconfuturesoldier")
    Package.update(Package.find_by(name:"WARMACHINE: Tactics - Standard Edition").id,:itad=>"warmachinetactics")
    Package.update(Package.find_by(name:"LEGO Batman 2").id,:itad=>"legobatmaniidcsuperheroes")
    Package.update(Package.find_by(name:"Car Mechanic Simulator").id,:itad=>"carmechanicsimulatorii0iiv")
    Package.update(Package.find_by(name:"STAR WARS™: X-Wing").id,:itad=>"starwarsxwingspecialedition")
    Package.update(Package.find_by(name:"Guild Wars Factions<sup>®</sup>").id,:itad=>"guildwarsfactions")
    Package.update(Package.find_by(name:"Plants vs. Zombies GOTY Edition").id,:itad=>"plantsvszombiesgameofyearedition")
    Package.update(Package.find_by(name:"Portal 2 - Perceptual Pack").id,:itad=>"portaliisixenseperceptualpack")
    Package.update(Package.find_by(name:"F1 2013 ROW").id,:itad=>"fiii0iiiiclassicedition")
    Package.update(Package.find_by(name:"Great White Shark: GTA$1,250,000").id,:itad=>"grandtheftautoonlinegreatwhitesharkcashcard")
  end