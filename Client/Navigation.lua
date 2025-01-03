Events.SubscribeRemote("NACT:NAVIGATION:QUERY", function(iNpcID, vStart, vEnd)
    Events.CallRemote("NACT:NAVIGATION:RESULT", iNpcID, Navigation.FindPathToLocation(vStart, vEnd))
end)
