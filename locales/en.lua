local Translations = {
    success = {
        success_chop = "Successfully Chopped Vehicle",
    },
    error = {
        cancel_message = "Cancelled",
    },
    general = {
        scrap_vehicle = "Chopping Vehicle"
    },
    info = {
        scrap_zone = "Vehicle Chopping"
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})