--[[ Vec3.lua
https://github.com/tylerneylon/apanga-mac
A class to make it easier to work with 3-vectors.
I'll try to make this class a bit like the built-in string module, which can be
used either as an independent module, or called as methods on strings.
--]] local Vec3 = {}

-- Internal functions.

function vectorize_if_regular_table(t)
    if getmetatable(t) == nil then
        Vec3.__index = Vec3
        setmetatable(t, Vec3)
    end
            return t
end

-- Public functions.

-- This may be called with either params x, y, z, or with a single table
-- containing the {x, y, z} values.
function Vec3:new(x, y, z)
    local v = {x, y, z}
    if type(x) == 'table' then
        v = {x[1], x[2], x[3]} -- It would be bad form to steal x itself as v.
    end
    self.__index = self
    return setmetatable(v, self)
end

function Vec3:length() return math.sqrt(self[1] ^ 2 + self[2] ^ 2 + self[3] ^ 2) end

function Vec3:distance(other)
    local d = {}
    for i = 1, 3 do d[i] = self[i] - other[i] end
    return math.sqrt(d[1] ^ 2 + d[2] ^ 2 + d[3] ^ 2)
end

function Vec3:normalize()
    local len = Vec3.length(self) -- self is not guaranteed to be a Vec3.
    for i = 1, 3 do self[i] = self[i] / len end
    return vectorize_if_regular_table(self)
end

function Vec3:dot(other)
    if type(other) ~= 'table' then
        -- Error level 2 indicates this is the caller's fault.
        error('Expected 2nd arg to be a vector', 2)
    end

    local a, b = self, other
    return a[1] * b[1] + a[2] * b[2] + a[3] * b[3]
end

function Vec3:cross(other)
    if type(other) ~= 'table' then
        -- Error level 2 indicates this is the caller's fault.
        error('Expected 2nd arg to be a vector', 2)
    end

    local a, b = self, other
    return Vec3:new(a[2] * b[3] - a[3] * b[2], a[3] * b[1] - a[1] * b[3],
                    a[1] * b[2] - a[2] * b[1])
end

-- This returns some unit vector orthogonal to self.
-- It's deterministic and shouldn't be considered random.
function Vec3:orthogonal_dir()
    local other_dir
    -- Choose other_dir not too close to a.
    if self[1] > self[2] then
        other_dir = Vec3:new(0, 1, 0)
    else
        other_dir = Vec3:new(1, 0, 0)
    end
    return self:cross(other_dir):normalize()
end

function Vec3:__add(other)
    local a, b = self, other
    return Vec3:new(a[1] + b[1], a[2] + b[2], a[3] + b[3])
end

function Vec3:__sub(other)
    if type(self) ~= 'table' then
        -- Error level 2 indicates this is the caller's fault.
        error('Expected 1st arg to be a vector', 2)
    end
    if type(other) ~= 'table' then
        -- Error level 2 indicates this is the caller's fault.
        error('Expected 2nd arg to be a vector', 2)
    end
    local a, b = self, other
    return Vec3:new(a[1] - b[1], a[2] - b[2], a[3] - b[3])
end

function Vec3:__mul(other)
    if getmetatable(self) == Vec3 and type(other) == 'number' then
        return Vec3:new(self[1] * other, self[2] * other, self[3] * other)
    elseif type(self) == 'number' and getmetatable(other) == Vec3 then
        return Vec3:new(self * other[1], self * other[2], self * other[3])
    else
        -- Error level 2 indicates this is the caller's fault. Which it is.
        error('Unexpected case: Vec3 mult without a Vec3!', 2)
    end
end

function Vec3:__div(other)
    if getmetatable(self) == Vec3 and type(other) == 'number' then
        return Vec3:new(self[1] / other, self[2] / other, self[3] / other)
    else
        -- Error level 2 indicates this is the caller's fault. Which it is.
        error('Expected Vec3 to be divided by a number.', 2)
    end
end

-- This is a convenient way to achieve something like self = other, but without
-- changing the identity of self; it also implicitly promotes tables to Vec3s.
function Vec3:set(other)
    for i = 1, 3 do self[i] = other[i] end
    return vectorize_if_regular_table(self)
end

function Vec3:as_str()
    return string.format('(%g, %g, %g)', self[1], self[2], self[3])
end

function Vec3:has_nan()
    for i = 1, 3 do if self[i] ~= self[i] then return true end end
    return false
end

return Vec3
