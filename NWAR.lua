
  --// Noticed if your one of the devs reading this fuck you lol
  
  -- // Locals
  
  local remote = game:GetService("ReplicatedStorage"):WaitForChild("GetKilled")
  local antiragdoll = false
  local killsaybool = false
  local nofire = false
  local cooldown =  false
  local whitelist = {}
  local antiaim = false
  local autoshoot = false
  local firefolder = game:GetService("Workspace")["douseYourselfInOil"]
  local g = game
  local gunrules = require(game:GetService("ReplicatedStorage"):WaitForChild("gun_rules"))
  local plrs = g:GetService("Players")
  local modules = getloadedmodules()
  local lp = plrs.LocalPlayer
  local currenttool = {["Tool"] = nil,["Gun"] = false}
  local defcolor = Instance.new("Color3Value",script)
  defcolor.Value = Color3.fromRGB(29, 203, 255)
  
  local char = game:GetService("Players").LocalPlayer.Character or game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
  function deragdoll()
      print("Called")
     if antiragdoll == true then
         char.ragdoll:SetAttribute("ragdoll_enabled",false)
      end
  end
  local trolled = {
      "%s just wet the bed",
      "There is a bot and its name is %s",
      "Hey %s you suck so well",
      "%s got pwned",
      "This guy called %s looks at kids funny",
      "Some dude called %s was staring at kids throught the window",
      "%s Dosent know im a part of faze clan",
      "Dont report me my dad owns roblox %s !!!",
      "%s is my kitten 😈😈😈",
      "Dont call a mod %s Please!!!!",
      "%s Thinks mods actually respond",
      "%s thought there were no hackers in this game",
      "I bet %s is crying on his dads laptop rn",
      "I legit dogged so hard on %s he came out as a furry",
      "%s cant handle this ratio",
      "%s Im never gonna give you up",
      "%s googled sonic feet",
      "%s didnt realize i use OperaGx",
      "%s eats more kfc than a black guy",
      "Some guy was at burgerking and they crowned him i think it was %s",
      "%s was touched on an island",
      "Load up jjsploit you wont %s",
      "Gonna call a mod?, Gonna cry? , Maybe defecate %s? "
  }
  
  
  
  -- // Anti cheat bypass
  


  local function CODEGEN(p2)
      local v39 = nil;
      v39 = "";
      for v40 = 1, #p2 do
          v39 = v39 .. string.byte(string.sub(p2, v40, v40));
      end;
      return v39;
  end;
  
  
  
  local function RN()
      return "gun_".. getrenv()._G.RNG(math.random(-999999, 999999)) 
  end
  
  local function getfunction(name)
      for _, v in ipairs(getgc(true)) do
          if (typeof(v) == "table" and rawget(v, name)) then
              return rawget(v,name)
          end
      end
  end
  local gethumanoid = gunrules.GetHumanoid
  
  local function shoot(target,pos)
      local humanoid , BaseP = gethumanoid(target)
      if humanoid and BaseP and char:FindFirstChildWhichIsA("Tool") and cooldown == false then
          cooldown = true
          local gun = char:FindFirstChildWhichIsA("Tool")
          local ammo = gun.ammo.Value
          if not(ammo <= 0) then
              gun.ammo.Value = ammo - 1
              local gunnum = CODEGEN(tostring(gun))
              local gunid = RN()
              gun.framework.event.register:FireServer(gunid, gunnum, {pos}, gun:WaitForChild("handle").fire)
              task.wait()
              gun.framework.event.hit:FireServer(gunnum, humanoid, target, pos, gunid , BaseP.Size)
              wait(require(gun.settings).gun_data.cooldown + 0.1)
              cooldown = false
              if gun.ammo.Value == 0 then
                  gun.framework.event.reload:FireServer()
                  gun.ammo.Value = require(gun.settings).gun_data.maxammo
              end
          else
              gun.framework.event.reload:FireServer()
              gun.ammo.Value = require(gun.settings).gun_data.maxammo
              cooldown = false
          end
      end
  end
  
  
  -- // Functions 
  
  
  function chat(say,victim)
      game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(string.format(say,victim), "All")
  end
  
  function killsay(killer,victim)
      if killer == tostring(game:GetService("Players").LocalPlayer) and killsaybool == true then
          chat(trolled[math.random(1,#trolled)],victim)
      end
  end
  
  function setjp(int)
      char.Humanoid.JumpPower = int
  end
  
  local function charinit()
      
      char.ChildRemoved:Connect(function(child)
          if child:IsA("Tool") and child:FindFirstChild("settings") then
              child.framework.client_main.Disabled = false
          end
      end)
      char:WaitForChild("Humanoid"):GetPropertyChangedSignal("PlatformStand"):Connect(function()
        if antiragdoll == true then
            char.Humanoid.PlatformStand = false
        end
    end)
    char.ChildAdded:Connect(function(child)
       if child:IsA("Tool") then
           currenttool.Tool = child
           if child:FindFirstChild("framework") then
               currenttool.Gun = true
               if autoshoot == true then
                   child.framework["client_main"].Disabled = true
                end
            else
                currenttool.Gun = false
            end
        end
    end)
    char.ChildRemoved:Connect(function(child)
       if child == currenttool.Tool then
           currenttool.Tool = nil
           if currenttool.Gun == true then
               child.framework["client_main"].Disabled = false
               child.framework.event.reload:FireServer()
               child.ammo.Value = require(child.settings).gun_data.maxammo
            end
        end
    end)
    char:WaitForChild("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if char.Humanoid.WalkSpeed ~= wsint and antislow == true then
            char.Humanoid.WalkSpeed = wsint
        end
    end)
    
    char:WaitForChild("Humanoid"):GetPropertyChangedSignal("JumpPower"):Connect(function()
        if char.Humanoid.JumpPower ~= jpint and antislow == true then
            char.Humanoid.JumpPower = jpint
        end
    end)
      char:WaitForChild("ragdoll"):GetAttributeChangedSignal("ragdoll_enabled"):Connect(deragdoll)
  end
  
  local function createbeam(gim,direction)
      local midpoint = gim + direction/2
      local part = Instance.new("Part")
      part.Parent = char
      part.Anchored = true
      part.CanCollide = false
      part.Color = defcolor.Value
      defcolor.Changed:Connect(function()
          part.Color = defcolor.Value
      end)
      part.CFrame = CFrame.new(midpoint,gim)
      part.Size = Vector3.new(0.25,0.25,direction.Magnitude)
      local twif = TweenInfo.new(
          1,
          Enum.EasingStyle.Linear,
          Enum.EasingDirection.Out,
          0,
          false,
          0
      )
      game:GetService("TweenService"):Create(part,twif,{Transparency = 1}):Play()
      game:GetService("Debris"):AddItem(part,1)
  end
  
  local function setws(int)
      char.Humanoid.WalkSpeed = int
  end

repeat task.wait() until char
charinit()

local function cast(targetpart)
	local raycast = workspace.Raycast
	local g = RaycastParams.new()
	g.FilterType = Enum.RaycastFilterType.Blacklist
	g.FilterDescendantsInstances = {char}
	local ray = raycast(game:GetService("Workspace"),char.Head.Position,targetpart.Position - char.Head.Position,g)
	if ray == nil then
		return {false}
	end
	if ray.Instance:IsDescendantOf(targetpart.Parent) then
		if ray.Instance.Parent:IsA("Accessory") then
			return {true,targetpart,ray.Position,{char.Head.Position , targetpart.Position - char.Head.Position}}
		elseif ray.Instance.Parent ~= targetpart.Parent then
			return {true,targetpart,ray.Position,{char.Head.Position , targetpart.Position - char.Head.Position}}
	end
	return {true,ray.Instance,ray.Position,{char.Head.Position , targetpart.Position - char.Head.Position}}
end
return {false}
end	
  

  
  local team = game:GetService("Players").LocalPlayer.RespawnLocation
  
  local function getclosestplr()
      local closest 
      local dist = math.huge
      local details = {}
      for i,v in pairs(game:GetService("Players"):GetPlayers()) do
          if  v.Character and not whitelist[v] then
              if v.RespawnLocation ~= team  or v.Character:FindFirstChild("BreadcrabModel") then
              if v.Character:FindFirstChild("Head") and not (v:FindFirstChildWhichIsA("ForceField")) and v.Character:FindFirstChildWhichIsA("Humanoid") then
                  if not (v.Character.Humanoid.Health <= 0) then
                  local ct = cast(v.Character.Head)
                  if ct[1] == true and (v.Character.Head.Position - char.Head.Position).Magnitude < dist then
                      closest = v
                      dist = (v.Character.Head.Position - char.Head.Position).Magnitude
                      details = ct
                  end
                  end
              end
          end
          end
  end
      return details
  end
  
  
  game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(character)
      char = character
      charinit()
  end)
  
  local waittime = 0
  
  --[[
      Custom documentation by SOS Discord
  
      To make a window {
          local win = Flux:Window(Title <String>,Subtitle <String>,GuiColor <Color3>,GuiBind <Enum.KeyCode>)
      }
  
      Notification {
          Flux:Notification(Content<String>,ButtonText<String>)
      }
  
      To make a tab {
          win:Tab(TabName <String> , Image <String> )
      }
  
      to make a label {
          tab:Label(LabelContent<String>)
      }
  
      to make a line {
          tab:Line()
      },
  
      to make a button {
          tab:Button(ButtonName<String>, Description<String>, Callback<Function>)
      }
  
      to make a toggle {
          tab:Toggle(ToggleName<String>, Description<String>, Callback<Function(Boolean)>)
      }
  
      to make a slider {
          tab:Slider(SliderName<String>, Description<String>, Min<Int>, Max<Int>, Deafult<Int>, Callback<Function(Int)>)
  
          subfunctions {
              Slider:Change(SetCurrentValue<Int>)
          }
      }
  
      to make a dropdown {
          tab:Dropdown(DropdownName<String> ,Contents<Table(String/s)>,Callback<Function(String)>)
  
          subfunctions {
              dropdown:Clear() -- Emptys dropdown
  
              dropdown:Add(ValueToAdd<String>) -- Adds ValueToAdd to dropdown 
  
              -- Notice To remove a value you must compleatly clear it then add it all back >:( 
          }
      }
  
      to make a colorpicker {
          tab:ColorPicker(ValueName<String>,DeafultColor<Color3>,Callback<Function(Color3)>)
      }
  
      to make a textbox {
          tab:Textbox(TextboxName<String>,Description<String>,ClearText<Boolean>,Callback<Function(Text)>)
      }
  
      to bind a function {
          tab:Bind(BindName<String>, Keycode, Callback<Function>)
      }
  
      
  ]]
  
  function customasset(name,url)
      local customasset = getsynasset or getcustomasset
  
      if customasset then
          writefile(name .. ".png" , game:HttpGet(url))
  
          return customasset(name .. ".png")
      end
  
      return "rbxassetid://1392380143"
  end
  
  local images = {
      ["Combat"] = customasset("Gun",'https://www.shareicon.net/data/2016/07/29/803540_miscellaneous_512x512.png'),
      ["Character"] = customasset("Noob","https://tr.rbxcdn.com/da2de9555f254c371ab3d0d38408d73b/420/420/Image/Png"),
      ["Render"] = customasset("Bulb","https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/33377/light-bulb-clipart-xl.png"),
      ["Misc"] = customasset("Globe","https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/63210/globe-clipart-md.png")
  }
  
  local Flux = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/fluxlib.txt")()
  
  local win = Flux:Window("NW script", "Neighborhood War", Color3.fromRGB(255, 110, 48), Enum.KeyCode.LeftControl)
  
  local combat = win:Tab("Combat",images.Combat)
  
  
  combat:Label("Combat tab")
  combat:Line()
  combat:Toggle("AutoShoot","Automaticly raycast to find the best target and shoots them. (DISABLED WITH AWP AS ITS DETECTED)",false,function(bool)
         if bool == true then
          for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
              if v:FindFirstChild("framework") then
                  v.framework.client_main.Disabled = false
              end
          end
          for i,v in pairs(char:GetChildren()) do
              if v:FindFirstChild("framework") then
                  char.Humanoid:EquipTool(v)
                  v.framework.event.reload:FireServer()
                  v.framework.client_main.Disabled = false
              end
          end
          else
          for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
              if v:FindFirstChild("framework") then
                  v.framework.client_main.Disabled = true
              end
          end
          for i,v in pairs(char:GetChildren()) do
              if v:FindFirstChild("framework") then
                  v.framework.client_main.Disabled = true
              end
          end
      end
      autoshoot = bool
  end)
  
  
  
  combat:Colorpicker("AutoShoot Tracer Color",Color3.fromRGB(29, 203, 255),function(color)
      defcolor.Value = color
  end)
  
  local wldrop = combat:Dropdown("Whitelist / Blacklist",{},function(choice)
      if table.find(whitelist,plrs:FindFirstChild(choice)) then
          table.remove(whitelist,table.find(whitelist,plrs:FindFirstChild(choice)))
      else
          table.insert(whitelist,plrs:FindFirstChild(choice))
      end
  end)
  
  combat:Button("Explode Landmines","Detonates all landmines on the map",function()
      for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
          if tostring(v) == "MineModel" or tostring(v) == "VoidModel" then
              firetouchinterest(char.HumanoidRootPart,v.hbox,0)
           end
       end
  end)
  
  combat:Toggle("Killsay","Chats something toxic when you kill someone.",false,function(bool)
      killsaybool = bool
  end)
  
  
  local chartab = win:Tab("Character",images.Character)
  chartab:Label("Character tab")
  chartab:Line()
  local antislow = false
  local wsint = 25
  local jpint = 50
  
  local ws = chartab:Slider("WalkSpeed","Makes you fast!",0,100,25,function(speed)
      wsint = speed
      setws(speed)
  end)
  
  local jp = chartab:Slider("JumpPower","Makes you jump higher!",0,500,50,function(power)
      jpint = power
      setjp(power)
  end)
  chartab:Button("Remove nametag","Removes nametag from your head",function()
      if char:FindFirstChild("Head") then
          if char.Head:FindFirstChildWhichIsA("BillboardGui") then
              char.Head:FindFirstChildWhichIsA("BillboardGui"):Destroy()
          end
      end
  end)
  
  chartab:Toggle("AntiSlow","Stops you from being slow",false,function(bool)
      antislow = bool
  end)
  
  chartab:Toggle("AntiRagdoll","Attempts to stop you from being ragdolled",false,function(bool)
      antiragdoll = bool
  end)
  
    chartab:Toggle("AntiAim","Makes it harder for people to shoot you (Wont appear on client)",false,function(bool)
      antiaim = bool
  end)
  
  
  repeat task.wait() until char
  

  
  char:WaitForChild("Humanoid").Died:Connect(function()
      ws:Change(18)
      jp:Change(50)
  end)
  
  for i,v in pairs(game:GetService("Players"):GetPlayers()) do
      if v ~= game:GetService("Players").LocalPlayer then
          wldrop:Add(tostring(v))
      end
  end
  
  local misc = win:Tab("Misc",images.Misc)
  misc:Label("Misc tab")
  misc:Line()
  local removefire = misc:Toggle("Remove Fire","Removes Fire from the map",false,function(bool)
      nofire = bool
      if bool == true then
      for i,v in pairs(firefolder:GetChildren()) do
          v:Destroy()
      end
  end
  end)
  
  plrs.PlayerAdded:Connect(function(player)
      wldrop:Add(tostring(player))
  end)
  
  plrs.PlayerRemoving:Connect(function(player)
      wldrop:Clear()
      for i,v in pairs(game:GetService("Players"):GetPlayers()) do
          if v ~= game:GetService("Players").LocalPlayer then
              wldrop:Add(tostring(v))
          end
      end
  end)
  
  firefolder.ChildAdded:Connect(function(child)
      print(nofire)
      task.wait()
      if nofire == true then
          child:Destroy()
      end
  end)
  remote.OnClientEvent:Connect(killsay)
  
  

 
local metamethod = hookmetamethod(game,"__namecall",function(self,arg1,...)
    local method = getnamecallmethod()
    if method == "GetService"  then
       if arg1 == "NetworkClient" then
           return nil
       end
    elseif method == "FireServer" and tostring(self) == "UpdatePosition" and antiaim == true then
        return metamethod(self,math.huge,...)
    end
   return metamethod(self,arg1,...)
end)


local oldpcall = hookfunction(getrenv().pcall,function(func,arg2,...)
    if type(arg2) == "string" then
       if arg2 == "Detected" then
           return wait(math.huge)
        end
    end
    return oldpcall(func,arg2,...)
end)




local FireServerHook;
FireServerHook = hookfunction(Instance.new("RemoteEvent").FireServer, function(self,...)
  local args = {...}
  if self.Parent == game.JointsService then
      if args[3] == 'ban' then
          return old(nil)
      end
  end
  return old(...)
end)


  while task.wait(waittime) do
      spawn(function()
      if currenttool.Tool and currenttool.Gun == true and autoshoot == true then
            waittime = require(currenttool.Tool.settings).gun_data.cooldown + 0.08
          local closest = getclosestplr()
          if closest[2] then
              createbeam(unpack(closest[4]))
              shoot(closest[2],closest[3])
          end	
      end
  end)
  end
