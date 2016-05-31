-- Routines for validating Unit blueprints.
--
-- The validation engine will invoke validators in the given order on each blueprint of a given type.
-- If a validator fails, subsequent validators are not called for that blueprint, but processing of
-- other blueprints continues. This means that validators may assume all validators before them did
-- pass.

--- A validator to ensure all required fields are present.
RequiredFields = function(bp, Error, Warning)
    -- TODO: What _is_ the set of required fields for a unit blueprint to make sense?
    local required_fields = {
        'Categories',
        'Description',
        'Interface',
        'Description',
        'General'
    }

    for _, f in pairs(required_fields) do
        if bp[f] == nil then
            Error("Missing required field: " .. f)
        end
    end
end

--- A validator to ensure all blacklisted fields are absent.
BlacklistedFields = function(bp, Error, Warning)
    -- TODO: I assume there are some of these...
    local blacklisted_fields = {
    }

    for f, reason in pairs(blacklisted_fields) do
        if bp[f] ~= nil then
            Error("Blacklisted field present: " .. f .. " ")
        end
    end
end

--- A validator that warns if a category is specified more than once.
CategoryDuplication = function(bp, Error, Warning)
    local cats = bp['Categories']
end


--- Require that all UI-exposed strings in the blueprint have localisation tags.
Localisation = function(bp, Error, Warning)
    -- Strings to check for LOC tags.
    local strings_to_check = {
        Description = bp['Description'],
        HelpText = bp['Interface']['HelpText'],
        UnitName = bp['General']['UnitName'],
    }

    -- Ability names (which are permitted to be absent)
    if bp['Display'] and bp['Display']['Abilities'] then
        for i, ability in ipairs(bp['Display']['Abilities']) do
            strings_to_check["Ability " .. i] = ability
        end
    end

    -- Weapon names (which are permitted to be absent)
    if bp['Weapon'] then
        for i, weapon in ipairs(bp['Weapon']) do
            strings_to_check["Weapon " .. i] = weapon['DisplayName']
        end
    end

    -- Check they all begin with "<LOC something>".
    -- TODO: Perhaps also check that this LOC key is valid.
    for k, s in pairs(strings_to_check) do
        local start, _ = string.find(s, "<LOC [%w_-]+>")

        if start ~= 1 then
            Warning("UI-visible string was not localised: " .. k)
        end
    end
end

return {
    RequiredFields,
    BlacklistedFields,
    CategoryDuplication,
    Localisation
}
