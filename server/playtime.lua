function getHoursIdentifier(identifier)
    local playtime = MySQL.Sync.fetchScalar("SELECT playtime FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
    if playtime == nil then return 0 end
    if playtime >= 0 then
        return playtime
    else
        return 0
    end
end

function getLastSeen(identifier)
    local last_seen = MySQL.Sync.fetchScalar("SELECT last_seen FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
    local timestamp_s = last_seen / 1000  -- Convert milliseconds to seconds
    local formatted_date = os.date("%d/%b/%Y", timestamp_s)
    return formatted_date
end