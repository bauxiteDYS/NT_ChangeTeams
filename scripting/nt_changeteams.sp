#include <sourcemod>
#include <sdktools>

#include <neotokyo>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
	name = "NT Team join chat commands",
	description = "Use !s, !j, !n, command to join Spectator, Jinrai and NSF teams respectively",
	author = "bauxite",
	version = "1.0.1",
	url = "https://discord.gg/afhZuFB9A5",
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_j", Cmd_Switch);
	RegConsoleCmd("sm_n", Cmd_Switch);
	RegConsoleCmd("sm_s", Cmd_Switch);
}

// For a case-insensitive input character c, return the matching
// client index such that:
// 'j' == TEAM_JINRAI, 'n' == TEAM_NSF, 's' == TEAM_SPECTATOR.
// Anything else will return TEAM_NONE.
int GetTeamOfChar(char c)
{
	switch (CharToLower(c))
	{
		case 'j': return TEAM_JINRAI;
		case 'n': return TEAM_NSF;
		case 's': return TEAM_SPECTATOR;
		default: return TEAM_NONE;
	}
}

public Action Cmd_Switch(int client, int args)
{
	if (client == 0)
	{
		ReplyToCommand(client, "This command cannot be used by the server.");
		return Plugin_Handled;
	}

	char cmd_name[4 + 1];
	GetCmdArg(0, cmd_name, sizeof(cmd_name));

	char team_char = cmd_name[3];
	int requested_team = GetTeamOfChar(team_char);
	if (requested_team == TEAM_NONE)
	{
		ThrowError("Unknown team for cmd: \"%s\"", cmd_name);
	}

	int current_team = GetClientTeam(client);

	if (current_team == requested_team)
	{
		return Plugin_Handled;
	}

	if (IsPlayerAlive(client))
	{
		KillWithoutXpLoss(client);
	}

	FakeClientCommand(client, "jointeam %d", requested_team);

	return Plugin_Handled;
}

void KillWithoutXpLoss(int client)
{
	int xp = GetPlayerXP(client);
	FakeClientCommand(client, "kill");
	SetPlayerXP(client, xp);
}