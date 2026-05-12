using b1;
using B1UI;
using ReadyM.Api.Command;
using UnrealEngine.Engine;
using UnrealEngine.Runtime;
using WukongMp.Api.WukongUtils;
using WukongMp.Coop.Configuration;
using WukongMp.Sdk.Api;

namespace WukongMp.Coop.Commands;

public static class CoopCommandRegistrations
{
    public static void RegisterCommands(IWukongConsoleApi consoleApi)
    {
        consoleApi.AddCommand("cutscene", ConsoleCommand.Create(PlayCutscene, true));
        consoleApi.AddCommand("teleport", ConsoleCommand.Create(Teleport, true));
        consoleApi.AddCommand("openlevel", ConsoleCommand.Create(OpenLevel, true));
        consoleApi.AddCommand("bosshp", ConsoleCommand.Create(CustomScaling, false));
    }

    private static void CustomScaling(float scale = 0.0f)
    {
        var owner = WukongApi.Sync.IsMasterClient;

        var areaPlayers = WukongApi.Sync.AreaPlayers.Count;
        
        if (!owner)
        {
            WukongApi.Chat.ShowLocalMessage("Only the host can set boss HP scaling.", FLinearColor.OrangeRed);
            return;
        }
        if (scale < 0f)
        {
            WukongApi.Chat.ShowLocalMessage($"Boss HP scaling modifier is invalid.", FLinearColor.OrangeRed);
            return;
        }
        WukongApi.Chat.ShowLocalMessage($"When Player joins co-op Boss HP will be increased by {scale * 100}%. Current Boss HP : {100 + scale * 100 * (areaPlayers - 1)}%.", FLinearColor.Orange);
        Config.BossHPScaling = scale;
    }

    private static void PlayCutscene(int seqId)
    {
        GSG.GMSvc.GMTeleportToTargetSequence(seqId);
    }

    private static void Teleport(int birthPointId)
    {
        BPS_EventCollectionCS.Get(GameUtils.GetControlledPawn()?.PlayerState).Evt_BPS_TeleportTo.Invoke(
            ETeleportTypeV2.RebirthPointTeleportOnly,
            new TeleportParam_RebirthPoint { RebirthPointId = birthPointId },
            EPlayerTeleportReason.RebirthPoint);
    }

    private static void OpenLevel(string name)
    {
        UGameplayStatics.OpenLevel(GameUtils.GetWorld(), new FName(name));
    }
}