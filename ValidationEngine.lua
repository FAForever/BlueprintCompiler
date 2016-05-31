local ValidationEngine = {}


function ValidationEngine.Validate(bp, source, validators)

    local errors = false
    local function Error(s)
        print("\nError in " .. source ..":")
        print(s)

        errors = true
    end

    local function Warning(s)
        print(s)

    end


    for _, validator in pairs(validators) do
        errors = false
        validator(bp, Error, Warning)
        if errors then
            break
        end
    end

end

return ValidationEngine
