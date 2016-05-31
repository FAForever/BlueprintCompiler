local FaCompat = require('utils/facompat')

local UnitValidators = require('validation/Unit')
local BeamValidators = require('validation/Beam')
local EmitterValidators = require('validation/Emitter')
local MeshValidators = require('validation/Mesh')
local ProjectileValidators = require('validation/Projectile')
local TrailEmitterValidators = require('validation/TrailEmitter')
local PropValidators = require('validation/Prop')

local ValidationEngine = require('ValidationEngine')

local Blueprints = {}

-- Blueprints are just Lua scripts that call functions.
-- To "load" a blueprint, you just execute it in an environment that defines these functions.
-- For our purposes, we wish to enforce invariants on blueprints and perform as much of their
-- loading at compile time as possible.



--- Load a GPG Lua file as proper Lua we can actually run.
function getProperLua(filename)
    -- Do string manipulation to handle GPG-lua.
    local str = ""
    for l in io.lines(filename) do
        -- Fix GPG-style comments. (GPG does not do the #table thing from normal lua, so this is ok)
        l = string.gsub(l, '#', '--')

        -- Fix GPG-style inequality
        l = string.gsub(l, '!=', '~=')

        str = str .. l .. '\n'
    end

    return str
end

--- Construct an environment for running blueprints in.
function getBlueprintEnvironment(sourcefile)
    -- Used for error reporting.
    local source = sourcefile

    return {
        loadstring = loadstring,

        Sound = function() end,

        MeshBlueprint = function(bp)
            ValidationEngine.Validate(bp, source, MeshValidators)
        end,

        UnitBlueprint = function(bp)
            ValidationEngine.Validate(bp, source, UnitValidators)
        end,

        PropBlueprint = function(bp)
            ValidationEngine.Validate(bp, source, PropValidators)
        end,

        ProjectileBlueprint = function(bp)
            ValidationEngine.Validate(bp, source, ProjectileValidators)
        end,

        TrailEmitterBlueprint = function(bp)
            ValidationEngine.Validate(bp, source, TrailEmitterValidators)
        end,

        EmitterBlueprint = function(bp)
            ValidationEngine.Validate(bp, source, EmitterValidators)
        end,

        BeamBlueprint = function(bp)
            ValidationEngine.Validate(bp, source, BeamValidators)
        end
    }

end

--- Load all the blueprints from the given directory.
-- @param bpdir
--
function Blueprints.LoadBlueprints(bpdir)
    -- TODO: GPG-compatible escapes.
    local files = FaCompat.DiskFindFiles(bpdir, '\\*.bp')

    for _, f in pairs(files) do
        -- Set up a suitable environment for the blueprint: we capture the source information in the
        -- closures it runs.
        load(getProperLua(f), f, "t", getBlueprintEnvironment(f))()
    end
end


return Blueprints

