Events.SubscribeRemote("NACT:NAVIGATION:RANDOM_QUERY", function(iNpcID, vPoint, radius)
    Events.CallRemote("NACT:NAVIGATION:RANDOM_RESULT", iNpcID, Navigation.GetRandomReachablePointInRadius(vPoint, radius))
end)
