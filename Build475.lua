local module = {}

local TweenService = game:GetService("TweenService")

function module:CreateEffect()--Type, Size, AnimationGoal, AnimationStyle, AnimationTime)
	local t = {
		Shape = "Block", -- {Ball, Block, Cylinder}
		Material = Enum.Material.SmoothPlastic,
		Color = Color3.fromRGB(255, 255, 255),
		Size = Vector3.new(0, 0, 0),
		StartPosition = Vector3.new(0, 0, 0),
		AnimationGoal = Vector3.new(0, 0, 0),
		AnimationStyle = Enum.EasingStyle.Linear,
		AnimationTime = 1,
		Quanity = 1,
		Spacing = 0,
		PlayingSpacingTime = 1,
		AnimationPlayDelayTime = 5,
		Model = nil,
	}
	local metatable = setmetatable(t, {})
	return metatable
end

function module:DrawEffect(StatsTable, TransitionType, TransitionTime, EasingStyle)
	if StatsTable then
		local PartsTable = {}
		if StatsTable.Quanity then
			for i = 1,StatsTable.Quanity,1 do
				local IsModel = false
				local CustomPart = false
				local Part
				if StatsTable.Model then
					if StatsTable.Model:IsA("Model") then
						local NewModel = StatsTable.Model:Clone()
						NewModel.Parent = workspace
						Part = NewModel
						IsModel = true
					else
						if StatsTable.Model:IsA("Part") or StatsTable.Model:IsA("MeshPart") then
							local NewModel = StatsTable.Model:Clone()
							NewModel.Parent = workspace
							Part = NewModel
							CustomPart = true
						else
							Part = Instance.new("Part", workspace)
						end
					end
				else
					Part = Instance.new("Part", workspace)
				end
				table.insert(PartsTable, #PartsTable+1, Part)
				if IsModel then
					for _,v in next, Part:GetDescendants() do
						if v:IsA("Part") or v:IsA("MeshPart") then
							v.Anchored = true
							v.Transparency = 1
						end
					end
				else
					Part.Anchored = true
					Part.Transparency = 1
				end
				if StatsTable.Material and IsModel == false and CustomPart == false then
					Part.Material = StatsTable.Material
				end
				if StatsTable.Color and IsModel == false and CustomPart == false then
					Part.Color = StatsTable.Color
				end
				if StatsTable.Shape and IsModel == false and CustomPart == false then
					Part.Shape = StatsTable.Shape
				end
				if StatsTable.Size and IsModel == false and CustomPart == false then
					Part.Size = StatsTable.Size
				end
				if StatsTable.StartPosition then
					if IsModel == false then
						Part.Position = (StatsTable.StartPosition + Vector3.new(math.random(0, StatsTable.Spacing + i), math.random(0, StatsTable.Spacing + i), math.random(0, StatsTable.Spacing + i)))
					else
						if Part.PrimaryPart then
							Part:SetPrimaryPartCFrame(CFrame.new((StatsTable.StartPosition + Vector3.new(math.random(0, StatsTable.Spacing + i), math.random(0, StatsTable.Spacing + i), math.random(0, StatsTable.Spacing + i)))))
						else
							warn("EffectsSystem | MODEL DOES NOT HAVE PRIMARYPART! PLEASE SET IT!")
						end
					end
				end
				if TransitionType then
					if TransitionType == "Fade" then
						local TimeTransition = 1
						local StyleTransition = Enum.EasingStyle.Linear
						if TransitionTime then
							TimeTransition = TransitionTime
						end
						if EasingStyle then
							StyleTransition = EasingStyle
						end
						if IsModel then
							for _,v in next, Part:GetDescendants() do
								if v:IsA("Part") or v:IsA("MeshPart") then
									TweenService:Create(v, TweenInfo.new(TimeTransition, StyleTransition), {Transparency = 0}):Play()
								end
							end
						else
							TweenService:Create(Part, TweenInfo.new(TimeTransition, StyleTransition), {Transparency = 0}):Play()
						end
					end
				else
					if IsModel then
						for _,v in next, Part:GetDescendants() do
							if v:IsA("Part") or v:IsA("MeshPart") then
								v.Transparency = 0
							end
						end
					else
						Part.Transparency = 0
					end
				end
				if StatsTable.AnimationGoal and StatsTable.AnimationStyle and StatsTable.AnimationTime and StatsTable.AnimationPlayDelayTime then
					spawn(function()
						local ExtraWaitTime = (StatsTable.PlayingSpacingTime * i)
						if i == 1 then ExtraWaitTime = 0 end
						wait(StatsTable.AnimationPlayDelayTime + ExtraWaitTime)
						if StatsTable.Quanity == 1 then
							if IsModel then
								for _,v in next, Part:GetDescendants() do
									if v:IsA("MeshPart") or v:IsA("Part") then
										TweenService:Create(v, TweenInfo.new(StatsTable.AnimationTime, StatsTable.AnimationStyle), {Position = (Vector3.new(v.Position.X + StatsTable.AnimationGoal.X, v.Position.Y, v.Position.Z + StatsTable.AnimationGoal.Z))}):Play()
										--TweenService:Create(v, TweenInfo.new(StatsTable.AnimationTime, StatsTable.AnimationStyle), {Position = StatsTable.AnimationGoal}):Play()
									end
								end
							else
								TweenService:Create(Part, TweenInfo.new(StatsTable.AnimationTime, StatsTable.AnimationStyle), {Position = StatsTable.AnimationGoal}):Play()
							end
						else
							if StatsTable.PlayingSpacingTime then
								if IsModel then
									for _,v in next, Part:GetDescendants() do
										if v:IsA("MeshPart") or v:IsA("Part") then
											TweenService:Create(v, TweenInfo.new(StatsTable.AnimationTime, StatsTable.AnimationStyle), {Position = (Vector3.new(v.Position.X + StatsTable.AnimationGoal.X, v.Position.Y, v.Position.Z + StatsTable.AnimationGoal.Z))}):Play()
										end
									end
								else
									TweenService:Create(Part, TweenInfo.new(StatsTable.AnimationTime, StatsTable.AnimationStyle), {Position = (Vector3.new(Part.Position.X + StatsTable.AnimationGoal.X, Part.Position.Y, Part.Position.Z + StatsTable.AnimationGoal.Z))}):Play()
								end
							end
						end
					end)
				end
			end
		end
		return PartsTable
	end
end

function module:DestroyEffect(PartsTable, TransitionType, TransitionTime, EasingStyle)
	if PartsTable then
		for i,v in ipairs(PartsTable) do
			local IsModel = false
			if v:IsA("Model") then
				IsModel = true
			end
			if TransitionType then
				if TransitionType == "Fade" then
					local TimeTransition = 1
					local StyleTransition = Enum.EasingStyle.Linear
					if TransitionTime then
						TimeTransition = TransitionTime
					end
					if EasingStyle then
						StyleTransition = EasingStyle
					end
					if IsModel then
						for _,x in next, v:GetDescendants() do
							if x:IsA("MeshPart") or x:IsA("Part") then
								TweenService:Create(x, TweenInfo.new(TimeTransition, StyleTransition), {Transparency = 1}):Play()
							end
						end
					else
						TweenService:Create(v, TweenInfo.new(TimeTransition, StyleTransition), {Transparency = 1}):Play()
					end
					wait(TimeTransition)
					v:Destroy()
				end
			else
				if IsModel then
					for _,x in next, v:GetDescendants() do
						if x:IsA("MeshPart") or x:IsA("Part") then
							x:Destroy()
						end
					end
				end
				v:Destroy()
				v = nil
			end
		end
	end
end

return module
