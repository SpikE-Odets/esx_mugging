Config = {}
Config.Locale = 'en'

Config.NPCPolice = false           --  NPC might trigger in-game wanted level and spawn AI police

Config.DirtyMoney = false           --  added for servers that wish to add to black money account instead of cash.
Config.GCPhone = false              --  added for GCPhone server that was not getting police alerts.
Config.progressBars = true          --  If your server has progressBars and wants to use vs text for mugging time.
Config.CopsNeeded = 0               --  Number of Police needed to mug locals.
Config.MinMoney = 5                 --  Min amount of money received from mugging
Config.MaxMoney = 100               --  Max amount of money received from mugging.
Config.RobWaitTime = 5              --  Current seconds it takes to finish mugging
Config.AddItemsPerctent = 20        --  This is percent the script will add items as well as cash from mugging set to 0 to turn off.
Config.AddItemsMax = 3              --  This is the max number of items you can receive from NPC from mugging - min is 1
Config.CoolDownTime = 30            --  This is time between mugging NPC in seconds. Setting to 0 will turn off cooldown.

Config.PoliceNotify = 40            --  This is percent the police will get notified: example: 40 means 40% chance of notification.
Config.AlwaysNotifyonDeath = true   --  This will set to 100% notify if NPC dies while someone is mugging them.
Config.MustUseVoice = false          --  With this on, the player must be speaking in game when trying to much someone or the npc will ignore.  


Config.giveableItems = {
      'water',
      'bread'
  }
