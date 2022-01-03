-- ============================================================= --
-- NO FIELD FLIPPING MOD
-- ============================================================= --

NoFieldFlipping = {};

addModEventListener(NoFieldFlipping);

function NoFieldFlipping.setLandOwnership(farmlandId, farmId)
	--RESET FIELD BEFORE A PURCHASE
	for _, farmLand in pairs(g_fieldManager.farmlandIdFieldMapping) do
		for fieldIndex, field in pairs(farmLand) do
			if field.farmland.id == farmId then
				if not field.farmland.isOwned then
					local fieldNumber = tostring(field.fieldId)
					local fruitIndex = field.fruitType
					local fieldState = FieldManager.FIELDSTATE_CULTIVATED
					local growthState = 0
					local weedValue = 0
					local sprayEffect = false
					local sprayLevel = FieldUtil.getSprayFactor(field) * g_currentMission.fieldGroundSystem:getMaxValue(FieldDensityMap.SPRAY_LEVEL)
					local plowState = FieldUtil.getPlowFactor(field) * g_currentMission.fieldGroundSystem:getMaxValue(FieldDensityMap.PLOW_LEVEL)
					local limeState = FieldUtil.getLimeFactor(field) * g_currentMission.fieldGroundSystem:getMaxValue(FieldDensityMap.LIME_LEVEL)

					for i = 1, table.getn(field.setFieldStatusPartitions) do
						g_fieldManager:setFieldPartitionStatus(field, field.setFieldStatusPartitions, i, fruitIndex, fieldState, growthState, sprayLevel, sprayEffect, plowState, weedValue, limeState)
					end
					
				end
			end
		end
	end
end

function NoFieldFlipping:loadMap(name)
	self.initialised = false
end

function NoFieldFlipping:deleteMap()
end

function NoFieldFlipping:mouseEvent(posX, posY, isDown, isUp, button)
end

function NoFieldFlipping:keyEvent(unicode, sym, modifier, isDown)
end

function NoFieldFlipping:draw()
end

function NoFieldFlipping:update(dt)
	if not self.initialised then
		--DO THIS HERE SO IT HAPPENS AFTER MAP HAS LOADED
		if g_currentMission:getIsServer() then
			--ONLY SERVER NEEDS TO DO ANYTHING
			FarmlandManager.setLandOwnership = Utils.prependedFunction(FarmlandManager.setLandOwnership, NoFieldFlipping.setLandOwnership)
		end
		self.initialised = true
	end
end