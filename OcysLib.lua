local args = {...};

if LPH_OBFUSCATED == nil then
    LPH_JIT_MAX = function(...)
        return ...;
    end;
    LPH_ENCSTR = function(...)
        return ...;
    end
end

return LPH_JIT_MAX(function()
    if Ocy == nil or args[1] ~= LPH_ENCSTR("pgwVv3sx0eGBHB9z") then
        return;
    end

    --[[ Variables ]]--

    local coreGui = game:GetService("CoreGui");
    local runService = game:GetService("RunService");
    local httpService = game:GetService("HttpService");
    local textService = game:GetService("TextService");
    local tweenService = game:GetService("TweenService");
    local teleportService = game:GetService("TeleportService");
    local userInputService = game:GetService("UserInputService");
    local guiService = game:GetService("GuiService");

    local localPlayer = game:GetService("Players").LocalPlayer;
    local mouse = localPlayer:GetMouse();

    local inputTypes = { "KeyCode", "UserInputType" };
    local closeOnSwitch = { "SelectedPicker", "SelectedDrop" };
    local characters =  { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" };

    local hugeVec2 = Vector2.new(math.huge, math.huge);

    local ellipsisBindSize = textService:GetTextSize("...", 12, Enum.Font.Gotham, hugeVec2).X + 16;

    local blacklistedKeys = {
        Enum.KeyCode.Unknown
    };

    local whitelistedInputTypes = {
        Enum.UserInputType.MouseButton1,
        Enum.UserInputType.MouseButton2,
        Enum.UserInputType.MouseButton3
    };

    local dualBindKeys = {
        Enum.KeyCode.LeftAlt,
        Enum.KeyCode.LeftControl,
        Enum.KeyCode.LeftShift,
        Enum.KeyCode.RightAlt,
        Enum.KeyCode.RightControl,
        Enum.KeyCode.RightShift,
        Enum.KeyCode.Escape
    };

    local blacklistedErrorMessages = {
        "Lost connection to the game server, please reconnect"
    };

    --[[ Index Optimisations ]]--

    local colorFromHex = Color3.fromHex;
    local colorFromHSV = Color3.fromHSV;
    local colorNew = Color3.new;
    local colorFromRGB = Color3.fromRGB;

    local colorSequenceNew = ColorSequence.new;
    local colorSequenceKeypointNew = ColorSequenceKeypoint.new;

    local fontNew = Font.new;

    local instanceNew = Instance.new;

    local mathClamp = math.clamp;
    local mathFloor = math.floor;
    local mathRandom = math.random;
    local mathRound = math.round;

    local numberSequenceNew = NumberSequence.new;
    local numberSequenceKeypointNew = NumberSequenceKeypoint.new;

    local rectNew = Rect.new;

    local stringFind = string.find;
    local stringFormat = string.format;
    local stringGmatch = string.gmatch;
    local stringLower = string.lower;
    local stringMatch = string.match;

    local tableConcat = table.concat;
    local tableFind = table.find;
    local tableRemove = table.remove;

    local taskCancel = task.cancel;
    local taskSpawn = task.spawn;
    local taskWait = task.wait;

    local tweenInfoNew = TweenInfo.new;

    local udimNew = UDim.new;
    local udim2New = UDim2.new;

    local vector2New = Vector2.new;

    --[[ Namecall Optimisation ]]--

    local toHex = colorNew().ToHex;
    local toHSV = colorNew().ToHSV;

    local createTween = tweenService.Create;
    local playTween = createTween(tweenService, instanceNew("Part"), tweenInfoNew(0), {}).Play;

    local destroy = workspace.Destroy;
    local getChildren = workspace.GetChildren;
    local getPropertyChangedSignal = workspace.GetPropertyChangedSignal;
    local isA = workspace.IsA;

    local getTextBoundsAsync = textService.GetTextBoundsAsync;

    local getEnumItems = Enum.KeyCode.GetEnumItems;

    local jsonDecode = httpService.JSONDecode;
    local jsonEncode = httpService.JSONEncode;

    local waitForSignal = workspace.AncestryChanged.Wait;

    local teleportToPlaceInstance = teleportService.TeleportToPlaceInstance;

    local connect = workspace.AncestryChanged.Connect;
    local disconnect = connect(workspace.AncestryChanged, function() end).Disconnect;

    --[[ Functions ]]--

    local function isKeyValueTable(tab)
        for i, _ in next, tab do
            if type(i) ~= "number" then
                return true;
            end
        end
        return false;
    end

    local function mergeTables(priority, backup)
        if type(backup) == "table" then
            for i, v in next, priority do
                local valueType = type(v);
                local backupValue = backup[i];
                if valueType == type(backupValue) then
                    if valueType == "table" and isKeyValueTable(v) then
                        mergeTables(priority[i], backupValue);
                    else
                        priority[i] = backupValue;
                    end
                end
            end
        end
        return priority;
    end

    local function cloneTable(x)
        local y = {};
        for i, v in next, x do
            y[i] = type(v) == "table" and cloneTable(v) or v;
        end
        return y;
    end

    local function safeParent(obj)
        if syn and syn.protect_gui and not gethui then
            syn.protect_gui(obj);
        end
        obj.Parent = gethui and gethui() or coreGui;
    end

    local function tween(instance, duration, properties, ...)
        local t = createTween(tweenService, instance, tweenInfoNew(duration, ...), properties);
        playTween(t);
        return t;
    end

    local function randomFlag()
        local randomStr = "";
        for _ = 1, 32 do
            randomStr = randomStr .. characters[mathRandom(#characters)];
        end
        return "UnknownFlag|" .. randomStr;
    end

    local function getPrecision(value, float)
        local bracket = 1 / float;
        return mathFloor(value * bracket) / bracket;
    end

    local function autoResize(layout, frame, offset, callback)
        local isCanvas = frame.ClassName == "ScrollingFrame";
        local property = isCanvas and "CanvasSize" or "Size";
        frame[property] = udim2New(0, 0, 0, layout.AbsoluteContentSize.Y);
        connect(getPropertyChangedSignal(layout, "AbsoluteContentSize"), function()
            frame[property] = udim2New(isCanvas and 0 or frame.Size.X.Scale, isCanvas and 0 or frame.Size.X.Offset, 0, layout.AbsoluteContentSize.Y + offset);
            if callback then
                callback();
            end
        end);
    end

    local function splitIndicator(str)
        local store = {};
        for i in stringGmatch(str, "[A-Z][a-z]*") do
            store[#store + 1] = i;
        end
        return tableConcat(store, " ");
    end

    local function isValidEnumItem(enumItem)
        local enumType = enumItem.EnumType;
        if (enumType == Enum.KeyCode and not tableFind(blacklistedKeys, enumItem)) or (enumType == Enum.UserInputType and tableFind(whitelistedInputTypes, enumItem)) then
            return true;
        end
        return false;
    end

    local function getKeyCode(x)
        for i = 1, #inputTypes do
            local enumItems = getEnumItems(Enum[inputTypes[i]]);
            for i2 = 1, #enumItems do
                local v2 = enumItems[i2];
                if v2.Name == x then
                    return v2;
                end
            end
        end
        return false;
    end

    --[[ Configs ]]--

    local ConfigManager = {};
    ConfigManager.__index = ConfigManager;

    function ConfigManager.new(library)
        return setmetatable({
            Library = library
        }, ConfigManager);
    end

    function ConfigManager:Load(name)
        local path = stringFormat("Ocy\\Configs\\%s\\%s.json", self.Library.Title, name);
        if isfile(path) then
            local succ, res = pcall(jsonDecode, httpService, readfile(path));
            if succ then
                for i, v in next, res do
                    local item = self.Library.Items[i];
                    if item and item.Ignore == false then
                        taskSpawn(function()
                            if item.Class == "Picker" then
                                item:ToggleRainbow(v.Rainbow);
                                item:ToggleSync(v.Sync);
                                item:Set(colorFromHex(v.Color), v.Alpha);
                            elseif item.Class == "Dropdown" then
                                local flag = self.Library.Flags[i];
                                for i2 = 1, #flag do
                                    taskSpawn(item.Set, item, flag[i2], false);
                                end
                                for i2 = 1, #v do
                                    taskSpawn(item.Set, item, v[i2], true);
                                end
                            elseif item.Class == "Bind" then
                                local key, dependency = getKeyCode(v.Key), v.Dependency and getKeyCode(v.Dependency);
                                if key and dependency ~= false then
                                    item:Set(key, dependency);
                                end
                            else
                                item:Set(v);
                            end
                        end);
                    end
                end
            end
        end
    end

    function ConfigManager:Save(name)
        local data = cloneTable(self.Library.Flags);
        for i, v in next, data do
            local valueType = typeof(v);
            if self.Library.Items[i].Ignore then
                data[i] = nil;
            elseif valueType == "table" then
                if v.Color then
                    v.Color = toHex(v.Color);
                elseif v.Key then
                    v.Key = v.Key.Name;
                    if v.Dependency then
                        v.Dependency = v.Dependency.Name;
                    end
                end
            end
        end
        writefile(stringFormat("Ocy\\Configs\\%s\\%s.json", self.Library.Title, name), jsonEncode(httpService, data));
    end

    function ConfigManager:Delete(name)
        local path = stringFormat("Ocy\\Configs\\%s\\%s.json", self.Library.Title, name);
        if isfile(path) then
            delfile(path);
        end
    end

    function ConfigManager:Get()
        local configs = {};
        local path = "Ocy\\Configs\\" .. self.Library.Title;
        if isfolder(path) then
            local files = listfiles(path);
            for i = 1, #files do
                local name, ext = stringMatch(files[i], ".*\\(.+)%.(.+)");
                if ext == "json" then
                    configs[#configs + 1] = name;
                end
            end
        end
        return configs;
    end

    --[[ Themes ]]--

    local ThemeManager = {};
    ThemeManager.__index = ThemeManager;

    function ThemeManager.__newindex(self, k, v)
        if self.Data[k] and typeof(v) == "Color3" then
            self.Data[k] = v;
            for i = 1, #self.Store do
                local item = self.Store[i];
                if item.tag == k and (item.check == nil or item.check(k)) then
                    item.instance[item.property] = v;
                end
            end
        end
    end

    function ThemeManager.new(library)
        return setmetatable({
            Data = {
                Foreground = colorFromHex("ffffff"),
                MainBackground = colorFromHex("0e0f13"),
                MainBorder = colorFromHex("323337"),
                SectionBackground = colorFromHex("1c1d21"),
                ItemBackground = colorFromHex("15161a"),
                LeftForeground = colorFromHex("b4b4b4"),
                LeftHighlight = colorFromHex("3c3d41"),
                LeftHighlightForeground = colorFromHex("ffffff"),
                LeftHighlightBorder = colorFromHex("58595d"),
                PlaceholderForeground = colorFromHex("b2b2b2"),
                Accent = colorFromHex("5473d8"),
                Shadow = colorFromHex("000105")
            },
            Library = library,
            Store = {}
        }, ThemeManager);
    end

    function ThemeManager:AddInstance(instance, property, tag, check)
        if self.Data[tag] then
            self.Store[#self.Store + 1] = {
                instance = instance,
                property = property,
                tag = tag,
                check = check
            };
        end
    end

    function ThemeManager:Load(name)
        local path = stringFormat("Ocy\\Themes\\%s.json", name);
        if isfile(path) then
            local succ, res = pcall(jsonDecode, httpService, readfile(path));
            if succ then
                for i, v in next, res do
                    local item = self.Library.Items[i];
                    if item then
                        item:Set(colorFromHex(v), 1);
                    else
                        self[i] = colorFromHex(v);
                    end
                end
            end
        end
    end

    function ThemeManager:Save(name)
        local data = {};
        for i, v in next, self.Data do
            data[i] = toHex(v);
        end
        writefile(stringFormat("Ocy\\Themes\\%s.json", name), jsonEncode(httpService, data));
    end

    function ThemeManager:Delete(name)
        local path = stringFormat("Ocy\\Themes\\%s.json", name);
        if isfile(path) then
            delfile(path);
        end
    end

    function ThemeManager:Get()
        local themes = {};
        if isfolder("Ocy\\Themes") then
            local files = listfiles("Ocy\\Themes");
            for i = 1, #files do
                local name, ext = stringMatch(files[i], ".*\\(.+)%.(.+)");
                if ext == "json" then
                    themes[#themes + 1] = name;
                end
            end
        end
        return themes;
    end

    --[[ Label ]]--

    local Label = {};

    function Label.__index(self, k)
        return Label[k] or self.Options[k];
    end

    function Label.__newindex(self, k, v)
        if k == "Title" then
            self.Frame.title.Text = v;
        elseif k == "Status" then
            if self.Status then
                self.Status.Value = v;
                self.Status.Label.Text = v;
                return;
            end
        elseif k == "Color" then
            if self.Status then
                self.Status.Color = v;
                self.Status.Label.TextColor3 = v;
                return;
            end
        elseif k == "Content" then
            if self.Clipboard then
                self.Clipboard.Content = v;
                return;
            end
        end
        self.Options[k] = v;
    end

    function Label.new(subsection, options)
        local label = setmetatable({ Options = mergeTables({
            Title = "Label",
            Flag = randomFlag(),
            MultiLine = false
        }, options) }, Label);

        local library = subsection.Library;

        label.Frame = library:Create("TextButton", {
            Parent = subsection.Container,
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Size = udim2New(1, 0, 0, 20),
            ZIndex = 2,
            Name = label.Title
        }, {
            library:Create("TextLabel", {
                Tags = {
                    { "TextColor3", "Foreground" }
                },
                FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                FontSize = Enum.FontSize.Size14,
                Text = "",
                TextSize = 13,
                TextWrap = true,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Center,
                AnchorPoint = vector2New(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(0.5, 0, 0.5, 0),
                Size = udim2New(1, -4, 1, -6),
                ZIndex = 2,
                Name = "title"
            })
        });

        if label.MultiLine then
            connect(getPropertyChangedSignal(label.Frame.title, "Text"), function()
                label.Frame.Size = udim2New(1, 0, 0, getTextBoundsAsync(textService, library:Create("GetTextBoundsParams", {
                    Text = label.Title,
                    Font = label.Frame.title.FontFace,
                    Size = label.Frame.title.TextSize,
                    Width = label.Frame.title.AbsoluteSize.X
                })).Y + 6);
            end);
        end
        label.Frame.title.Text = label.Title;

        label.Library = library;
        label.Subsection = subsection;
        label.Class = "Label";

        library.Items[label.Flag] = label;

        return label;
    end

    function Label:AddStatus(options)
        if self.Status or self.Clipboard then
            return;
        end

        self.Status = mergeTables({
            Value = "Status",
            Color = colorFromHex("0aff37"),
        }, options);

        local library = self.Library;

        self.Frame.title.TextXAlignment = Enum.TextXAlignment.Left;

        self.Status.Label = library:Create("TextLabel", {
            Parent = self.Frame,
            FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            FontSize = Enum.FontSize.Size14,
            Text = self.Status.Value,
            TextColor3 = self.Status.Color,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Right,
            AnchorPoint = vector2New(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = udim2New(0.5, 0, 0.5, 0),
            Size = udim2New(1, -4, 1, 0),
            ZIndex = 2,
            Name = "status"
        });

        return self;
    end

    function Label:AddClipboard(options)
        if self.Status or self.Clipboard then
            return;
        end

        self.Clipboard = mergeTables({
            Content = "Content to Copy"
        }, options);

        local library = self.Library;

        self.Frame.Size = udim2New(1, 0, 0, 26);
        self.Frame.title.TextXAlignment = Enum.TextXAlignment.Left;

        self.Clipboard.Button = library:Create("TextButton", {
            Tags = {
                { "BackgroundColor3", "ItemBackground" }
            },
            Parent = self.Frame,
            AnchorPoint = vector2New(1, 0.5),
            Text = "",
            AutoButtonColor = false,
            Position = udim2New(1, -1, 0.5, 0),
            Size = udim2New(0, 24, 1, -2),
            ZIndex = 2,
            Name = "indicator"
        }, {
            library:Create("UICorner", {
                CornerRadius = udimNew(0, 3),
                Name = "corner"
            }),
            library:Create("UIStroke", {
                Tags = {
                    { "Color", "MainBorder" }
                },
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Name = "stroke"
            }),
            library:Create("ImageLabel", {
                Image = "rbxassetid://11335250204",
                AnchorPoint = vector2New(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(0.5, 0, 0.5, 0),
                Size = udim2New(0, 16, 0, 16),
                ZIndex = 2,
                Name = "icon"
            })
        });

        connect(self.Clipboard.Button.MouseButton1Click, function()
            setclipboard(self.Clipboard.Content);
            connect(tween(self.Clipboard.Button, 0.1, { BackgroundColor3 = library.Theme.Data.Accent }).Completed, function()
                tween(self.Clipboard.Button, 0.1, { BackgroundColor3 = library.Theme.Data.ItemBackground });
            end);
        end);

        return self;
    end

    --[[ Button ]]--

    local Button = {};

    function Button.__index(self, k)
        return Button[k] or self.Options[k];
    end

    function Button.__newindex(self, k, v)
        self.Options[k] = v;
    end

    function Button.new(subsection, options)
        local button = setmetatable({ Options = mergeTables({
            Title = "Button",
            Flag = randomFlag(),
            Validate = function()
                return true;
            end,
            Callback = function() end
        }, options) }, Button);

        local library = subsection.Library;

        button.Frame = library:Create("TextButton", {
            Parent = subsection.Container,
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Size = udim2New(1, 0, 0, 26),
            ZIndex = 2,
            Name = button.Title
        }, {
            library:Create("TextButton", {
                Tags = {
                    { "BackgroundColor3", "ItemBackground" },
                    { "TextColor3", "Foreground" }
                },
                FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                FontSize = Enum.FontSize.Size12,
                Text = button.Title,
                TextSize = 12,
                AutoButtonColor = false,
                AnchorPoint = vector2New(0.5, 0.5),
                Position = udim2New(0.5, 0, 0.5, 0),
                Size = udim2New(1, -2, 1, -2),
                ZIndex = 2,
                Name = "button"
            }, {
                library:Create("UICorner", {
                    CornerRadius = udimNew(0, 3),
                    Name = "corner"
                }),
                library:Create("UIStroke", {
                    Tags = {
                        { "Color", "MainBorder" }
                    },
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Name = "stroke"
                })
            });
        });

        connect(button.Frame.button.MouseButton1Click, function()
            button.Frame.button.TextSize = 0;
            tween(button.Frame.button, 0.25, { TextSize = 12 });
            if button.Validate() then
                button.Callback();
            end
        end);

        button.Library = library;
        button.Subsection = subsection;
        button.Class = "Button";

        library.Items[button.Flag] = button;

        return button
    end

    function Button:Call(...)
        if self.Validate() then
            return self.Callback(...);
        end
    end

    --[[ Toggle ]]--

    local Toggle = {};

    function Toggle.__index(self, k)
        return Toggle[k] or self.Options[k];
    end

    function Toggle.__newindex(self, k, v)
        self.Options[k] = v;
    end

    function Toggle.new(subsection, options)
        local toggle = setmetatable({ Options = mergeTables({
            Title = "Toggle",
            Flag = randomFlag(),
            Value = false,
            Ignore = false,
            Validate = function()
                return true;
            end,
            Callback = function() end
        }, options) }, Toggle);

        local library = subsection.Library;

        toggle.Frame = library:Create("TextButton", {
            Parent = subsection.Container,
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Size = udim2New(1, 0, 0, 26),
            ZIndex = 2,
            Name = toggle.Title
        }, {
            library:Create("Frame", {
                Tags = {
                    { "BackgroundColor3", "ItemBackground", function()
                        return not toggle.Value;
                    end },
                    { "BackgroundColor3", "Accent", function()
                        return toggle.Value;
                    end }
                },
                AnchorPoint = vector2New(1, 0.5),
                Position = udim2New(1, -1, 0.5, 0),
                Size = udim2New(0, 24, 0, 24),
                ZIndex = 2,
                Name = "indicator"
            }, {
                library:Create("UIStroke", {
                    Tags = {
                        { "Color", "MainBorder" }
                    },
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Name = "stroke"
                }),
                library:Create("UICorner", {
                    CornerRadius = udimNew(0, 3),
                    Name = "corner"
                }),
                library:Create("ImageLabel", {
                    Image = "rbxassetid://10190496906",
                    ImageTransparency = 1,
                    AnchorPoint = vector2New(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = udim2New(0.5, 0, 0.5, 0),
                    Size = udim2New(0, 20, 0, 20),
                    ZIndex = 2,
                    Name = "icon"
                })
            }),
            library:Create("TextLabel", {
                Tags = {
                    { "TextColor3", "Foreground" }
                },
                FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                FontSize = Enum.FontSize.Size14,
                Text = toggle.Title,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = vector2New(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(0.5, 0, 0.5, 0),
                Size = udim2New(1, -4, 1, 0),
                ZIndex = 2,
                Name = "title"
            })
        });

        connect(toggle.Frame.MouseButton1Click, function()
            toggle:Set(not toggle.Value);
        end);

        toggle.Library = library;
        toggle.Subsection = subsection;
        toggle.Class = "Toggle";

        library.Flags[toggle.Flag] = false;
        library.Items[toggle.Flag] = toggle;
        if toggle.Value then
            toggle:Set(toggle.Value);
        end

        return toggle;
    end

    function Toggle:Set(value)
        if self.Validate(value) then
            tween(self.Frame.indicator, 0.25, { BackgroundColor3 = self.Library.Theme.Data[value and "Accent" or "ItemBackground"] });
            tween(self.Frame.indicator.icon, 0.25, { ImageTransparency = value and 0 or 1 });
            self.Value = value;
            self.Library.Flags[self.Flag] = value;
            self.Callback(value);
        end
    end

    --[[ Selection ]]--

    local Selection = {};

    function Selection.__index(self, k)
        return Selection[k] or self.Options[k];
    end

    function Selection.__newindex(self, k, v)
        self.Options[k] = v;
    end

    function Selection.new(subsection, options)
        local selection = setmetatable({ Options = mergeTables({
            Title = "Selection",
            Flag = randomFlag(),
            Value = "",
            Buttons = {},
            Ignore = false,
            Validate = function()
                return true;
            end,
            Callback = function() end
        }, options) }, Selection);

        local library = subsection.Library;

        selection.Available = {};
        selection.Value = tableFind(selection.Buttons, selection.Value) and selection.Value or selection.Buttons[1];
        selection.Frame = library:Create("TextButton", {
            Parent = subsection.Container,
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Size = udim2New(1, 0, 0, 26),
            ZIndex = 2,
            Name = selection.Title
        }, {
            library:Create("Frame", {
                AnchorPoint = vector2New(1, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(1, 0, 0.5, 0),
                Size = udim2New(0, 129, 1, 0),
                ZIndex = 2,
                Name = "container"
            }, {
                library:Create("UIListLayout", {
                    Padding = udimNew(0, 6),
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Name = "list"
                }),
                library:Create("UIPadding", {
                    PaddingBottom = udimNew(0, 1),
                    PaddingLeft = udimNew(0, 1),
                    PaddingRight = udimNew(0, 1),
                    PaddingTop = udimNew(0, 1),
                    Name = "padding"
                })
            }),
            library:Create("TextLabel", {
                Tags = {
                    { "TextColor3", "Foreground" }
                },
                FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                FontSize = Enum.FontSize.Size14,
                Text = selection.Title,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = vector2New(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(0.5, 0, 0.5, 0),
                Size = udim2New(1, -4, 1, 0),
                ZIndex = 2,
                Name = "title"
            })
        });

        for i = 1, #selection.Buttons do
            local name = selection.Buttons[i];

            local button = library:Create("TextButton", {
                Tags = {
                    { "BackgroundColor3", "ItemBackground", function()
                        return selection.Value ~= name;
                    end },
                    { "BackgroundColor3", "Accent", function()
                        return selection.Value == name;
                    end },
                    { "TextColor3", "Foreground" }
                },
                Parent = selection.Frame.container,
                FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                FontSize = Enum.FontSize.Size14,
                Text = name,
                TextSize = 13,
                AutoButtonColor = false,
                Size = udim2New(0, 0, 1, 0),
                ZIndex = 2,
                Name = name
            }, {
                library:Create("UICorner", {
                    CornerRadius = udimNew(0, 3),
                    Name = "corner"
                }),
                library:Create("UIStroke", {
                    Tags = {
                        { "Color", "MainBorder" }
                    },
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Name = "stroke"
                })
            });

            button.Size = udim2New(0, getTextBoundsAsync(textService, library:Create("GetTextBoundsParams", {
                Text = name,
                Font = button.FontFace,
                Size = 14,
                Width = math.huge
            })).X + 14, 1, 0);

            connect(button.MouseButton1Click, function()
                selection:Set(name);
            end);

            selection.Available[name] = button;
        end

        selection.Library = library;
        selection.Subsection = subsection;
        selection.Class = "Selection";

        library.Flags[selection.Flag] = selection.Value;
        library.Items[selection.Flag] = selection;
        selection:Set(selection.Value);

        return selection
    end

    function Selection:Set(value)
        if self.Validate(value) then
            local btn = self.Button;
            if btn then
                if self.Value == value then
                    return self
                end
                tween(btn, 0.25, { BackgroundColor3 = self.Library.Theme.Data.ItemBackground });
            end

            local button = self.Available[value];
            if button then
                tween(button, 0.25, { BackgroundColor3 = self.Library.Theme.Data.Accent });
                self.Button = button;
                self.Value = value;
                self.Library.Flags[self.Flag] = value;
                self.Callback(value);
            end
        end
    end

    --[[ Bind ]]--

    local Bind = {};

    function Bind.__index(self, k)
        return Bind[k] or self.Options[k];
    end

    function Bind.__newindex(self, k, v)
        self.Options[k] = v;
    end

    function Bind.new(subsection, options)
        local bind = setmetatable({ Options = mergeTables({
            Title = "Bind",
            Flag = randomFlag(),
            Value = {
                Key = Enum.KeyCode.Escape,
                Dependency = Enum.KeyCode.Escape
            },
            Ignore = false,
            OnKeyDown = function() end,
            OnKeyUp = function() end,
            OnKeyChanged = function() end
        }, options) }, Bind);

        local library = subsection.Library;

        bind.Frame = library:Create("TextButton", {
            Parent = subsection.Container,
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Size = udim2New(1, 0, 0, 26),
            ZIndex = 2,
            Name = bind.Title
        }, {
            library:Create("Frame", {
                Tags = {
                    { "BackgroundColor3", "ItemBackground" }
                },
                AnchorPoint = vector2New(1, 0.5),
                Position = udim2New(1, -1, 0.5, 0),
                Size = udim2New(0, 91, 1, -2),
                ZIndex = 2,
                Name = "container"
            }, {
                library:Create("UIStroke", {
                    Tags = {
                        { "Color", "MainBorder" }
                    },
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Name = "stroke"
                }),
                library:Create("UICorner", {
                    CornerRadius = udimNew(0, 3),
                    Name = "corner"
                }),
                library:Create("TextLabel", {
                    Tags = {
                        { "TextColor3", "Foreground" }
                    },
                    FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    FontSize = Enum.FontSize.Size12,
                    Text = "None",
                    TextSize = 12,
                    TextWrapped = true,
                    AnchorPoint = vector2New(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = udim2New(0.5, 0, 0.5, 0),
                    Size = udim2New(1, -16, 1, 0),
                    ZIndex = 2,
                    Name = "indicator"
                })
            }),
            library:Create("TextLabel", {
                Tags = {
                    { "TextColor3", "Foreground" }
                },
                FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                FontSize = Enum.FontSize.Size14,
                Text = bind.Title,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = vector2New(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(0.5, 0, 0.5, 0),
                Size = udim2New(1, -4, 1, 0),
                ZIndex = 2,
                Name = "title"
            })
        });

        connect(bind.Frame.MouseButton1Click, function()
            if library.Settings.Binding == false then
                library.Settings.Binding = true;
                bind.Frame.container.Size = udim2New(0, ellipsisBindSize, 1, 0);
                bind.Frame.container.indicator.Text = "...";
                taskWait(0.1);
                local key, dependency = nil, nil;
                taskSpawn(function()
                    while key == nil do
                        local input = waitForSignal(userInputService.InputBegan);
                        if key then
                            break;
                        end
                        local enumItem = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType;
                        if isValidEnumItem(enumItem) then
                            if dependency == nil and tableFind(dualBindKeys, enumItem) then
                                dependency = enumItem;
                                bind:EditVisual("", enumItem.Name);
                                local conn; conn = connect(userInputService.InputEnded, function(input2)
                                    if input2.UserInputType == Enum.UserInputType.Keyboard and input2.KeyCode == enumItem then
                                        conn:Disconnect();
                                        dependency = nil;
                                        key = enumItem;
                                    end
                                end);
                            elseif dependency == nil or (enumItem.EnumType == Enum.KeyCode and not tableFind(dualBindKeys, enumItem)) then
                                key = enumItem;
                                break;
                            end
                        end
                    end
                end);
                repeat taskWait() until key;
                bind:Set(key, dependency);
                taskWait(0.1);
                library.Settings.Binding = false;
            end
        end);

        bind.Library = library;
        bind.Subsection = subsection;
        bind.Class = "Bind";

        library.Flags[bind.Flag] = bind.Value;
        library.Items[bind.Flag] = bind;
        bind:Set(bind.Value.Key, bind.Value.Dependency);

        return bind;
    end

    function Bind:EditVisual(enumName, dependencyName)
        local textValue = (dependencyName == nil and "" or dependencyName .. " + ") .. (enumName == "Escape" and "None" or enumName);
        local container = self.Frame.container;
        local indicator = container.indicator;
        container.Size = udim2New(0, getTextBoundsAsync(textService, self.Library:Create("GetTextBoundsParams", {
            Text = textValue,
            Font = indicator.FontFace,
            Size = 12,
            Width = math.huge
        })).X + 16, 1, 0);
        indicator.Text = textValue;
    end

    function Bind:Set(enumItem, dependency)
        if dependency == Enum.KeyCode.Escape then
            dependency = nil;
        end
        if isValidEnumItem(enumItem) and (dependency == nil or table.find(dualBindKeys, dependency)) then
            self:EditVisual(enumItem.Name, dependency and dependency.Name);
            local oldValue = {
                self.Value.Key,
                self.Value.Dependency
            };
            self.Value.Key = enumItem;
            self.Value.Dependency = dependency;
            self.OnKeyChanged(oldValue, self.Value);
        end
    end

    --[[ Box ]]--

    local Box = {};

    function Box.__index(self, k)
        return Box[k] or self.Options[k];
    end

    function Box.__newindex(self, k, v)
        self.Options[k] = v;
    end

    function Box.new(subsection, options)
        local box = setmetatable({ Options = mergeTables({
            Title = "Box",
            Flag = randomFlag(),
            Value = "",
            Type = "Changed",
            NumberOnly = false,
            Ignore = false,
            Validate = function()
                return true;
            end,
            Callback = function() end
        }, options) }, Box)

        local library = subsection.Library;

        box.Frame = library:Create("TextButton", {
            Parent = subsection.Container,
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Size = udim2New(1, -4, 0, 26),
            ZIndex = 2,
            Name = box.Title
        }, {
            library:Create("Frame", {
                Tags = {
                    { "BackgroundColor3", "ItemBackground" }
                },
                AnchorPoint = vector2New(1, 0.5),
                Position = udim2New(1, -1, 0.5, 0),
                Size = udim2New(0, 91, 1, -2),
                ZIndex = 2,
                Name = "container"
            }, {
                library:Create("UIStroke", {
                    Tags = {
                        { "Color", "MainBorder" }
                    },
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Name = "stroke"
                }),
                library:Create("UICorner", {
                    CornerRadius = udimNew(0, 3),
                    Name = "corner"
                }),
                library:Create("TextBox", {
                    Tags = {
                        { "TextColor3", "Foreground" }
                    },
                    FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    FontSize = Enum.FontSize.Size12,
                    PlaceholderText = "Enter Value...",
                    Text = "",
                    TextSize = 12,
                    TextWrapped = true,
                    AnchorPoint = vector2New(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = udim2New(0.5, 0, 0.5, 0),
                    Size = udim2New(1, -16, 1, 0),
                    ZIndex = 2,
                    Name = "box"
                })
            }),
            library:Create("TextLabel", {
                Tags = {
                    { "TextColor3", "Foreground" }
                },
                FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                FontSize = Enum.FontSize.Size14,
                Text = box.Title,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = vector2New(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(0.5, 0, 0.5, 0),
                Size = udim2New(1, -4, 1, 0),
                ZIndex = 2,
                Name = "title"
            })
        });

        box.MaxLength = box.Frame.AbsoluteSize.X - (getTextBoundsAsync(textService, library:Create("GetTextBoundsParams", {
            Text = box.Title,
            Font = box.Frame.title.FontFace,
            Size = 13,
            Width = math.huge
        })).X + 16);

        connect(getPropertyChangedSignal(box.Frame.container.box, "Text"), function()
            box:Resize();
            if box.Type == "Changed" then
                box:Set(box.Frame.container.box.Text);
            end
        end);

        connect(box.Frame.container.box.FocusLost, function(enterPressed)
            if box.Type == "FocusLost" or (box.Type == "EnterPressed" and enterPressed) then
                box:Set(box.Frame.container.box.Text);
            end
        end)

        box.Library = library;
        box.Subsection = subsection;
        box.Class = "Box";

        library.Flags[box.Flag] = "";
        library.Items[box.Flag] = box;
        if box.Value ~= "" then
            box:Set(box.Value);
        end

        return box
    end

    function Box:Set(value, ignoreCallback)
        if (self.NumberOnly == false or tonumber(value)) and self.Validate(value) then
            self.Frame.container.box.Text = value;
            self.Value = value;
            self.Library.Flags[self.Flag] = value;
            if not ignoreCallback then
                self.Callback(value);
            end
        else
            self.Frame.container.box.Text = self.Value;
        end
    end

    function Box:Resize()
        local frame = self.Frame;
        local container = frame.container;
        local box = container.box;
        local bounds = getTextBoundsAsync(textService, self.Library:Create("GetTextBoundsParams", {
            Text = box.Text,
            Font = box.FontFace,
            Size = 12,
            Width = self.MaxLength - 16
        }));
        frame.Size = udim2New(1, frame.Size.X.Offset, 0, bounds.Y + 14);
        frame.container.Size = udim2New(0, mathClamp(bounds.X + 16, 91, self.MaxLength), 1, -2);
    end

    --[[ Slider ]]--

    local Slider = {};

    function Slider.__index(self, k)
        return Slider[k] or self.Options[k];
    end

    function Slider.__newindex(self, k, v)
        self.Options[k] = v;
    end

    function Slider.new(subsection, options)
        local slider = setmetatable({ Options = mergeTables({
            Title = "Slider",
            Flag = randomFlag(),
            Value = 0,
            Min = 0,
            Max = 100,
            Float = 1,
            Prefix = "",
            Suffix = "",
            ShowValue = false,
            StartName = "",
            EndName = "",
            Ignore = false,
            Validate = function()
                return true;
            end,
            Callback = function() end
        }, options) }, Slider);

        local library = subsection.Library;

        slider.Frame = library:Create("TextButton", {
            Parent = subsection.Container,
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Size = udim2New(1, 0, 0, 34),
            ZIndex = 2,
            Name = slider.Title
        }, {
            library:Create("Frame", {
                Tags = {
                    { "BackgroundColor3", "ItemBackground" }
                },
                AnchorPoint = vector2New(0.5, 1),
                Position = udim2New(0.5, 0, 1, -1),
                Size = udim2New(1, -2, 0, 10),
                ZIndex = 2,
                Name = "indicator"
            }, {
                library:Create("UIStroke", {
                    Tags = {
                        { "Color", "MainBorder" }
                    },
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Name = "stroke"
                }),
                library:Create("UICorner", {
                    CornerRadius = udimNew(0, 2),
                    Name = "corner"
                }),
                library:Create("Frame", {
                    Tags = {
                        { "BackgroundColor3", "Accent" }
                    },
                    AnchorPoint = vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    Position = udim2New(0, 0, 0.5, 0),
                    Size = udim2New(0, 0, 1, 0),
                    ZIndex = 2,
                    Name = "highlight"
                }, {
                    library:Create("UICorner", {
                        CornerRadius = udimNew(0, 2),
                        Name = "corner"
                    })
                })
            }),
            library:Create("TextBox", {
                Tags = {
                    { "TextColor3", "Foreground" }
                },
                FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                FontSize = Enum.FontSize.Size14,
                Text = "",
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right,
                AnchorPoint = vector2New(1, 0),
                BackgroundTransparency = 1,
                Position = udim2New(1, -2, 0, 0),
                Size = udim2New(0, 27, 0, 20),
                ZIndex = 2,
                Name = "input"
            }),
            library:Create("TextLabel", {
                Tags = {
                    { "TextColor3", "Foreground" }
                },
                FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                FontSize = Enum.FontSize.Size14,
                Text = slider.Title,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = vector2New(0.5, 0),
                BackgroundTransparency = 1,
                Position = udim2New(0.5, 0, 0, 0),
                Size = udim2New(1, -4, 0, 20),
                ZIndex = 2,
                Name = "title"
            })
        });

        connect(slider.Frame.indicator.InputBegan, function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1) then
                library.Settings.Dragging = true;
                local mouseMove = connect(mouse.Move, function()
                    slider:Set(slider.Min + ((slider.Max - slider.Min) * ((mouse.X - slider.Frame.indicator.AbsolutePosition.X) / slider.Frame.indicator.AbsoluteSize.X)));
                end);
                local inputEnded; inputEnded = connect(input.Changed, function()
                    if input.UserInputState == Enum.UserInputState.End then
                        disconnect(mouseMove);
                        disconnect(inputEnded);
                        library.Settings.Dragging = false;
                    end
                end);
            end
        end);

        connect(slider.Frame.input.FocusLost, function()
            local textNumber = tonumber(slider.Frame.input.Text);
            if textNumber ~= nil then
                slider:Set(textNumber);
            end
        end);

        slider.Library = library;
        slider.Subsection = subsection;
        slider.Class = "Slider";

        library.Flags[slider.Flag] = slider.Min;
        library.Items[slider.Flag] = slider;
        if slider.Value > slider.Min then
            slider:Set(slider.Value, true);
        else
            slider:UpdateText(slider.Min);
        end

        return slider;
    end

    function Slider:Set(value, bypassValueCheck)
        local trueValue = mathClamp(getPrecision(value, self.Float), self.Min, self.Max);
        if self.Validate(trueValue) then
            self:UpdateText(trueValue);
            if trueValue ~= self.Value or bypassValueCheck then
                tween(self.Frame.indicator.highlight, 0.1, { Size = udim2New((trueValue - self.Min) / (self.Max - self.Min), 0, 1, 0) });
                self.Value = trueValue;
                self.Library.Flags[self.Flag] = trueValue;
                self.Callback(trueValue);
            end
        end
    end

    function Slider:UpdateText(value)
        local inputText = self.Prefix .. value .. self.Suffix;
        local appendValue = self.ShowValue and " (" .. inputText .. ")" or "";
        if (self.StartName ~= "" and value == self.Min) then
            inputText = self.StartName .. appendValue;
        elseif (self.EndName ~= "" and value == self.Max) then
            inputText = self.EndName .. appendValue;
        end
        self.Frame.input.Text = inputText;
        self.Frame.input.Size = udim2New(0, getTextBoundsAsync(textService, self.Library:Create("GetTextBoundsParams", {
            Text = inputText,
            Font = self.Frame.input.FontFace,
            Size = 13,
            Width = math.huge
        })).X, self.Frame.input.Size.Y.Scale, self.Frame.input.Size.Y.Offset);
    end

    --[[ Dropdown ]]--

    local Dropdown = {};

    function Dropdown.__index(self, k)
        return Dropdown[k] or self.Options[k];
    end

    function Dropdown.__newindex(self, k, v)
        self.Options[k] = v;
    end

    function Dropdown.new(subsection, options)
        local dropdown = setmetatable({ Options = mergeTables({
            Title = "Dropdown",
            Flag = randomFlag(),
            Value = {},
            Items = {},
            AllowNoValue = false,
            MultiSelect = false,
            Ignore = false,
            Validate = function()
                return true;
            end,
            Callback = function() end
        }, options) }, Dropdown);

        local library = subsection.Library;

        dropdown.Frame = library:Create("TextButton", {
            Parent = subsection.Container,
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Size = udim2New(1, -4, 0, 44),
            ZIndex = 2,
            Name = dropdown.Title
        }, {
            library:Create("Frame", {
                Tags = {
                    { "BackgroundColor3", "ItemBackground" }
                },
                AnchorPoint = vector2New(0.5, 1),
                Position = udim2New(0.5, 0, 1, -1),
                Size = udim2New(1, -2, 0, 20),
                ZIndex = 2,
                Name = "indicator"
            }, {
                library:Create("UIStroke", {
                    Tags = {
                        { "Color", "MainBorder" }
                    },
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Name = "stroke"
                }),
                library:Create("UICorner", {
                    CornerRadius = udimNew(0, 2),
                    Name = "corner"
                }),
                library:Create("TextLabel", {
                    Tags = {
                        { "TextColor3", "Foreground" }
                    },
                    FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    FontSize = Enum.FontSize.Size12,
                    Text = "None",
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AnchorPoint = vector2New(0.5, 0),
                    BackgroundTransparency = 1,
                    Position = udim2New(0.5, 0, 0, 0),
                    Size = udim2New(1, -16, 1, 0),
                    ZIndex = 2,
                    Name = "selected"
                }),
                library:Create("ImageLabel", {
                    Image = "rbxassetid://10222661727",
                    AnchorPoint = vector2New(1, 0.5),
                    BackgroundTransparency = 1,
                    Position = udim2New(1, -4, 0.5, 0),
                    Size = udim2New(0, 16, 0, 16),
                    ZIndex = 2,
                    Name = "arrow"
                })
            }),
            library:Create("TextLabel", {
                Tags = {
                    { "TextColor3", "Foreground" }
                },
                FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                FontSize = Enum.FontSize.Size14,
                Text = dropdown.Title,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = vector2New(0.5, 0),
                BackgroundTransparency = 1,
                Position = udim2New(0.5, 0, 0, 0),
                Size = udim2New(1, -4, 0, 20),
                ZIndex = 2,
                Name = "title"
            })
        });

        dropdown.ItemContainer = {};

        connect(dropdown.Frame.MouseButton1Click, function()
            dropdown:Open();
        end);

        dropdown.Library = library;
        dropdown.Subsection = subsection;
        dropdown.Class = "Dropdown";
        dropdown.Drop = library.Directory.popups.drop;

        for i = 1, #dropdown.Items do
            if type(dropdown.Items[i]) ~= "string" then
                dropdown.Items[i] = tostring(dropdown.Items[i]);
            end
            dropdown:Add(dropdown.Items[i], true);
        end

        library.Flags[dropdown.Flag] = dropdown.Value;
        library.Items[dropdown.Flag] = dropdown;

        if #dropdown.Value > 0 then
            for i = 1, #dropdown.Value do
                if type(dropdown.Value[i]) ~= "string" then
                    dropdown.Value[i] = tostring(dropdown.Value[i]);
                end
                dropdown:Set(dropdown.Value[i], true, false, true);
            end
        elseif dropdown.AllowNoValue == false and #dropdown.Items > 0 then
            dropdown:Set(dropdown.Items[1], true, false, true);
        end

        return dropdown
    end

    function Dropdown:Open()
        local selected = self.Library.Settings.SelectedDrop;

        if selected then
            selected:Close();
            if selected == self then
                return self
            end
        end

        self.Library.Settings.SelectedDrop = self;
        
        local indicator, drop = self.Frame.indicator, self.Drop;
        for i = 1, #self.ItemContainer do
            self.ItemContainer[i].Parent = drop.container;
        end

        local indicatorPos = udim2New(0, (indicator.AbsolutePosition.X - drop.AbsoluteSize.X) + indicator.AbsoluteSize.X, 0, indicator.AbsolutePosition.Y + indicator.AbsoluteSize.Y + 9);
        local dropSize = udim2New(0, 179, 0, mathClamp(drop.container.list.AbsoluteContentSize.Y + 12, 12, 102));

        drop.Visible = true;
        tween(indicator.arrow, 0.25, { Rotation = 180 });
        if selected ~= nil then
            tween(drop, 0.5, { Position = indicatorPos, Size = dropSize }, Enum.EasingStyle.Quart);
        else
            drop.Position = indicatorPos;
            drop.Size = dropSize;
        end

        self.PropertyChanged = connect(getPropertyChangedSignal(indicator, "AbsolutePosition"), function()
            drop.Position = udim2New(0, (indicator.AbsolutePosition.X - drop.AbsoluteSize.X) + indicator.AbsoluteSize.X, 0, indicator.AbsolutePosition.Y + indicator.AbsoluteSize.Y + 9);
        end);
        return self;
    end

    function Dropdown:Close()
        self.Library.Settings.SelectedDrop = nil;
        tween(self.Frame.indicator.arrow, 0.25, { Rotation = 0 });

        for i = 1, #self.ItemContainer do
            self.ItemContainer[i].Parent = self.Library.Directory.dropignores;
        end

        self.Drop.Visible = false;
        disconnect(self.PropertyChanged);
        return self;
    end

    function Dropdown:Add(name, ignoreTable)
        local itemFrame = self.Library:Create("TextButton", {
            Tags = {
                { "TextColor3", "Foreground" }
            },
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Text = "",
            Size = udim2New(1, 0, 0, 20),
            Name = name
        }, {
            self.Library:Create("Frame", {
                AnchorPoint = vector2New(0.5, 0.5),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = udim2New(0.5, 0, 0.5, 0),
                Size = udim2New(1, -16, 1, 0),
                Name = "container"
            }, {
                self.Library:Create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Name = "list"
                }),
                self.Library:Create("Frame", {
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    Size = udim2New(0, 0, 1, 0),
                    Name = "arrow"
                }, {
                    self.Library:Create("ImageLabel", {
                        Tags = {
                            { "ImageColor3", "Accent" }
                        },
                        Image = "rbxassetid://10952742179",
                        AnchorPoint = vector2New(0, 0.5),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Position = udim2New(0, -4, 0.5, 0),
                        Size = udim2New(0, 16, 0, 16),
                        Name = "icon"
                    }),
                    self.Library:Create("Frame", {
                        Tags = {
                            { "BackgroundColor3", "MainBackground" }
                        },
                        AnchorPoint = vector2New(1, 0.5),
                        BorderSizePixel = 0,
                        Position = udim2New(1, 0, 0.5, 0),
                        Size = udim2New(0, 4, 1, 0),
                        Name = "cover"
                    })
                }),
                self.Library:Create("TextLabel", {
                    Tags = {
                        { "TextColor3", "Foreground" }
                    },
                    FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    FontSize = Enum.FontSize.Size12,
                    Text = name,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AnchorPoint = vector2New(0.5, 0),
                    BackgroundTransparency = 1,
                    Position = udim2New(0.5, 0, 0, 0),
                    Size = udim2New(1, 0, 1, 0),
                    ZIndex = 2,
                    Name = "title"
                })
            })
        });

        connect(itemFrame.MouseButton1Click, function()
            self:Set(name, tableFind(self.Value, name) == nil);
        end)

        self.ItemContainer[#self.ItemContainer + 1] = itemFrame;
        if not ignoreTable then
            self.Items[#self.Items + 1] = name;
        end
    end

    function Dropdown:Remove(name)
        self:Set(name, false);
        local index = tableFind(self.Items, name);
        if index then
            tableRemove(self.Items, index);
        end
        for i = 1, #self.ItemContainer do
            local item = self.ItemContainer[i]
            if item.Name == name then
                destroy(item);
                tableRemove(self.ItemContainer, i);
                break;
            end
        end
    end

    function Dropdown:Refresh(list)
        if #self.Items > 0 then
            repeat
                self:Remove(self.Items[1]);
            until #self.Items == 0;
        end
        for i = 1, #list do
            self:Add(list[i]);
        end
    end

    function Dropdown:Set(name, enabled, ignoreNoValue, init)
        if self.Validate(name, enabled) then
            local index = tableFind(self.Value, name);
            if not init and ((enabled and index) or (not enabled and not index)) then
                return;
            end
            if self.MultiSelect == false and #self.Value == 1 and self.Value[1] ~= name then
                self:Set(self.Value[1], false, true);
            end
            if self.AllowNoValue == false and #self.Value == 1 and self.Value[1] == name and not (enabled or ignoreNoValue) then
                return;
            end
            for i = 1, #self.ItemContainer do
                local item = self.ItemContainer[i];
                if item.Name == name then
                    tween(item.container.arrow, 0.25, { Size = udim2New(0, enabled and 14 or 0, 1, 0) });
                    if enabled then
                        if not tableFind(self.Value, name) then
                            self.Value[#self.Value + 1] = name;
                        end
                    else
                        local find = tableFind(self.Value, name);
                        if find then
                            tableRemove(self.Value, find);
                        end
                    end
                    self:Organise();
                    self.Callback(name, enabled);
                end
            end
        end
    end

    function Dropdown:Organise()
        local str = ""
        for i = 1, #self.ItemContainer do
            local item = self.ItemContainer[i];
            local value = tableFind(self.Value, item.Name) and item.Name or false;
            if value then
                local isValid = getTextBoundsAsync(textService, self.Library:Create("GetTextBoundsParams", {
                    Text = str .. (#str > 0 and ", " or "") .. value,
                    Font = self.Frame.indicator.selected.FontFace,
                    Size = 12,
                    Width = math.huge
                })).X <= 238;
                str = str .. (#str > 0 and ", " or "") .. (isValid and value or "...");
                if isValid == false then
                    break;
                end
            end
        end
        self.Frame.indicator.selected.Text = #self.Value == 0 and "None" or str;
    end

    --[[ Colorpicker ]]--

    local Colorpicker = {}

    function Colorpicker.__index(self, k)
        return Colorpicker[k] or self.Options[k];
    end

    function Colorpicker.__newindex(self, k, v)
        self.Options[k] = v;
    end

    function Colorpicker.new(subsection, options)
        local colorpicker = setmetatable({ Options = mergeTables({
            Title = "Colorpicker",
            Flag = randomFlag(),
            Color = colorNew(1, 1, 1),
            Alpha = 1,
            Rainbow = false,
            Sync = false,
            Ignore = false,
            Callback = function() end,
        }, options) }, Colorpicker)

        local library = subsection.Library;
        local picker = library.Directory.popups.picker;

        colorpicker.Frame = library:Create("TextButton", {
            Parent = subsection.Container,
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Size = udim2New(1, 0, 0, 26),
            ZIndex = 2,
            Name = colorpicker.Title
        }, {
            library:Create("TextLabel", {
                Tags = {
                    { "TextColor3", "Foreground" }
                },
                FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                FontSize = Enum.FontSize.Size14,
                Text = colorpicker.Title,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = vector2New(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(0.5, 0, 0.5, 0),
                Size = udim2New(1, -4, 1, 0),
                ZIndex = 2,
                Name = "title"
            }),
            library:Create("Frame", {
                AnchorPoint = vector2New(1, 0.5),
                BackgroundColor3 = colorpicker.Color,
                BackgroundTransparency = 1 - colorpicker.Alpha,
                Position = udim2New(1, -1, 0.5, 0),
                Size = udim2New(0, 40, 0, 22),
                ZIndex = 2,
                Name = "indicator"
            }, {
                library:Create("UIStroke", {
                    Tags = {
                        { "Color", "MainBorder" }
                    },
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Name = "stroke"
                }),
                library:Create("UICorner", {
                    CornerRadius = udimNew(0, 3),
                    Name = "corner"
                })
            })
        });

        connect(colorpicker.Frame.MouseButton1Click, function()
            colorpicker:Open();
        end);

        colorpicker.Library = library;
        colorpicker.Subsection = subsection;
        colorpicker.Class = "Picker";
        colorpicker.Picker = picker;

        library.Flags[colorpicker.Flag] = { Color = colorpicker.Color, Alpha = colorpicker.Alpha, Rainbow = colorpicker.Rainbow, Sync = colorpicker.Sync };
        library.Items[colorpicker.Flag] = colorpicker;

        if colorpicker.Color ~= colorNew(1, 1, 1) or colorpicker.Alpha < 1 then
            colorpicker:Set(colorpicker.Color, colorpicker.Alpha);
        end
        if colorpicker.Rainbow then
            colorpicker:ToggleRainbow(colorpicker.Rainbow);
        end
        if colorpicker.Sync then
            colorpicker:ToggleSync(colorpicker.Sync);
        end

        return colorpicker
    end

    function Colorpicker:Open()
        local selected = self.Library.Settings.SelectedPicker;

        if selected then
            selected:Close();
            if selected == self then
                return self
            end
        end

        self.Library.Settings.SelectedPicker = self;

        local picker, indicator = self.Picker, self.Frame.indicator;
        local indicatorPos = udim2New(0, (indicator.AbsolutePosition.X - picker.AbsoluteSize.X) + indicator.AbsoluteSize.X, 0, indicator.AbsolutePosition.Y + indicator.AbsoluteSize.Y + 9);

        picker.Visible = true;
        if selected then
            tween(picker, 0.5, { Position = indicatorPos }, Enum.EasingStyle.Quart);
        else
            picker.Position = indicatorPos;
        end

        self:Set(self.Color, self.Alpha, true);
        self:ToggleRainbow(self.Rainbow, true);
        self:ToggleSync(self.Sync, true);

        self.HueDragged = connect(picker.hue.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and not self.Library.Settings.Dragging then
                self.Library.Settings.Dragging = true;
                if self.Rainbow then
                    self:ToggleRainbow(false);
                end
                local mouseMove = connect(mouse.Move, function()
                    local _, s, v = toHSV(self.Color);
                    self:Set(colorFromHSV(mathClamp((mouse.Y - picker.hue.AbsolutePosition.Y) / picker.hue.AbsoluteSize.Y, 0, 1), s, v), self.Alpha);
                end);
                local inputEnded; inputEnded = connect(input.Changed, function()
                    if input.UserInputState == Enum.UserInputState.End then
                        disconnect(mouseMove);
                        disconnect(inputEnded);
                        self.Library.Settings.Dragging = false;
                    end
                end);
            end
        end);

        self.SatDragged = connect(picker.sat.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and not self.Library.Settings.Dragging then
                self.Library.Settings.Dragging = true;
                local mouseMove = connect(mouse.Move, function()
                    local h, _, _ = toHSV(self.Color);
                    self:Set(colorFromHSV(h, mathClamp((mouse.X - picker.sat.AbsolutePosition.X) / picker.sat.AbsoluteSize.X, 0, 1), 1 - mathClamp((mouse.Y - picker.sat.AbsolutePosition.Y) / picker.sat.AbsoluteSize.Y, 0, 1)), self.Alpha);
                end);
                local inputEnded; inputEnded = connect(input.Changed, function()
                    if input.UserInputState == Enum.UserInputState.End then
                        disconnect(mouseMove);
                        disconnect(inputEnded);
                        self.Library.Settings.Dragging = false;
                    end
                end);
            end
        end);

        self.AlphaDragged = connect(picker.alpha.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and not self.Library.Settings.Dragging then
                self.Library.Settings.Dragging = true;
                local mouseMove = connect(mouse.Move, function()
                    self:Set(self.Color, mathClamp((mouse.Y - picker.alpha.AbsolutePosition.Y) / picker.alpha.AbsoluteSize.Y, 0, 1));
                end);
                local inputEnded; inputEnded = connect(input.Changed, function()
                    if input.UserInputState == Enum.UserInputState.End then
                        disconnect(mouseMove);
                        disconnect(inputEnded);
                        self.Library.Settings.Dragging = false;
                    end
                end);
            end
        end);

        self.PropertyChanged = connect(getPropertyChangedSignal(indicator, "AbsolutePosition"), function()
            picker.Position = udim2New(0, (indicator.AbsolutePosition.X - picker.AbsoluteSize.X) + indicator.AbsoluteSize.X, 0, indicator.AbsolutePosition.Y + indicator.AbsoluteSize.Y + 9);
        end);

        self.HexChanged = connect(picker.hex.FocusLost, function()
            local s, r = pcall(colorFromHex, picker.hex.Text);
            self:Set(s and r or self.Color, self.Alpha);
        end);

        self.RGBChanged = connect(picker.rgb.FocusLost, function()
            local r, g, b = stringMatch(picker.rgb.Text, "([0-9]+), *([0-9]+), *([0-9]+)");
            self:Set(r and colorFromRGB(r, g, b) or self.Color, self.Alpha);
        end);

        self.RainbowToggled = connect(picker.rainbow.MouseButton1Click, function()
            self:ToggleRainbow(not self.Library.Flags[self.Flag].Rainbow);
        end);

        self.SyncToggled = connect(picker.sync.MouseButton1Click, function()
            self:ToggleSync(not self.Library.Flags[self.Flag].Sync);
        end);

        return self;
    end

    function Colorpicker:Close()
        self.Library.Settings.SelectedPicker = nil;
        self.Picker.Visible = false;
        disconnect(self.HueDragged);
        disconnect(self.SatDragged);
        disconnect(self.AlphaDragged);
        disconnect(self.PropertyChanged);
        disconnect(self.HexChanged);
        disconnect(self.RGBChanged);
        disconnect(self.RainbowToggled);
        disconnect(self.SyncToggled);
        return self;
    end

    function Colorpicker:Set(color, alpha, justVisual)
        local clampedAlpha = mathClamp(alpha, 0, 1);
        if self.Library.Settings.SelectedPicker == self then
            local h, s, v = toHSV(color);
            local r, g, b = mathRound(color.R * 255), mathRound(color.G * 255), mathRound(color.B * 255);
            self.Picker.alpha.cover.gradient.Color = colorSequenceNew(color);
            self.Picker.sat.gradient.Color = colorSequenceNew(colorNew(1, 1, 1), colorFromHSV(h, 1, 1));
            self.Picker.hex.Text = "#" .. toHex(color);
            self.Picker.rgb.Text = stringFormat("%d, %d, %d", r, g, b);
            if self.Rainbow then
                self.Picker.hue.indicator.BackgroundColor3 = color;
                self.Picker.hue.indicator.Position = udim2New(0.5, 0, h, 0);
            else
                tween(self.Picker.hue.indicator, 0.25, { BackgroundColor3 = color, Position = udim2New(0.5, 0, h, 0) });
            end
            tween(self.Picker.sat.indicator, 0.25, { BackgroundColor3 = color, Position = udim2New(s, 0, 1 - v, 0) });
            tween(self.Picker.alpha.indicator, 0.25, { BackgroundColor3 = color, Position = udim2New(0.5, 0, clampedAlpha, 0) });
        end
        tween(self.Frame.indicator, 0.25, { BackgroundColor3 = color, BackgroundTransparency = 1 - clampedAlpha });
        if not justVisual then
            self.Color = color;
            self.Alpha = clampedAlpha;
            self.Library.Flags[self.Flag].Color = color;
            self.Library.Flags[self.Flag].Alpha = clampedAlpha;
            self.Callback(color, clampedAlpha);
        end
    end

    function Colorpicker:ToggleRainbow(state, justVisual)
        if self.Library.Settings.SelectedPicker == self then
            tween(self.Picker.rainbow.indicator, 0.25, { BackgroundColor3 = self.Library.Theme.Data[state and "Accent" or "ItemBackground"] });
            tween(self.Picker.rainbow.indicator.icon, 0.25, { ImageTransparency = state and 0 or 1 });
        end
        if not justVisual then
            if self.RainbowConnection then
                Ocy.Tracer:Remove(self.RainbowConnection);
                self.RainbowConnection = nil;
            end
            if state then
                local offset = self.Library.Settings.SyncedHue - ({ toHSV(self.Color) })[1]; -- this is the variable randomly turning into a table (should be a number)
                self.RainbowConnection = select(2, Ocy.Tracer:Connect(runService.Heartbeat, function()
                    local _, s, v = toHSV(self.Color);
                    self:Set(colorFromHSV(self.Sync and self.Library.Settings.SyncedHue or (self.Library.Settings.SyncedHue - offset) % 1, s, v), self.Alpha); -- this is where it's erroring because `offset` has become a table
                end));
            end
            self.Rainbow = state;
            self.Library.Flags[self.Flag].Rainbow = state; -- self.Library.Flags[self.Flag] is the table it's randomly turning into
        end
    end

    function Colorpicker:ToggleSync(state, justVisual)
        if self.Library.Settings.SelectedPicker == self then
            tween(self.Picker.sync.indicator, 0.25, { BackgroundColor3 = self.Library.Theme.Data[state and "Accent" or "ItemBackground"] });
            tween(self.Picker.sync.indicator.icon, 0.25, { ImageTransparency = state and 0 or 1 });
        end
        if not justVisual then
            self.Sync = state;
            self.Library.Flags[self.Flag].Sync = state;
        end
    end

    --[[ Separator ]]

    local Separator = {};

    function Separator.__index(self, k)
        return Separator[k] or self.Options[k];
    end

    function Separator.__newindex(self, k, v)
        self.Options[k] = v;
    end

    function Separator.new(subsection)
        local separator = setmetatable({ Options = {} }, Separator);

        local library = subsection.Library;

        separator.Frame = library:Create("Frame", {
            Parent = subsection.Container,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = udim2New(1, 0, 0, 9),
            ZIndex = 2,
            Name = "Separator"
        }, {
            library:Create("Frame", {
                Tags = {
                    { "BackgroundColor3", "MainBorder" }
                },
                AnchorPoint = vector2New(0.5, 0.5),
                BorderSizePixel = 0,
                Position = udim2New(0.5, 0, 0.5, 0),
                Size = udim2New(1, 0, 0, 1),
                ZIndex = 2,
                Name = "bar"
            }, {
                library:Create("UIGradient", {
                    Transparency = numberSequenceNew({
                        numberSequenceKeypointNew(0, 1),
                        numberSequenceKeypointNew(0.11999999731779099, 0),
                        numberSequenceKeypointNew(0.8799999952316284, 0),
                        numberSequenceKeypointNew(1, 1)
                    }),
                    Name = "gradient"
                })
            })
        })

        separator.Library = library;

        return separator;
    end

    --[[ Subsection ]]--

    local Subsection = {};

    function Subsection.__index(self, k)
        return Subsection[k] or self.Options[k];
    end

    function Subsection.__newindex(self, k, v)
        self.Options[k] = v;
    end

    function Subsection.new(section, options)
        local subsection = setmetatable({ Options = mergeTables({
            Title = "Subsection"
        }, options) }, Subsection);

        local library = section.Library;

        local textButton = library:Create("TextButton", {
            Tags = {
                { "BackgroundColor3", "ItemBackground", function()
                    return section.Selected ~= subsection;
                end },
                { "BackgroundColor3", "SectionBackground", function()
                    return section.Selected == subsection;
                end },
                { "TextColor3", "Foreground" }
            },
            Parent = section.Frame.top.container,
            FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            FontSize = Enum.FontSize.Size12,
            Text = subsection.Title,
            TextSize = 12,
            AutoButtonColor = false,
            BorderSizePixel = 0,
            Size = udim2New(0, 41, 1, 0),
            ZIndex = 2,
            Name = subsection.Title
        });

        textButton.Size = udim2New(0, getTextBoundsAsync(textService, library:Create("GetTextBoundsParams", {
            Text = subsection.Title,
            Font = textButton.FontFace,
            Size = 12,
            Width = math.huge
        })).X + 16, 1, textButton.Size.Y.Offset);
        subsection.TextButton = textButton;

        subsection.Separator = library:Create("Frame", {
            Tags = {
                { "BackgroundColor3", "MainBorder" }
            },
            Parent = section.Frame.top.container,
            BorderSizePixel = 0,
            Size = udim2New(0, 1, 1, 0),
            ZIndex = 2,
            Name = "separator"
        });

        subsection.Container = library:Create("ScrollingFrame", {
            Tags = {
                { "ScrollBarImageColor3", "MainBackground" }
            },
            BottomImage = "rbxassetid://10189246540",
            CanvasSize = udim2New(0, 0, 0, 0),
            MidImage = "rbxassetid://10189246358",
            ScrollBarThickness = 4,
            TopImage = "rbxassetid://10189246196",
            VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
            Active = true,
            Visible = false,
            AnchorPoint = vector2New(0.5, 1),
            Parent = section.Frame.container,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = udim2New(0.5, 0, 1, -6),
            Size = udim2New(1, -10, 1, -43),
            ZIndex = 2,
            Name = subsection.Title
        }, {
            library:Create("UIPadding", {
                PaddingBottom = udimNew(0, 1),
                PaddingLeft = udimNew(0, 1),
                PaddingRight = udimNew(0, 1),
                PaddingTop = udimNew(0, 1),
                Name = "padding"
            }),
            library:Create("UIListLayout", {
                Padding = udimNew(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Name = "list"
            })
        });

        autoResize(subsection.Container.list, subsection.Container, 1, function()
            local offset = (subsection.Container.list.AbsoluteContentSize.Y + 1) > subsection.Container.AbsoluteSize.Y and -4 or 0;
            local children = getChildren(subsection.Container);
            for i = 1, #children do
                local child = children[i];
                if not isA(child, "UIBase") then
                    child.Size = udim2New(1, offset, child.Size.Y.Scale, child.Size.Y.Offset);
                end
            end
        end);

        connect(textButton.MouseButton1Click, function()
            subsection:Select();
        end);

        subsection.Library = library;
        subsection.Section = section;

        return subsection;
    end

    function Subsection:Select()
        local selected = self.Section.Selected;
        if selected then
            if selected == self then
                return self;
            end
            selected:Deselect();
        end
        self.Section.Selected = self;
        tween(self.TextButton, 0.25, { BackgroundColor3 = self.Library.Theme.Data.SectionBackground, Size = udim2New(0, self.TextButton.Size.X.Offset, 1, 1) });
        self.Container.Visible = true;
        return self
    end

    function Subsection:Deselect()
        if self.Section.Selected == self then
            tween(self.TextButton, 0.25, { BackgroundColor3 = self.Library.Theme.Data.ItemBackground, Size = udim2New(0, self.TextButton.Size.X.Offset, 1, 0) });
            for i = 1, #closeOnSwitch do
                local item = self.Library.Settings[closeOnSwitch[i]];
                if item and item.Subsection == self then
                    item:Close();
                end
            end
            self.Container.Visible = false;
        end
        return self;
    end

    function Subsection:AddLabel(options)
        return Label.new(self, options);
    end

    function Subsection:AddButton(options)
        return Button.new(self, options);
    end

    function Subsection:AddToggle(options)
        return Toggle.new(self, options);
    end

    function Subsection:AddSelection(options)
        return Selection.new(self, options);
    end

    function Subsection:AddBind(options)
        return Bind.new(self, options);
    end

    function Subsection:AddBox(options)
        return Box.new(self, options);
    end

    function Subsection:AddSlider(options)
        return Slider.new(self, options);
    end

    function Subsection:AddDropdown(options)
        return Dropdown.new(self, options);
    end

    function Subsection:AddPicker(options)
        return Colorpicker.new(self, options);
    end

    function Subsection:AddSeparator()
        return Separator.new(self);
    end

    --[[ Section ]]--

    local Section = {};

    function Section.__index(self, k)
        return Section[k] or self.Options[k];
    end

    function Section.__newindex(self, k, v)
        self.Options[k] = v;
    end

    function Section.new(tab, options)
        local section = setmetatable({ Options = mergeTables({
            Side = "Left",
        }, options) }, Section);

        local library = tab.Library;
        local side = section.Options.Side == "Left" and "left" or "right";

        section.Frame = library:Create("Frame", {
            Tags = {
                { "BackgroundColor3", "SectionBackground" }
            },
            AnchorPoint = vector2New(0, 0.5),
            Parent = tab.Frame[side],
            Position = udim2New(0, 9, 0.5, 0),
            Size = udim2New(1, 0, 0.5, 0),
            ZIndex = 2,
            Name = "card"
        }, {
            library:Create("UICorner", {
                CornerRadius = udimNew(0, 3),
                Name = "corner"
            }),
            library:Create("ImageLabel", {
                Tags = {
                    { "ImageColor3", "Shadow" }
                },
                Image = "rbxassetid://10189254800",
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = rectNew(10, 10, 118, 118),
                AnchorPoint = vector2New(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(0.5, 0, 0.5, 0),
                Size = udim2New(1, 10, 1, 10),
                Name = "blur"
            }),
            library:Create("Frame", {
                BackgroundTransparency = 1,
                Size = udim2New(1, 0, 0, 33),
                Name = "top"
            }, {
                library:Create("Frame", {
                    Tags = {
                        { "BackgroundColor3", "MainBorder" }
                    },
                    AnchorPoint = vector2New(0.5, 1),
                    BorderSizePixel = 0,
                    Position = udim2New(0.5, 0, 1, -1),
                    Size = udim2New(1, 0, 0, 1),
                    ZIndex = 2,
                    Name = "separator"
                }),
                library:Create("Frame", {
                    AnchorPoint = vector2New(0.5, 0),
                    BackgroundTransparency = 1,
                    Position = udim2New(0.5, 0, 0, 0),
                    Size = udim2New(1, 0, 1, -2),
                    Name = "container"
                }, {
                    library:Create("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Name = "list"
                    })
                })
            }),
            library:Create("Folder", {
                Name = "container"
            }),
            library:Create("Frame", {
                AnchorPoint = vector2New(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(0.5, 0, 0.5, 0),
                Size = udim2New(1, 0, 1, 0),
                ZIndex = 2,
                Name = "border"
            }, {
                library:Create("UIStroke", {
                    Tags = {
                        { "Color", "MainBorder" }
                    },
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Name = "stroke"
                }),
                library:Create("UICorner", {
                    CornerRadius = udimNew(0, 3),
                    Name = "corner"
                })
            })
        });

        connect(getPropertyChangedSignal(section.Frame.Parent.list, "AbsoluteContentSize"), function()
            local frame = section.Frame;
            local sections = #getChildren(frame.Parent) - 1;
            frame.Size = udim2New(1, 0, sections == 1 and 1 or sections == 2 and 0.5 or sections == 3 and 0, sections == 1 and 0 or sections == 2 and - 5 or sections == 3 and 142);
        end);

        section.Library = library;
        section.Tab = tab;

        return section
    end

    function Section:AddSubsection(options)
        return Subsection.new(self, options);
    end

    --[[ Tab ]]--

    local Tab = {}

    function Tab.__index(self, k)
        return Tab[k] or self.Options[k]
    end

    function Tab.__newindex(self, k, v)
        self.Options[k] = v
        if k == "Title" then
            self.Button.title.Text = v
            self.Button.Name = v
            self.Frame.Name = v
        elseif k == "Icon" then
            self.Button.icon.Image = v
        end
    end

    function Tab.new(library, options)
        local tab = setmetatable({ Options = mergeTables({
            Title = "Untitled",
            Icon = "rbxassetid://9794011770"
        }, options) }, Tab)

        tab.Button = library:Create("Frame", {
            BackgroundTransparency = 1,
            Parent = library.Directory.gui.main.left.container,
            Size = udim2New(1, 0, 0, 30),
            Name = tab.Title
        }, {
            library:Create("TextButton", {
                Tags = {
                    { "BackgroundColor3", "LeftHighlight" }
                },
                FontFace = fontNew("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                FontSize = Enum.FontSize.Size14,
                Text = "",
                TextSize = 14,
                AutoButtonColor = false,
                AnchorPoint = vector2New(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(0.5, 0, 0.5, 0),
                Size = udim2New(1, -2, 1, -2),
                ZIndex = 2,
                Name = "button"
            }, {
                library:Create("UIStroke", {
                    Tags = {
                        { "Color", "LeftHighlightBorder" }
                    },
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Transparency = 1,
                    Name = "stroke"
                }),
                library:Create("UICorner", {
                    CornerRadius = udimNew(0, 3),
                    Name = "corner"
                })
            }),
            library:Create("TextLabel", {
                Tags = {
                    { "TextColor3", "LeftForeground", function()
                        return library.Settings.Selected ~= tab;
                    end },
                    { "TextColor3", "LeftHighlightForeground", function()
                        return library.Settings.Selected == tab;
                    end }
                },
                FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
                FontSize = Enum.FontSize.Size14,
                Text = tab.Title,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = vector2New(1, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(1, 0, 0.5, 0),
                Size = udim2New(1, -32, 1, 0),
                ZIndex = 2,
                Name = "title"
            }),
            library:Create("ImageLabel", {
                Tags = {
                    { "ImageColor3", "LeftForeground", function()
                        return library.Settings.Selected ~= tab;
                    end },
                    { "ImageColor3", "LeftHighlightForeground", function()
                        return library.Settings.Selected == tab;
                    end }
                },
                Image = tab.Icon,
                AnchorPoint = vector2New(0, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(0, 4, 0.5, 0),
                Size = udim2New(0, 20, 0, 20),
                ZIndex = 2,
                Name = "icon"
            }),
            library:Create("ImageLabel", {
                Tags = {
                    { "ImageColor3", "Shadow" }
                },
                Image = "rbxassetid://10189254800",
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = rectNew(10, 10, 118, 118),
                AnchorPoint = vector2New(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(0.5, 1, 0.5, 1),
                Size = udim2New(1, 6, 1, 6),
                Name = "blur"
            })
        })

        tab.Frame = library:Create("Frame", {
            Tags = {
                { "BackgroundColor3", "MainBackground" }
            },
            AnchorPoint = vector2New(1, 0),
            BorderSizePixel = 0,
            Parent = library.Directory.gui.main.container,
            Position = udim2New(1, 0, 0, 47),
            Size = udim2New(1, -161, 1, -76),
            Name = tab.Title,
            Visible = false,
            ZIndex = 2
        }, {
            library:Create("Frame", {
                AnchorPoint = vector2New(0, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(0, 9, 0.5, 0),
                Size = udim2New(0.5, -14, 1, -18),
                Name = "left",
                ZIndex = 2
            }, {
                library:Create("UIListLayout", {
                    Padding = udimNew(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Name = "list"
                })
            }),
            library:Create("Frame", {
                AnchorPoint = vector2New(1, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(1, -9, 0.5, 0),
                Size = udim2New(0.5, -14, 1, -18),
                Name = "right",
                ZIndex = 2
            }, {
                library:Create("UIListLayout", {
                    Padding = udimNew(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Name = "list"
                })
            })
        });

        connect(tab.Button.button.MouseButton1Click, function()
            tab:Select();
        end);

        tab.Library = library;

        return tab;
    end

    function Tab:Select()
        local selected = self.Library.Settings.Selected;
        if selected then
            if selected == self then
                return self;
            end
            selected:Deselect();
        end
        self.Library.Settings.Selected = self;
        tween(self.Button.button, 0.25, { BackgroundTransparency = 0 });
        tween(self.Button.button.stroke, 0.25, { Transparency = 0 });
        tween(self.Button.title, 0.25, { TextColor3 = self.Library.Theme.Data.LeftHighlightForeground });
        tween(self.Button.icon, 0.25, { ImageColor3 = self.Library.Theme.Data.LeftHighlightForeground });
        tween(self.Button.blur, 0.25, { ImageTransparency = 0 });
        self.Frame.Visible = true;

        return self;
    end

    function Tab:Deselect()
        if self.Library.Settings.Selected == self then
            self.Library.Settings.Selected = nil;
            tween(self.Button.button, 0.25, { BackgroundTransparency = 1 });
            tween(self.Button.button.stroke, 0.25, { Transparency = 1 });
            tween(self.Button.title, 0.25, { TextColor3 = self.Library.Theme.Data.LeftForeground });
            tween(self.Button.icon, 0.25, { ImageColor3 = self.Library.Theme.Data.LeftForeground });
            tween(self.Button.blur, 0.25, { ImageTransparency = 1 });
            for i = 1, #closeOnSwitch do
                local item = self.Library.Settings[closeOnSwitch[i]];
                if item and item.Subsection.Section.Tab == self then
                    item:Close();
                end
            end
            self.Frame.Visible = false;
        end

        return self;
    end

    function Tab:AddSection(options)
        return Section.new(self, options);
    end

    --[[ Library ]]--

    local Library = {};

    function Library.__index(self, k)
        return Library[k] or self.Options[k];
    end

    function Library.__newindex(self, k, v)
        if k == "Open" then
            self.Directory.gui.Enabled = v;
            self.Directory.popups.Enabled = v;
            self.Settings[k] = v;
            return
        elseif k == "DragLeniency" or k == "RainbowDuration" then
            self.Settings[k] = v;
            return
        end
        self.Options[k] = v
    end

    function Library.new(options)
        local library = setmetatable({ Options = mergeTables({
            Title = "Untitled",
            Version = "V4.0.0",
            Discord = "https://discord.gg/Ocyv4",
            Items = {},
            Flags = {},
            Storage = {},
            Settings = {
                Open = true,
                Dragging = false,
                Binding = false,
                DragLeniency = 0.15,
                RainbowDuration = 5,
                SyncedHue = 0
            }
        }, options) }, Library);

        local configPath = "Ocy V4\\Configs\\" .. library.Title;
        if isfolder(configPath) == false then
            makefolder(configPath);
        end

        Library.Icons = setmetatable({
            cache = {}
        }, {
            __index = function(t, k)
                if t.cache[k] == nil then
                    t.cache[k] = getcustomasset(stringFormat("Ocy V4\\Icons\\Regular\\%s.png", k));
                end
                return t.cache[k];
            end
        });

        library.Configs = ConfigManager.new(library);
        library.Theme = ThemeManager.new(library);
        library.Directory = library:Create("Folder", {
            Name = "Ocy"
        }, {
            library:Create("ScreenGui", {
                DisplayOrder = 10,
                Enabled = library.Settings.Open,
                ResetOnSpawn = false,
                Name = "gui"
            }, {
                library:Create("Frame", {
                    Tags = {
                        { "BackgroundColor3", "MainBackground" }
                    },
                    Position = udim2New(0.5, -380, 0.5, -270),
                    Size = udim2New(0, 761, 0, 542),
                    Name = "main"
                }, {
                    library:Create("UICorner", {
                        CornerRadius = udimNew(0, 3),
                        Name = "corner"
                    }),
                    library:Create("TextButton", {
                        AnchorPoint = vector2New(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Text = "",
                        Position = udim2New(0.5, 0, 0.5, 0),
                        Size = udim2New(1, 0, 1, 0),
                        ZIndex = 0,
                        Name = "block"
                    }),--[[
                    library:Create("ImageLabel", {
                        Tags = {
                            { "BackgroundColor3", "MainBackground" }
                        },
                        Image = "rbxassetid://10189254800",
                        ImageTransparency = 1,
                        ScaleType = Enum.ScaleType.Slice,
                        SliceCenter = rectNew(10, 10, 118, 118),
                        AnchorPoint = vector2New(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Position = udim2New(0.5, 0, 0.5, 0),
                        Size = udim2New(1, 10, 1, 10),
                        ZIndex = 0,
                        Name = "background"
                    }),]]
                    library:Create("ImageLabel", {
                        Tags = {
                            { "ImageColor3", "MainBackground" }
                        },
                        Image = "rbxassetid://10189254800",
                        ScaleType = Enum.ScaleType.Slice,
                        SliceCenter = rectNew(10, 10, 118, 118),
                        AnchorPoint = vector2New(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Position = udim2New(0.5, 0, 0.5, 0),
                        Size = udim2New(1, 10, 1, 10),
                        ZIndex = 0,
                        Name = "blur"
                    }),
                    library:Create("Frame", {
                        Tags = {
                            { "BackgroundColor3", "MainBorder" }
                        },
                        AnchorPoint = vector2New(0, 0.5),
                        BorderSizePixel = 0,
                        Position = udim2New(0, 160, 0.5, 0),
                        Size = udim2New(0, 1, 1, 0),
                        Name = "separator"
                    }),
                    library:Create("Frame", {
                        Tags = {
                            { "BackgroundColor3", "MainBorder" }
                        },
                        AnchorPoint = vector2New(1, 0),
                        BorderSizePixel = 0,
                        Position = udim2New(1, 0, 0, 46),
                        Size = udim2New(1, -161, 0, 1),
                        Name = "separator"
                    }),
                    library:Create("Frame", {
                        AnchorPoint = vector2New(1, 0),
                        BackgroundTransparency = 1,
                        ClipsDescendants = true,
                        Position = udim2New(1, 0, 0, 0),
                        Size = udim2New(1, -161, 0, 46),
                        Name = "top"
                    }, {
                        library:Create("Frame", {
                            Tags = {
                                { "BackgroundColor3", "SectionBackground" }
                            },
                            AnchorPoint = vector2New(0, 0.5),
                            Position = udim2New(0, 9, 0.5, 0),
                            Size = udim2New(1, -55, 0, 28),
                            ZIndex = 2,
                            Name = "search"
                        }, {
                            library:Create("UICorner", {
                                CornerRadius = udimNew(0, 3),
                                Name = "corner"
                            }),
                            library:Create("UIStroke", {
                                Tags = {
                                    { "Color", "MainBorder" }
                                },
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Name = "stroke"
                            }),
                            library:Create("ImageLabel", {
                                Tags = {
                                    { "ImageColor3", "Shadow" }
                                },
                                Image = "rbxassetid://10189254800",
                                ScaleType = Enum.ScaleType.Slice,
                                SliceCenter = rectNew(10, 10, 118, 118),
                                AnchorPoint = vector2New(0.5, 0.5),
                                BackgroundTransparency = 1,
                                Position = udim2New(0.5, 0, 0.5, 0),
                                Size = udim2New(1, 10, 1, 10),
                                Name = "blur"
                            }),
                            library:Create("TextBox", {
                                Tags = {
                                    { "TextColor3", "Foreground" }
                                },
                                FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                                FontSize = Enum.FontSize.Size14,
                                PlaceholderText = "Search...",
                                Text = "",
                                TextSize = 13,
                                TextXAlignment = Enum.TextXAlignment.Left,
                                AnchorPoint = vector2New(0, 0.5),
                                BackgroundTransparency = 1,
                                Position = udim2New(0, 8, 0.5, 0),
                                Size = udim2New(1, -36, 1, 0),
                                ZIndex = 2,
                                Name = "input"
                            }),
                            library:Create("ImageLabel", {
                                Image = "rbxassetid://10189246022",
                                AnchorPoint = vector2New(1, 0.5),
                                BackgroundTransparency = 1,
                                Position = udim2New(1, -4, 0.5, 0),
                                Size = udim2New(0, 20, 0, 20),
                                ZIndex = 2,
                                Name = "icon"
                            })
                        }),
                        library:Create("TextButton", {
                            Tags = {
                                { "BackgroundColor3", "SectionBackground" }
                            },
                            FontFace = fontNew("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                            FontSize = Enum.FontSize.Size14,
                            Text = "",
                            TextSize = 14,
                            AutoButtonColor = false,
                            AnchorPoint = vector2New(1, 0.5),
                            Position = udim2New(1, -9, 0.5, 0),
                            Size = udim2New(0, 28, 0, 28),
                            ZIndex = 2,
                            Name = "languages"
                        }, {
                            library:Create("UIStroke", {
                                Tags = {
                                    { "Color", "MainBorder" }
                                },
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Name = "stroke"
                            }),
                            library:Create("UICorner", {
                                CornerRadius = udimNew(0, 3),
                                Name = "corner"
                            }),
                            library:Create("ImageLabel", {
                                Image = "rbxassetid://11713635784",
                                AnchorPoint = vector2New(0.5, 0.5),
                                BackgroundTransparency = 1,
                                Position = udim2New(0.5, 0, 0.5, 0),
                                Size = udim2New(0, 22, 0, 22),
                                ZIndex = 2,
                                Name = "icon"
                            }),
                            library:Create("ImageLabel", {
                                Tags = {
                                    { "ImageColor3", "Shadow" }
                                },
                                Image = "rbxassetid://10189254800",
                                ScaleType = Enum.ScaleType.Slice,
                                SliceCenter = rectNew(10, 10, 118, 118),
                                AnchorPoint = vector2New(0.5, 0.5),
                                BackgroundTransparency = 1,
                                Position = udim2New(0.5, 0, 0.5, 0),
                                Size = udim2New(1, 10, 1, 10),
                                Name = "blur"
                            })
                        })
                    }),
                    library:Create("Frame", {
                        AnchorPoint = vector2New(0, 0.5),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        ClipsDescendants = true,
                        Position = udim2New(0, 0, 0.5, 0),
                        Size = udim2New(0, 160, 1, 0),
                        Name = "left"
                    }, {
                        library:Create("TextLabel", {
                            Tags = {
                                { "TextColor3", "Foreground" }
                            },
                            FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal),
                            FontSize = Enum.FontSize.Size24,
                            Text = "Ocy V4\n" .. library.Title,
                            TextSize = 22,
                            TextWrap = true,
                            TextWrapped = true,
                            AnchorPoint = vector2New(0.5, 0),
                            BackgroundTransparency = 1,
                            Position = udim2New(0.5, 0, 0, 10),
                            Size = udim2New(1, -24, 0, 52),
                            Name = "title"
                        }),
                        library:Create("ScrollingFrame", {
                            CanvasSize = udim2New(0, 0, 0, 0),
                            ScrollBarThickness = 0,
                            ScrollingDirection = Enum.ScrollingDirection.X,
                            Active = true,
                            AnchorPoint = vector2New(0.5, 1),
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            Position = udim2New(0.5, 0, 1, -8),
                            Size = udim2New(1, -16, 1, -82),
                            Name = "container"
                        }, {
                            library:Create("UIListLayout", {
                                Padding = udimNew(0, 4),
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                Name = "list"
                            })
                        })
                    }),
                    library:Create("Frame", {
                        Tags = {
                            { "BackgroundColor3", "MainBorder" }
                        },
                        AnchorPoint = vector2New(1, 1),
                        BorderSizePixel = 0,
                        Position = udim2New(1, 0, 1, -28),
                        Size = udim2New(1, -161, 0, 1),
                        Name = "separator"
                    }),
                    library:Create("Frame", {
                        AnchorPoint = vector2New(1, 1),
                        BackgroundTransparency = 1,
                        ClipsDescendants = true,
                        Position = udim2New(1, 0, 1, 0),
                        Size = udim2New(1, -161, 0, 28),
                        Name = "bottom"
                    }, {
                        library:Create("TextLabel", {
                            Tags = {
                                { "TextColor3", "Foreground" }
                            },
                            FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                            FontSize = Enum.FontSize.Size14,
                            Text = library.Version,
                            TextSize = 13,
                            TextXAlignment = Enum.TextXAlignment.Right,
                            AnchorPoint = vector2New(0.5, 0.5),
                            BackgroundTransparency = 1,
                            Position = udim2New(0.5, 0, 0.5, 0),
                            Size = udim2New(1, -16, 1, 0),
                            Name = "version"
                        }),
                        library:Create("TextLabel", {
                            Tags = {
                                { "TextColor3", "Foreground" }
                            },
                            FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                            FontSize = Enum.FontSize.Size14,
                            Text = library.Discord,
                            TextSize = 13,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            AnchorPoint = vector2New(0.5, 0.5),
                            BackgroundTransparency = 1,
                            Position = udim2New(0.5, 0, 0.5, 0),
                            Size = udim2New(1, -16, 1, 0),
                            Name = "discord"
                        })
                    }),
                    library:Create("Frame", {
                        Tags = {
                            { "BackgroundColor3", "MainBorder" }
                        },
                        AnchorPoint = vector2New(1, 1),
                        BorderSizePixel = 0,
                        Position = udim2New(1, 0, 1, -57),
                        Size = udim2New(1, -161, 0, 1),
                        Name = "separator"
                    }),
                    library:Create("Folder", {
                        Name = "container"
                    })
                })
            }),
            library:Create("Folder", {
                Name = "dropignores"
            }),
            library:Create("ScreenGui", {
                DisplayOrder = 11,
                ResetOnSpawn = false,
                Name = "popups"
            }, {
                library:Create("Frame", {
                    Tags = {
                        { "BackgroundColor3", "MainBackground" }
                    },
                    Position = udim2New(0, 1360, 0, 326),
                    Visible = false,
                    Size = udim2New(0, 179, 0, 12),
                    Name = "drop"
                }, {
                    library:Create("TextButton", {
                        AnchorPoint = vector2New(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Text = "",
                        Position = udim2New(0.5, 0, 0.5, 0),
                        Size = udim2New(1, 0, 1, 0),
                        Name = "block"
                    }),
                    library:Create("UICorner", {
                        CornerRadius = udimNew(0, 3),
                        Name = "corner"
                    }),
                    library:Create("UIStroke", {
                        Tags = {
                            { "Color", "MainBorder" }
                        },
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Name = "stroke"
                    }),
                    library:Create("ImageLabel", {
                        Tags = {
                            { "ImageColor3", "MainBackground" }
                        },
                        Image = "rbxassetid://10189254800",
                        ScaleType = Enum.ScaleType.Slice,
                        SliceCenter = rectNew(10, 10, 118, 118),
                        AnchorPoint = vector2New(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Position = udim2New(0.5, 0, 0.5, 0),
                        Size = udim2New(1, 10, 1, 10),
                        ZIndex = 0,
                        Name = "blur"
                    }),
                    library:Create("ScrollingFrame", {
                        Tags = {
                            { "ScrollBarImageColor3", "MainBorder" }
                        },
                        BottomImage = "rbxassetid://10189246540",
                        CanvasSize = udim2New(0, 0, 0, 0),
                        MidImage = "rbxassetid://10189246358",
                        ScrollBarThickness = 4,
                        TopImage = "rbxassetid://10189246196",
                        VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
                        Active = true,
                        AnchorPoint = vector2New(0.5, 0.5),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Position = udim2New(0.5, 0, 0.5, 0),
                        Size = udim2New(1, -8, 1, -8),
                        Name = "container"
                    }, {
                        library:Create("UIListLayout", {
                            Padding = udimNew(0, 4),
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            Name = "list"
                        }),
                        library:Create("UIPadding", {
                            PaddingBottom = udimNew(0, 1),
                            PaddingLeft = udimNew(0, 1),
                            PaddingRight = udimNew(0, 1),
                            PaddingTop = udimNew(0, 1),
                            Name = "padding"
                        })
                    })
                }),
                library:Create("Frame", {
                    Tags = {
                        { "BackgroundColor3", "MainBackground" }
                    },
                    Size = udim2New(0, 199, 0, 170),
                    Name = "picker",
                    Visible = false,
                    ZIndex = 2
                }, {
                    library:Create("TextButton", {
                        AnchorPoint = vector2New(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Text = "",
                        Position = udim2New(0.5, 0, 0.5, 0),
                        Size = udim2New(1, 0, 1, 0),
                        Name = "block"
                    }),
                    library:Create("UICorner", {
                        CornerRadius = udimNew(0, 3),
                        Name = "corner"
                    }),
                    library:Create("ImageLabel", {
                        Tags = {
                            { "ImageColor3", "MainBackground" }
                        },
                        Image = "rbxassetid://10189254800",
                        ScaleType = Enum.ScaleType.Slice,
                        SliceCenter = rectNew(10, 10, 118, 118),
                        AnchorPoint = vector2New(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Position = udim2New(0.5, 0, 0.5, 0),
                        Size = udim2New(1, 10, 1, 10),
                        Name = "blur"
                    }),
                    library:Create("UIStroke", {
                        Tags = {
                            { "Color", "MainBorder" }
                        },
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Name = "stroke"
                    }),
                    library:Create("Frame", {
                        BackgroundColor3 = colorFromHex("ffffff"),
                        Position = udim2New(0, 6, 0, 6),
                        Size = udim2New(0, 129, 0, 100),
                        Name = "sat",
                        ZIndex = 2
                    }, {
                        library:Create("UICorner", {
                            CornerRadius = udimNew(0, 3),
                            Name = "corner"
                        }),
                        library:Create("UIStroke", {
                            Tags = {
                                { "Color", "MainBorder" }
                            },
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                            Name = "stroke"
                        }),
                        library:Create("UIGradient", {
                            Color = colorSequenceNew({
                                colorSequenceKeypointNew(0, colorNew(1, 1, 1)),
                                colorSequenceKeypointNew(1, colorNew(0, 0.250980406999588, 1))
                            }),
                            Name = "gradient"
                        }),
                        library:Create("Frame", {
                            AnchorPoint = vector2New(0.5, 0.5),
                            BackgroundColor3 = colorFromHex("ffffff"),
                            Position = udim2New(0.5, 0, 0.5, 0),
                            Size = udim2New(1, 0, 1, 0),
                            Name = "val",
                            ZIndex = 2
                        }, {
                            library:Create("UICorner", {
                                CornerRadius = udimNew(0, 3),
                                Name = "corner"
                            }),
                            library:Create("UIStroke", {
                                Tags = {
                                    { "Color", "MainBorder" }
                                },
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Name = "stroke"
                            }),
                            library:Create("UIGradient", {
                                Color = colorSequenceNew(colorNew(0, 0, 0)),
                                Rotation = 270,
                                Transparency = numberSequenceNew({
                                    numberSequenceKeypointNew(0, 0),
                                    numberSequenceKeypointNew(1, 1)
                                }),
                                Name = "gradient"
                            })
                        }),
                        library:Create("Frame", {
                            Tags = {
                                { "BackgroundColor3", "Accent" }
                            },
                            AnchorPoint = vector2New(0.5, 0.5),
                            Position = udim2New(0.61, 0, 0.15, 0),
                            Size = udim2New(0, 12, 0, 12),
                            ZIndex = 3,
                            Name = "indicator"
                        }, {
                            library:Create("UIStroke", {
                                Tags = {
                                    { "Color", "MainBorder" }
                                },
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Name = "stroke"
                            }),
                            library:Create("UICorner", {
                                CornerRadius = udimNew(1, 0),
                                Name = "corner"
                            })
                        })
                    }),
                    library:Create("Frame", {
                        BackgroundColor3 = colorFromHex("ffffff"),
                        Position = udim2New(0, 142, 0, 6),
                        Size = udim2New(0, 22, 0, 100),
                        Name = "hue",
                        ZIndex = 2
                    }, {
                        library:Create("UICorner", {
                            CornerRadius = udimNew(0, 3),
                            Name = "corner"
                        }),
                        library:Create("UIStroke", {
                            Tags = {
                                { "Color", "MainBorder" }
                            },
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                            Name = "stroke"
                        }),
                        library:Create("UIGradient", {
                            Color = colorSequenceNew({
                                colorSequenceKeypointNew(0, colorNew(1, 0, 0.01568627543747425)),
                                colorSequenceKeypointNew(0.1666666716337204, colorNew(1, 0, 1)),
                                colorSequenceKeypointNew(0.3333333134651184, colorNew(0, 0, 1)),
                                colorSequenceKeypointNew(0.5, colorNew(0, 1, 1)),
                                colorSequenceKeypointNew(0.6666659712791443, colorNew(0, 1, 0)),
                                colorSequenceKeypointNew(0.8333333134651184, colorNew(1, 1, 0)),
                                colorSequenceKeypointNew(1, colorNew(1, 0, 0))
                            }),
                            Rotation = 270,
                            Name = "gradient"
                        }),
                        library:Create("Frame", {
                            AnchorPoint = vector2New(0.5, 0.5),
                            BackgroundColor3 = colorFromHex("0040ff"),
                            Position = udim2New(0.5, 0, 0.627, 0),
                            Size = udim2New(1, 0, 0, 8),
                            Name = "indicator",
                            ZIndex = 2
                        }, {
                            library:Create("UIStroke", {
                                Tags = {
                                    { "Color", "MainBorder" }
                                },
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Name = "stroke"
                            }),
                            library:Create("UICorner", {
                                CornerRadius = udimNew(0, 3),
                                Name = "corner"
                            })
                        })
                    }),
                    library:Create("ImageLabel", {
                        Image = "rbxassetid://10192779762",
                        BackgroundTransparency = 1,
                        Position = udim2New(0, 171, 0, 6),
                        Size = udim2New(0, 22, 0, 100),
                        Name = "alpha",
                        ZIndex = 2
                    }, {
                        library:Create("UICorner", {
                            CornerRadius = udimNew(0, 3),
                            Name = "corner"
                        }),
                        library:Create("UIStroke", {
                            Tags = {
                                { "Color", "MainBorder" }
                            },
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                            Name = "stroke"
                        }),
                        library:Create("Frame", {
                            AnchorPoint = vector2New(0.5, 0.5),
                            BackgroundColor3 = colorFromHex("ffffff"),
                            Position = udim2New(0.5, 0, 0.5, 0),
                            Size = udim2New(1, 0, 1, 0),
                            Name = "cover",
                            ZIndex = 2
                        }, {
                            library:Create("UIGradient", {
                                Color = colorSequenceNew({
                                    colorSequenceKeypointNew(0, colorNew(0.3294117748737335, 0.45098039507865906, 0.8470588326454163)),
                                    colorSequenceKeypointNew(1, colorNew(0.3294117748737335, 0.45098039507865906, 0.8470588326454163))
                                }),
                                Rotation = 270,
                                Transparency = numberSequenceNew({
                                    numberSequenceKeypointNew(0, 0),
                                    numberSequenceKeypointNew(1, 1)
                                }),
                                Name = "gradient"
                            }),
                            library:Create("UIStroke", {
                                Tags = {
                                    { "Color", "MainBorder" }
                                },
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Name = "stroke"
                            }),
                            library:Create("UICorner", {
                                CornerRadius = udimNew(0, 3),
                                Name = "corner"
                            })
                        }),
                        library:Create("Frame", {
                            Tags = {
                                { "BackgroundColor3", "Accent" }
                            },
                            AnchorPoint = vector2New(0.5, 0.5),
                            Position = udim2New(0.5, 0, 0.7, 0),
                            Size = udim2New(1, 0, 0, 8),
                            Name = "indicator",
                            ZIndex = 2
                        }, {
                            library:Create("UIStroke", {
                                Tags = {
                                    { "Color", "MainBorder" }
                                },
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Name = "stroke"
                            }),
                            library:Create("UICorner", {
                                CornerRadius = udimNew(0, 3),
                                Name = "corner"
                            })
                        })
                    }),
                    library:Create("TextBox", {
                        Tags = {
                            { "BackgroundColor3", "SectionBackground" },
                            { "PlaceholderColor3", "PlaceholderForeground" },
                            { "TextColor3", "Foreground" }
                        },
                        FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                        FontSize = Enum.FontSize.Size12,
                        PlaceholderText = "Hex",
                        Text = "#5473d8",
                        TextSize = 12,
                        Position = udim2New(0, 6, 0, 113),
                        Size = udim2New(0, 90, 0, 22),
                        Name = "hex",
                        ZIndex = 2
                    }, {
                        library:Create("UICorner", {
                            CornerRadius = udimNew(0, 3),
                            Name = "corner"
                        }),
                        library:Create("UIStroke", {
                            Tags = {
                                { "Color", "MainBorder" }
                            },
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                            Name = "stroke"
                        })
                    }),
                    library:Create("TextBox", {
                        Tags = {
                            { "BackgroundColor3", "SectionBackground" },
                            { "PlaceholderColor3", "PlaceholderForeground" },
                            { "TextColor3", "Foreground" }
                        },
                        FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                        FontSize = Enum.FontSize.Size12,
                        PlaceholderText = "RGB",
                        Text = "255, 255, 255",
                        TextSize = 12,
                        AnchorPoint = vector2New(1, 0),
                        Position = udim2New(1, -6, 0, 113),
                        Size = udim2New(0, 90, 0, 22),
                        Name = "rgb",
                        ZIndex = 2
                    }, {
                        library:Create("UICorner", {
                            CornerRadius = udimNew(0, 3),
                            Name = "corner"
                        }),
                        library:Create("UIStroke", {
                            Tags = {
                                { "Color", "MainBorder" }
                            },
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                            Name = "stroke"
                        })
                    }),
                    library:Create("TextButton", {
                        FontFace = fontNew("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                        FontSize = Enum.FontSize.Size14,
                        Text = "",
                        AutoButtonColor = false,
                        AnchorPoint = vector2New(1, 1),
                        BackgroundTransparency = 1,
                        Position = udim2New(1, -5, 1, -5),
                        Size = udim2New(0.5, -8, 0, 24),
                        Name = "sync",
                        ZIndex = 2
                    }, {
                        library:Create("Frame", {
                            Tags = {
                                { "BackgroundColor3", "ItemBackground" }
                            },
                            AnchorPoint = vector2New(1, 0.5),
                            Position = udim2New(1, -1, 0.5, 0),
                            Size = udim2New(0, 22, 0, 22),
                            ZIndex = 2,
                            Name = "indicator"
                        }, {
                            library:Create("UIStroke", {
                                Tags = {
                                    { "Color", "MainBorder" }
                                },
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Name = "stroke"
                            }),
                            library:Create("UICorner", {
                                CornerRadius = udimNew(0, 3),
                                Name = "corner"
                            }),
                            library:Create("ImageLabel", {
                                Image = "rbxassetid://10221888170",
                                ImageTransparency = 1,
                                AnchorPoint = vector2New(0.5, 0.5),
                                BackgroundTransparency = 1,
                                Position = udim2New(0.5, 0, 0.5, 0),
                                Size = udim2New(0, 18, 0, 18),
                                Name = "icon",
                                ZIndex = 2
                            })
                        }),
                        library:Create("TextLabel", {
                            Tags = {
                                { "TextColor3", "Foreground" }
                            },
                            FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                            FontSize = Enum.FontSize.Size12,
                            Text = "Sync",
                            TextSize = 12,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            AnchorPoint = vector2New(0.5, 0.5),
                            BackgroundTransparency = 1,
                            Position = udim2New(0.5, 0, 0.5, 0),
                            Size = udim2New(1, -4, 1, 0),
                            Name = "title",
                            ZIndex = 2
                        })
                    }),
                    library:Create("TextButton", {
                        FontFace = fontNew("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                        FontSize = Enum.FontSize.Size14,
                        Text = "",
                        AutoButtonColor = false,
                        AnchorPoint = vector2New(0, 1),
                        BackgroundTransparency = 1,
                        Position = udim2New(0, 5, 1, -5),
                        Size = udim2New(0.5, -8, 0, 24),
                        Name = "rainbow",
                        ZIndex = 2
                    }, {
                        library:Create("Frame", {
                            Tags = {
                                { "BackgroundColor3", "ItemBackground" }
                            },
                            AnchorPoint = vector2New(1, 0.5),
                            Position = udim2New(1, -1, 0.5, 0),
                            Size = udim2New(0, 22, 0, 22),
                            Name = "indicator",
                            ZIndex = 2
                        }, {
                            library:Create("UIStroke", {
                                Tags = {
                                    { "Color", "MainBorder" }
                                },
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Name = "stroke"
                            }),
                            library:Create("UICorner", {
                                CornerRadius = udimNew(0, 3),
                                Name = "corner"
                            }),
                            library:Create("ImageLabel", {
                                Image = "rbxassetid://10221888170",
                                ImageTransparency = 1,
                                AnchorPoint = vector2New(0.5, 0.5),
                                BackgroundTransparency = 1,
                                Position = udim2New(0.5, 0, 0.5, 0),
                                Size = udim2New(0, 18, 0, 18),
                                Name = "icon",
                                ZIndex = 2
                            })
                        }),
                        library:Create("TextLabel", {
                            Tags = {
                                { "TextColor3", "Foreground" }
                            },
                            FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                            FontSize = Enum.FontSize.Size12,
                            Text = "Rainbow",
                            TextSize = 12,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            AnchorPoint = vector2New(0.5, 0.5),
                            BackgroundTransparency = 1,
                            Position = udim2New(0.5, 0, 0.5, 0),
                            Size = udim2New(1, -4, 1, 0),
                            Name = "title",
                            ZIndex = 2
                        })
                    })
                })
            }),
            library:Create("ScreenGui", {
                DisplayOrder = 12,
                ResetOnSpawn = false,
                Name = "notifications"
            }, {
                library:Create("Frame", {
                    AnchorPoint = vector2New(1, 0.5),
                    BackgroundTransparency = 1,
                    Position = udim2New(1, -15, 0.5, 0),
                    Size = udim2New(0, 300, 1, -30),
                    Name = "panel"
                }, {
                    library:Create("UIListLayout", {
                        Padding = udimNew(0, 10),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        VerticalAlignment = Enum.VerticalAlignment.Bottom,
                        Name = "list"
                    })
                })
            })
        });

        Ocy.Tracer:LogInstance(library.Directory);

        if #library.Storage > 0 then
            library.Store = library:Create("Folder", {
                Name = "storage",
                Parent = library.Directory
            });
            for i = 1, #library.Storage do
                library:Create("Folder", {
                    Name = library.Storage[i],
                    Parent = library.Store
                });
            end
        end

        local main = library.Directory.gui.main;

        connect(main.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and library.Settings.Dragging == false then
                library.Settings.Dragging = true;
                local offset = vector2New(main.AbsoluteSize.X * main.AnchorPoint.X, main.AbsoluteSize.Y * main.AnchorPoint.Y);
                local pos = vector2New(mouse.X - (main.AbsolutePosition.X + offset.X), mouse.Y - (main.AbsolutePosition.Y + offset.Y));
                local mouseMove = connect(mouse.Move, function()
                    tween(main, library.Settings.DragLeniency, { Position = udim2New(0, mouse.X - pos.X, 0, mouse.Y - pos.Y) });
                end);
                local inputEnded; inputEnded = connect(input.Changed, function()
                    if input.UserInputState == Enum.UserInputState.End then
                        disconnect(mouseMove);
                        disconnect(inputEnded);
                        library.Settings.Dragging = false;
                    end
                end);
            end
        end);

        connect(main.top.languages.MouseButton1Click, function()
            library:Notify({
                Title = "NotImplemented",
                Message = "Languages have not been implemented yet."
            });
        end);

        connect(getPropertyChangedSignal(main.top.search.input, "Text"), function()
            library:Search(main.top.search.input.Text);
        end);

        Ocy.Tracer:Connect(runService.Heartbeat, function()
            library.Options.Settings.SyncedHue = tick() % library.Settings.RainbowDuration / library.Settings.RainbowDuration;
        end);

        Ocy.Tracer:Connect(userInputService.InputBegan, function(input)
            if library.Settings.Binding == false and userInputService:GetFocusedTextBox() == nil then
                local enumItem = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType;
                if enumItem.Name ~= "Escape" then
                    for _, v in next, library.Items do
                        if v.Class == "Bind" and v.Value.Key == enumItem and (v.Value.Dependency == nil or userInputService:IsKeyDown(v.Value.Dependency)) then
                            task.spawn(v.OnKeyDown);
                        end
                    end
                end
            end
        end);

        Ocy.Tracer:Connect(userInputService.InputEnded, function(input)
            if library.Settings.Binding == false and userInputService:GetFocusedTextBox() == nil then
                local enumItem = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType;
                if enumItem.Name ~= "Escape" then
                    for _, v in next, library.Items do
                        if v.Class == "Bind" and v.Value.Key == enumItem and (v.Value.Dependency == nil or userInputService:IsKeyDown(v.Value.Dependency)) then
                            task.spawn(v.OnKeyUp);
                        end
                    end
                end
            end
        end);

        autoResize(library.Directory.popups.drop.container.list, library.Directory.popups.drop.container, 0);
        safeParent(library.Directory);

        return library;
    end

    function Library:Search(query)
        local newQuery = stringLower(query);
        for _, v in next, self.Items do
            v.Frame.Visible = stringFind(stringLower(v.Title), newQuery) ~= nil;
        end
    end

    function Library:Create(class, props, children)
        local inst = instanceNew(class);
        for i, v in next, props do
            if i == "Tags" then
                for i2 = 1, #v do
                    local property, tag, check = unpack(v[i2]);
                    if check == nil or check() then
                        inst[property] = self.Theme.Data[tag];
                    end
                    self.Theme:AddInstance(inst, property, tag, check);
                end
            elseif i ~= "Parent" then
                inst[i] = v;
            end
        end
        if children then
            for i = 1, #children do
                children[i].Parent = inst;
            end
        end
        inst.Parent = props.Parent;
        return inst;
    end

    function Library:AddTab(options)
        return Tab.new(self, options);
    end

    function Library:AddSeparator()
        self:Create("Frame", {
            Tags = {
                { "BackgroundColor3", "MainBorder" }
            },
            BorderSizePixel = 0,
            Parent = self.Directory.gui.main.left.container,
            Size = udim2New(1, 0, 0, 1),
            Name = "Separator"
        }, {
            self:Create("UIGradient", {
                Transparency = numberSequenceNew({
                    numberSequenceKeypointNew(0, 1),
                    numberSequenceKeypointNew(0.18, 0),
                    numberSequenceKeypointNew(0.82, 0),
                    numberSequenceKeypointNew(1, 1)
                }),
                Name = "gradient"
            })
        });
    end

    function Library:Notify(options)
        local notification = mergeTables({
            Title = "Notification",
            Message = "This is a notification.",
            Duration = 5,
            Buttons = { "Dismiss" },
            Callback = function() end
        }, options);

        local frame = self:Create("Frame", {
            Parent = self.Directory.notifications.panel,
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Size = udim2New(1, 0, 0, getTextBoundsAsync(textService, self:Create("GetTextBoundsParams", {
                Text = notification.Message,
                Font = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                Size = 13,
                Width = 274
            })).Y + 55),
            Name = notification.Title
        }, {
            self:Create("Frame", {
                Tags = {
                    { "BackgroundColor3", "MainBackground" }
                },
                AnchorPoint = vector2New(0.5, 0.5),
                Position = udim2New(2, 0, 0.5, 0),
                Size = udim2New(1, 0, 1, 0),
                Name = "container"
            }, {
                self:Create("UICorner", {
                    CornerRadius = udimNew(0, 3),
                    Name = "corner"
                }),
                self:Create("ImageLabel", {
                    Tags = {
                        { "ImageColor3", "MainBackground" }
                    },
                    Image = "rbxassetid://10189254800",
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = rectNew(10, 10, 118, 118),
                    AnchorPoint = vector2New(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = udim2New(0.5, 0, 0.5, 0),
                    Size = udim2New(1, 8, 1, 8),
                    ZIndex = 0,
                    Name = "blur"
                }),
                self:Create("TextLabel", {
                    Tags = {
                        { "TextColor3", "Foreground" }
                    },
                    FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    FontSize = Enum.FontSize.Size14,
                    Text = notification.Message,
                    TextSize = 13,
                    TextWrap = true,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AnchorPoint = vector2New(0.5, 0),
                    BackgroundTransparency = 1,
                    Position = udim2New(0.5, 0, 0, 13),
                    Size = udim2New(1, -26, 1, -55),
                    Name = "desc"
                }),
                self:Create("Frame", {
                    AnchorPoint = vector2New(1, 1),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = udim2New(1, -10, 1, -10),
                    Size = udim2New(1, -20, 0, 22),
                    Name = "container"
                }, {
                    self:Create("UIListLayout", {
                        Padding = udimNew(0, 6),
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Right,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Name = "list"
                    })
                }),
                self:Create("Frame", {
                    Tags = {
                        { "BackgroundColor3", "Accent" }
                    },
                    AnchorPoint = vector2New(0, 1),
                    BorderSizePixel = 0,
                    Position = udim2New(0, 0, 1, 0),
                    Size = udim2New(0, 0, 0, 6),
                    Name = "timeout"
                }, {
                    self:Create("UICorner", {
                        CornerRadius = udimNew(0, 3),
                        Name = "corner"
                    }),
                    self:Create("Frame", {
                        Tags = {
                            { "BackgroundColor3", "MainBackground" }
                        },
                        AnchorPoint = vector2New(0.5, 0),
                        BorderSizePixel = 0,
                        Position = udim2New(0.5, 0, 0, 0),
                        Size = udim2New(1, 0, 0.5, 0),
                        Name = "cover"
                    })
                })
            })
        });

        tween(frame.container, 0.5, { Position = udim2New(0.5, 0, 0.5, 0) }, Enum.EasingStyle.Quart);

        local function dismiss(argument)
            if frame.Parent ~= nil then
                tween(frame, 0.5, { Size = udim2New(1, 0, 0, 0) }, Enum.EasingStyle.Quart);
                connect(tween(frame.container, 1, { Position = udim2New(2, 0, 0.5, 0) }, Enum.EasingStyle.Quart).Completed, function()
                    destroy(frame);
                end);
                notification.Callback(argument);
            end
        end

        for index = 1, #notification.Buttons do
            local buttonName = notification.Buttons[index];
            local name = tostring(buttonName);

            local button = self:Create("TextButton", {
                Tags = {
                    { "BackgroundColor3", "SectionBackground" },
                    { "TextColor3", "Accent" }
                },
                Parent = frame.container.container,
                FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                FontSize = Enum.FontSize.Size14,
                Text = name,
                TextSize = 13,
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = udim2New(0, 30, 1, 0),
                Name = name
            }, {
                self:Create("UICorner", {
                    CornerRadius = udimNew(0, 3),
                    Name = "corner"
                })
            });

            button.Size = udim2New(0, getTextBoundsAsync(textService, self:Create("GetTextBoundsParams", {
                Text = name,
                Font = button.FontFace,
                Size = 14,
                Width = math.huge
            })).X + 10, 1, 0);

            connect(button.MouseEnter, function()
                tween(button, 0.25, { BackgroundTransparency = 0 });
            end);

            connect(button.MouseLeave, function()
                tween(button, 0.25, { BackgroundTransparency = 1 });
            end);

            connect(button.MouseButton1Click, function()
                dismiss(name);
            end);
        end

        connect(tween(frame.container.timeout, notification.Duration, { Size = udim2New(1, 0, 0, 6) }, Enum.EasingStyle.Linear).Completed, function()
            dismiss("Timeout");
        end);
    end

    function Library:Popup(options)
        local popup = mergeTables({
            Title = "Popup",
            Message = "This is a popup.",
            Buttons = {},
            Callback = function() end
        }, options);

        local frame = self:Create("Frame", {
            Tags = {
                { "BackgroundColor3", "MainBackground" }
            },
            Parent = self.Directory.popups,
            AnchorPoint = vector2New(0.5, 0.5),
            Position = udim2New(0.5, 0, -1, 0),
            Size = udim2New(0, 300, 0, 150),
            ZIndex = 2,
            Name = popup.Title,
        }, {
            self:Create("UICorner", {
                CornerRadius = udimNew(0, 3),
                Name = "corner"
            }),
            self:Create("UIStroke", {
                Tags = {
                    { "Color", "MainBorder" }
                },
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Name = "stroke"
            }),
            self:Create("ImageLabel", {
                Tags = {
                    { "ImageColor3", "MainBackground" }
                },
                Image = "rbxassetid://10189254800",
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = rectNew(10, 10, 118, 118),
                AnchorPoint = vector2New(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = udim2New(0.5, 0, 0.5, 0),
                Size = udim2New(1, 10, 1, 10),
                Name = "blur"
            }),
            self:Create("Frame", {
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Size = udim2New(1, 0, 1, 0),
                ZIndex = 2,
                Name = "container"
            }, {
                self:Create("Frame", {
                    AnchorPoint = vector2New(0.5, 1),
                    BackgroundTransparency = 1,
                    Position = udim2New(0.5, 0, 1, -12),
                    Size = udim2New(1, 0, 0, 26),
                    ZIndex = 2,
                    Name = "buttons"
                }, {
                    self:Create("UIListLayout", {
                        Padding = udimNew(0, 6),
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Name = "list"
                    }),
                    self:Create("UIPadding", {
                        PaddingBottom = udimNew(0, 1),
                        PaddingLeft = udimNew(0, 1),
                        PaddingRight = udimNew(0, 1),
                        PaddingTop = udimNew(0, 1),
                        Name = "padding"
                    })
                }),
                self:Create("TextLabel", {
                    Tags = {
                        { "TextColor3", "Foreground" }
                    },
                    FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    FontSize = Enum.FontSize.Size14,
                    Text = popup.Message,
                    TextSize = 14,
                    TextWrap = true,
                    TextWrapped = true,
                    AnchorPoint = vector2New(0.5, 0),
                    BackgroundTransparency = 1,
                    Position = udim2New(0.5, 0, 0, 40),
                    Size = udim2New(1, -32, 1, -90),
                    ZIndex = 2,
                    Name = "contents"
                }),
                self:Create("TextLabel", {
                    Tags = {
                        { "TextColor3", "Foreground" }
                    },
                    FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                    FontSize = Enum.FontSize.Size18,
                    Text = popup.Title,
                    TextSize = 16,
                    TextWrap = true,
                    TextWrapped = true,
                    AnchorPoint = vector2New(0.5, 0),
                    BackgroundTransparency = 1,
                    Position = udim2New(0.5, 0, 0, 0),
                    Size = udim2New(1, 0, 0, 40),
                    ZIndex = 2,
                    Name = "title"
                })
            })
        })

        for i = 1, #popup.Buttons do
            local button = popup.Buttons[i];
            local btn = self:Create("TextButton", {
                Tags = {
                    { "BackgroundColor3", "SectionBackground" },
                    { "TextColor3", "Foreground" }
                },
                Parent = frame.container.buttons,
                FontFace = fontNew("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                FontSize = Enum.FontSize.Size14,
                Text = button,
                TextSize = 13,
                AutoButtonColor = false,
                Size = udim2New(0, 57, 1, 0),
                ZIndex = 2,
                Name = button
            }, {
                self:Create("UICorner", {
                    CornerRadius = udimNew(0, 3),
                    Name = "corner"
                }),
                self:Create("UIStroke", {
                    Tags = {
                        { "Color", "MainBorder" }
                    },
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Name = "stroke"
                })
            })

            local textx = getTextBoundsAsync(textService, self:Create("GetTextBoundsParams", {
                Text = button,
                Font = btn.FontFace,
                Size = 13,
                Width = math.huge
            })).X

            btn.Size = udim2New(0, textx + 16, 1, 0)

            connect(btn.MouseButton1Click, function()
                connect(tween(frame, 0.25, { Size = udim2New() }).Completed, function()
                    destroy(frame);
                end)
                popup.Callback(button);
            end)
        end

        local yDesc = getTextBoundsAsync(textService, self:Create("GetTextBoundsParams", {
            Text = popup.Message,
            Font = frame.container.contents.FontFace,
            Size = 14,
            Width = 268
        })).Y

        tween(frame, 0.25, { Size = udim2New(0, 300, 0, yDesc + 90) });
        tween(frame, 1, { Position = udim2New(0.5, 0, 0.5, 0) }, Enum.EasingStyle.Quart);
    end

    function Library:AddSettings()
        local settingsTab = self:AddTab({ Title = "Settings", Icon = self.Icons.Settings });

        local customiseSec = settingsTab:AddSection();

        local themeSub = customiseSec:AddSubsection({ Title = "Themes" }):Select();
        themeSub:AddDropdown({ Title = "Saved Themes", Flag = "SavedThemes", Items = self.Theme:Get(), Ignore = true, AllowNoValue = true });
        themeSub:AddButton({ Title = "Load Theme", Flag = "LoadTheme", Callback = function()
            local theme = self.Flags.SavedThemes[1];
            if theme then
                self.Theme:Load(theme);
            end
        end });
        themeSub:AddButton({ Title = "Delete Theme", Flag = "DeleteTheme", Callback = function()
            local theme = self.Flags.SavedThemes[1];
            if theme then
                self:Popup({
                    Title = "DeleteTheme",
                    Message = string.format("Are you sure you want to delete theme '%s'?", theme),
                    Buttons = { "Yes", "No" },
                    Callback = function(result)
                        if result == "Yes" then
                            self.Theme:Delete(theme);
                            self.Items.SavedThemes:Refresh(self.Theme:Get());
                        end
                    end
                })
            end
        end });
        themeSub:AddButton({ Title = "Refresh List", Flag = "RefreshThemes", Callback = function()
            self.Items.SavedThemes:Refresh(self.Theme:Get());
        end });
        for i, v in next, self.Theme.Data do
            themeSub:AddPicker({ Title = splitIndicator(i), Flag = i, Ignore = true, Color = v, Callback = function(colour, alpha)
                self.Theme[i] = colour;
            end });
        end
        themeSub:AddBox({ Title = "Theme Name", Flag = "ThemeName", Ignore = true });
        themeSub:AddButton({ Title = "Save Theme", Flag = "SaveTheme", Callback = function()
            local value = self.Flags.ThemeName;
            if #value > 0 then
                self.Theme:Save(value);
                self.Items.SavedThemes:Refresh(self.Theme:Get());
            else
                self:Notify({
                    Title = "NoThemeNameInputted",
                    Message = "You haven't provided a name for your Theme"
                });
            end
        end });

        local configSub = customiseSec:AddSubsection({ Title = "Configs" });
        configSub:AddDropdown({ Title = "Saved Configs", Flag = "SavedConfigs", Items = self.Configs:Get(), Ignore = true, AllowNoValue = true });
        configSub:AddButton({ Title = "Load Config", Flag = "LoadConfig", Callback = function()
            local config = self.Flags.SavedConfigs[1];
            if config then
                self.Configs:Load(config);
            end
        end });
        configSub:AddButton({ Title = "Delete Config", Flag = "DeleteConfig", Callback = function()
            local config = self.Flags.SavedConfigs[1];
            if config then
                self:Popup({
                    Title = "DeleteConfig",
                    Message = string.format("Are you sure you want to delete config '%s'?", config),
                    Buttons = { "Yes", "No" },
                    Callback = function(result)
                        if result == "Yes" then
                            self.Configs:Delete(config);
                            self.Items.SavedConfigs:Refresh(self.Configs:Get());
                        end
                    end
                })
            end
        end });
        configSub:AddButton({ Title = "Refresh List", Flag = "RefreshConfigs", Callback = function()
            self.Items.SavedConfigs:Refresh(self.Configs:Get());
        end });
        configSub:AddBox({ Title = "Config Name", Flag = "ConfigName", Ignore = true });
        configSub:AddButton({ Title = "Save Config", Flag = "SaveConfig", Callback = function()
            local value = self.Flags.ConfigName;
            if #value > 0 then
                self.Configs:Save(value);
                self.Items.SavedConfigs:Refresh(self.Configs:Get());
            else
                self:Notify({
                    Title = "NoConfigNameInputted",
                    Message = "You haven't provided a name for your Config"
                });
            end
        end });

        local instanceSec = settingsTab:AddSection({ Side = "Right" });
        
        local settingsSub = instanceSec:AddSubsection({ Title = "UI" }):Select();
        settingsSub:AddSlider({ Title = "Drag Leniency", Flag = "DragLeniency", Max = 1, Float = 0.01, Value = self.Settings.DragLeniency, Ignore = true, Callback = function(value)
            self.DragLeniency = value;
        end });
        settingsSub:AddSlider({ Title = "Rainbow Duration", Flag = "RainbowDuration", Max = 15, Float = 0.01, Value = self.Settings.RainbowDuration, Ignore = true, Callback = function(value)
            self.RainbowDuration = value;
        end });
        settingsSub:AddBind({ Title = "Toggle Key", Flag = "ToggleKey", Ignore = true, Value = { Key = Enum.KeyCode.RightAlt }, OnKeyDown = function()
            self.Open = not self.Settings.Open;
        end });

        local miscSub = instanceSec:AddSubsection({ Title = "Misc" });
        miscSub:AddToggle({ Title = "Anti AFK", Flag = "AntiAFK", Ignore = true, Callback = function(state)
            local conns = getconnections(localPlayer.Idled);
            for i = 1, #conns do
                local v = conns[i];
                if v.Enabled == state then
                    if state then
                        v:Disable();
                    else
                        v:Enable();
                    end
                end
            end
        end });
        miscSub:AddSeparator();
        miscSub:AddSlider({ Title = "FPS", Flag = "SelectedFps", Min = 1, Max = 999, Value = getfpscap and getfpscap() or 60, Validate = function(value)
            return self.Flags.vSync ~= true or (getfpsmax and mathRound(value) == mathRound(getfpsmax()));
        end, Callback = function(value)
            if self.Flags.CustomFps then
                setfpscap(value);
            end
        end });
        miscSub:AddToggle({ Title = "Unlock FPS", Flag = "CustomFps", Callback = function(state)
            setfpscap(state and self.Flags.SelectedFps or 60);
        end });
        miscSub:AddToggle({ Title = "V-Sync", Flag = "vSync", Validate = function(state)
            if state and getfpsmax == nil then
                self:Notify({
                    Title = "VSyncNotSupported",
                    Message = Ocy.Instance.Executor .. " does not support V-Sync"
                });
                return false;
            end
            return true;
        end, Callback = function(state)
            if state then
                self.Items.SelectedFps:Set(getfpsmax());
            end
        end });

        local otherSec = settingsTab:AddSection({ Side = "Right" });

        local serverHopSub = otherSec:AddSubsection({ Title = "Server" }):Select();
        serverHopSub:AddDropdown({ Title = "Preference", Flag = "ServerHopPreference", Items = { "Most Players", "Least Players", "Best Ping", "Random" }, Value = { "Most Players" }, Ignore = true });
        serverHopSub:AddToggle({ Title = "Execute On Hop", Flag = "ExecuteOnHop", Ignore = true });
        serverHopSub:AddToggle({ Title = "Hop When Kicked", Flag = "HopOnKick", Ignore = true });
        serverHopSub:AddButton({ Title = "Server Hop", Flag = "ServerHop", Callback = function(id)
            local jobId = id;
            if jobId == nil then
                local preference = self.Flags.ServerHopPreference[1];
                if preference == "Best Ping" or preference == "Random" then
                    local servers = {};
                    local cursor, count = "", 0;
                    repeat
                        local res = jsonDecode(httpService, game:HttpGetAsync(stringFormat("https://games.roblox.com/v1/games/%d/servers/0?&excludeFullGames=true&cursor=%s", game.PlaceId, cursor), true));
                        for i = 1, #res.data do
                            local v = res.data[i];
                            if v.id ~= game.JobId then
                                servers[#servers + 1] = v;
                            end
                        end
                        cursor = res.nextPageCursor;
                        count = count + 1;
                    until cursor == nil or count >= 10;
                    if preference == "Ping" then
                        table.sort(servers, function(a, b)
                            return a.ping < b.ping;
                        end);
                        jobId = servers[1] and servers[1].id;
                    else
                        jobId = servers[1] and servers[mathRandom(1, #servers)].id;
                    end
                else
                    local res = jsonDecode(httpService, game:HttpGetAsync(stringFormat("https://games.roblox.com/v1/games/%d/servers/0?sortOrder=%d&excludeFullGames=true&limit=10", game.PlaceId, preference == "Most Players" and 2 or 1), true));
                    for i = 1, #res.data do
                        local v = res.data[i];
                        if v.id ~= game.JobId then
                            jobId = v.id;
                            break;
                        end
                    end
                end
            end
            if jobId then
                if self.Flags.ExecuteOnHop then
					if script_key then
						queueonteleport(string.format([[
							script_key="%s";
							loadstring(game:HttpGetAsync("https://projectOcy.xyz/v4/script.lua", true))();
						]], script_key));
					else
						queueonteleport("loadstring(game:HttpGetAsync(\"https://projectOcy.xyz/v4/script.lua\", true))();");
					end
                end
                teleportToPlaceInstance(teleportService, game.PlaceId, jobId);
            end
        end });
        serverHopSub:AddButton({ Title = "Rejoin Current Server", Callback = function()
            self.Items.ServerHop:Call(game.JobId);
        end });

        Ocy.Tracer:Connect(guiService.ErrorMessageChanged, function(message)
            if table.find(blacklistedErrorMessages, message) == nil and self.Flags.HopOnKick then
                self.Items.ServerHop:Call();
            end
        end);
    end

    return Library;
end)();