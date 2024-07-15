local part = script.Parent
part.Touched:Connect(function(hit)
    local player = game.Players:GetPlayerFromCharacter(hit.Parent)
    if player then
        player.Humanoid.Health -= 100
    end
end)