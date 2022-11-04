local Translations = {
    success = {
        success_chop = "Successfully Chopped Vehicle",
    },
    error = {
        cancel_message = "Cancelled",
    },
    general = {
        scrap_vehicle = "Chop Vehicle"
    },
    info = {
        scrap_zone = "Vehicle Chopping",
        drop_off_door = "Recycle Car Door"
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})