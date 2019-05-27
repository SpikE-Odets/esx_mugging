# esx_mugging

This script will allow anyone other then police to mug locals on a server.
This was based off https://github.com/D3uxx/esx_robnpc with a few improvments.


-- Requires --
ESX_Jobs
ESX_Policejobs



Features:

	Can Mug any local you are with-in 5.0m
 	Will recive random amount from Config.MinMoney to  Config.MaxMoney -  default is 5 - 100
	Can set Police Notify Percentage - default is set to 40%
	Can set Always Notify on death -  This will always notify Police of Murder if NPC is killed during mugging.  Once they start running the script will not notify if you kill them.
	Must have Weapon that is not from melee/explosive catagory to start a mugging.
	If you aim at a vehicle that is moving at all (even being pushed) the NPC will ignore the mugging script and act as the game dictates.
	If you aim at a drive of a stopped vehicle the driver will exit the vehicle and put hands up you can then start the mugging.
	Player can stop same NPC but if that npc is last one mugged will not be able to mug again.
	Police Notification gives Alert as well as Circle that will slowly vanish over time (default is 250 seconds - not in Config.lua with this version)
  


This is my first Scrpt for FiveM using Lua. I am sure someone with more experiece can trim down the code to make it more streamlined.
I have tested this on a local hosted ESX server as well as a server that I play on. 

If anyoone has any questions feel free to send me message

SpikE
