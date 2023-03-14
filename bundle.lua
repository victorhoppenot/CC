function getBundle(direction)
    return {
        white = rs.testBundledInput(direction, colors.white),
        orange = rs.testBundledInput(direction, colors.orange),
        magenta = rs.testBundledInput(direction, colors.magenta),
        lightBlue = rs.testBundledInput(direction, colors.lightBlue),
        yellow = rs.testBundledInput(direction, colors.yellow),
        lime = rs.testBundledInput(direction, colors.lime),
        pink = rs.testBundledInput(direction, colors.pink),
        gray = rs.testBundledInput(direction, colors.gray),
        lightGray = rs.testBundledInput(direction, colors.lightGray),
        cyan = rs.testBundledInput(direction, colors.cyan),
        purple = rs.testBundledInput(direction, colors.purple),
        blue = rs.testBundledInput(direction, colors.blue),
        brown = rs.testBundledInput(direction, colors.brown),
        green = rs.testBundledInput(direction, colors.green),
        red = rs.testBundledInput(direction, colors.red),
        black = rs.testBundledInput(direction, colors.black)
    }
end

function enableBundle(direction, color)
    rs.setBundledOutput(direction, colors.combine(rs.getBundledOutput(direction), color))
end

function disableBundle(direction, color)
    rs.setBundledOutput(direction, colors.subtract(rs.getBundledOutput(direction), color))
end

function clearBundle(direction)
    rs.setBundledOutput(direction, colors.black)
    disableBundle(direction, colors.black)
end


function setValueBundle(direction, color, value)
    if value then
        enableBundle(direction, color)
    else
        disableBundle(direction, color)
    end
end

function Output:new(direction, color, onValue)
    local self = {}
    setmetatable(self, Output)
    self.direction = direction
    self.color = color
    self.onValue = onValue
    self.value = false -- default to off
    setValueBundle(self.direction, self.color, not self.onValue)
end

function Output:on()
    self.value = true
    setValueBundle(self.direction, self.color, self.onValue)
end

function Output:off()
    self.value = false
    setValueBundle(self.direction, self.color, not self.onValue)
end

function Output:setValue(val)
    self.value = val
    if self.value then
        self:on()
    else
        self:off()
    end
end

function Output:toggle()
    self.value = not self.value
    if self.value then
        self:on()
    else
        self:off()
    end
end

function Input:new(direction, color)
    local self = {}
    setmetatable(self, Input)
    self.direction = direction
    self.color = color
end

function Input:isOn()
    return rs.testBundledInput(self.direction, self.color)
end

function Input:isOff()
    return not self:isOn()
end

function Input:waitOn()
    while self:isOff() do
        os.sleep(0.05)
    end
end

function Input:waitOff()
    while self:isOn() do
        os.sleep(0.05)
    end
end

function Input:waitChange()
    local lastState = self:isOn()
    while self:isOn() == lastState do
        os.sleep(0.05)
    end
end
