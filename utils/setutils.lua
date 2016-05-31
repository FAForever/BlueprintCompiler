-- Let table t = {k_1 = v_1, k_2 = v_2, ..., k_n = v_n} represent the set S.(∀s ∈ S ∃ k ∈ t.(v = true)).
--
-- Utility functions for working with this type of set.

local SetUtils = {}

function SetUtils.FromList(l)
    local set = {}

    for _, e in l do
        set[e] = true
    end

    return set
end

--- Returns a ∪ b as a new set
function SetUtils.Union(a, b)
    local u = {}

    table.print(a)
    table.print(b)

    for k, v in a do
        u[k] = v or u[k]
    end

    for k, v in b do
        u[k] = v or u[k]
    end

    return u
end

--- Replaces a with a ∪ b
function SetUtils.DestructiveUnion(a, b)
    for k, v in b do
        a[k] = v or nil
    end

    return a
end

--- Returns a ∩ b as a new set
function SetUtils.Intersection(a, b)
    local i = {}

    for k, v in a do
        if v and b[k] then
            i[k] = true
        end
    end

    for k, v in b do
        if v and a[k] then
            i[k] = true
        end
    end

    return i
end

--- Returns a \ b as a new set
function SetUtils.Subtract(a, b)
    local s = {}

    for k, v in a do
        if v and not b[k] then
            s[k] = true
        end
    end

    return s
end

--- Returns the set S = {a ∈ A.p(a)}
function SetUtils.PredicateFilter(A, p)
    local s = {}

    for k, v in A do
        if v and p(k) then
            s[k] = true
        end
    end

    return s
end

--- Returns true iff A is the empty set
function SetUtils.Empty(A)
    for k, v in A do
        if v then
            return false
        end
    end
    return true
end

return SetUtils
