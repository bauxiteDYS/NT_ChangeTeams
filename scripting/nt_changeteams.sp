#include <sourcemod>
#include <sdktools>

#pragma semicolon 1

#define TEAM_SPEC 1
#define TEAM_JINRAI 2 
#define TEAM_NSF 3

public Plugin:myinfo = {
	name = "NT Team join chat commands",
	description = "Use !s, !j, !n, command to join Spectator, Jinrai and NSF teams respectively",
	author = "bauxite",
	version = "1.0",
	url = "https://discord.gg/afhZuFB9A5",
}

public OnPluginStart()
{
	RegConsoleCmd("sm_j", Switch_Jinrai);
	RegConsoleCmd("sm_n", Switch_NSF);
	RegConsoleCmd("sm_s", Switch_Spec);
}

public Action:Switch_Jinrai(client, args)
{	
	if(IsClientValid(client)) 
	{
		new team = GetClientTeam(client);

		if(team != TEAM_JINRAI && ! IsPlayerAlive(client))
		{
			FakeClientCommand(client, "jointeam 2");
		}

		if(IsPlayerAlive(client) && team != TEAM_JINRAI && team != TEAM_SPEC)  
		{
			FakeClientCommand(client, "kill"); FakeClientCommand(client, "jointeam 2");
		}
	}
	
	return Plugin_Handled;
}

public Action:Switch_NSF(client, args)
{
	if(IsClientValid(client))
	{
		new team = GetClientTeam(client);
		
		if(team != TEAM_NSF && ! IsPlayerAlive(client))
		{
			FakeClientCommand(client, "jointeam 3");
		}

		if(IsPlayerAlive(client) && team != TEAM_NSF && team != TEAM_SPEC) 
		{
			FakeClientCommand(client, "kill"); FakeClientCommand(client, "jointeam 3");
		}
	}
	
	return Plugin_Handled;
}

public Action:Switch_Spec(client, args)
{	
	if(IsClientValid(client))
	{
		new team = GetClientTeam(client);
		
		if(team != TEAM_SPEC && ! IsPlayerAlive(client))
		{
			FakeClientCommand(client, "jointeam 1");	
		}

		if(IsPlayerAlive(client) && team != TEAM_SPEC)  
		{
			FakeClientCommand(client, "kill"); FakeClientCommand(client, "jointeam 1");
		}
	}
	
	return Plugin_Handled;
}

stock bool:IsClientValid(i)
{
	if(i > 0 && i <= MaxClients && IsClientInGame(i))
	{
		return true;
	}
	
	return false;
}
