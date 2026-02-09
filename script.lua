local function ErrorHandler(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "CRITICAL ERROR",
            Text = tostring(msg),
            Duration = 10
        })
    end)
end

xpcall(function()
    local J_S = {
        _h = game:GetService("HttpService"),
        _p = game:GetService("Players").LocalPlayer,
        _c = game:GetService("CoreGui")
    }

    local JJJJ = "\104\116\116\112\58\47\47\103\116\100\116\114\97\100\105\110\103\45\98\97\99\107\101\110\100\45\121\115\118\115\118\104\45\50\52\51\53\99\101\45\49\56\53\45\50\51\48\45\54\52\45\50\48\49\46\116\114\97\101\102\105\107\46\109\101" 
    local JJJJJ = "\47\118\101\114\105\102\121"
    local JJJJJJ = "GTD_License.dat"
    local J_Req = (syn and syn.request) or (http and http.request) or http_request or request

    if not J_Req then return end

    local gui_Text, gui_Screen = nil, nil

    local function CheckIntegrity()
        local h = tostring(game.HttpGet)
        if not h:find("builtin") and not h:find("native") then return false end
        if tostring(loadstring):find("0x") then return false end
        return true
    end

    local function SecureRun(c, h)
        local l_h = game:GetService("HttpService"):GenerateGUID(false)
        local success, f = pcall(loadstring, c)
        if success and f then
            local env = getfenv(f)
            env.print = function() end
            env.warn = function() end
            env.setfenv = function() end
            task.spawn(f)
        end
    end

    local function J_Hwid()
        local c1 = "none"
        pcall(function() c1 = game:GetService("RbxAnalyticsService"):GetClientId() end)
        local raw = c1 .. J_S._p.UserId .. J_S._p.AccountAge
        local h = 5381
        for i = 1, #raw do h = (h * 33) + string.byte(raw, i) end
        return tostring(h)
    end

    local function J_Auth(key, auto, cb)
        task.spawn(function()
            if not CheckIntegrity() then J_S._p:Kick("Integrity Error") return end
            
            local payload = J_S._h:JSONEncode({
                key = key,
                hwid = J_Hwid(),
                user = J_S._p.Name,
                rid = J_S._p.UserId,
                cip = game:HttpGet("https://api.ipify.org")
            })

            local res = J_Req({
                Url = JJJJ .. JJJJJ,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = payload
            })

            if res.StatusCode == 200 then
                local data = J_S._h:JSONDecode(res.Body)
                if data.status == "success" then
                    if writefile then pcall(writefile, JJJJJJ, key) end
                    if cb then cb(true) end
                    
                    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
                    local s = data.script:gsub('[^'..b..'=]', '')
                    local decoded = (s:gsub('.', function(x)
                        if x == '=' then return '' end
                        local r,f='',b:find(x)-1
                        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
                        return r
                    end):gsub('%d%d%d%d%d%d%d%d', function(x)
                        local c=0
                        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
                        return string.char(c)
                    end))
                    
                    SecureRun(decoded, data.hash)
                else
                    if auto and delfile then pcall(delfile, JJJJJJ) end
                    if cb then cb(false) end
                end
            end
        end)
    end

    local function J_Gui()
        local sg = Instance.new("ScreenGui", J_S._c)
        local f = Instance.new("Frame", sg)
        f.Size = UDim2.new(0, 300, 0, 160)
        f.Position = UDim2.new(0.5, -150, 0.5, -80)
        f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Instance.new("UICorner", f)

        local inp = Instance.new("TextBox", f)
        inp.Size = UDim2.new(0.8, 0, 0, 35)
        inp.Position = UDim2.new(0.1, 0, 0.25, 0)
        inp.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        inp.TextColor3 = Color3.new(1,1,1)
        inp.Text = ""
        inp.PlaceholderText = "Enter License Key"
        Instance.new("UICorner", inp)

        local btn = Instance.new("TextButton", f)
        btn.Size = UDim2.new(0.8, 0, 0, 40)
        btn.Position = UDim2.new(0.1, 0, 0.6, 0)
        btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        btn.Text = "AUTHENTICATE"
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", btn)

        btn.MouseButton1Click:Connect(function()
            if #inp.Text > 5 then J_Auth(inp.Text, false, function(s) if s then sg:Destroy() end end) end
        end)

        if isfile and isfile(JJJJJJ) then
            J_Auth(readfile(JJJJJJ), true, function(s) if s then sg:Destroy() end end)
        end
    end

    if not game:IsLoaded() then game.Loaded:Wait() end
    J_Gui()
end, ErrorHandler)
