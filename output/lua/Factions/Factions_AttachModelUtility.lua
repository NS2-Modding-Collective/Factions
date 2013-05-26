
if Server then

    // function to attach a model on every script actor    
    function Entity:AddAttachedModel(model, animationGraph, attachPoint, offset, scale, rotation)

        local extraValues = {   
                                model = model,   
                                animationGraph = animationGraph,
                                offset = offset or Vector(0,0,0),         
                                scale = scale or Vector(0,0,0),   
                                rotation = rotation or Angles(0,0,0),
                            }
        
        local attachedModel = CreateEntity(AttachModel.kMapName, self:GetAttachPointOrigin(attachPoint), self:GetTeamNumber(), extraValues)  
        attachedModel:SetParent(self)
        attachedModel:SetAttachPoint(attachPoint)
        self.lastAttachedModel = attachedModel
       
    end
    

    //****************************************
    // console commands for testing
    //****************************************
    
    function OnCommandAttachNew(client, modelName, animationGraph, attachPoint)
        local player = client:GetControllingPlayer()
        if Shared.GetCheatsEnabled() then
            player:AddAttachedModel(modelName, animationGraph, attachPoint)
        end
	end
    
    function OnCommandAttachPoint(client, attachPoint)
        local player = client:GetControllingPlayer()
        if Shared.GetCheatsEnabled() then
            if player.lastAttachedModel then
                player.lastAttachedModel:SetAttachPoint(attachPoint)
            end
        end
	end

    function OnCommandAttachRotate(client, x, y, z)
        x = tonumber(x) or 0
        y = tonumber(y) or 0
        z = tonumber(z) or 0
        local player = client:GetControllingPlayer()
        if Shared.GetCheatsEnabled() then
            if player.lastAttachedModel then
                player.lastAttachedModel.rotation = Angles(x,y,z)
            end
        end
    end
	
    function OnCommandAttachMove(client, x, y, z)
        x = tonumber(x) or 0
        y = tonumber(y) or 0
        z = tonumber(z) or 0
        local player = client:GetControllingPlayer()
        if Shared.GetCheatsEnabled() then
            if player.lastAttachedModel then
                player.lastAttachedModel.offset = Vector(x,y,z)
            end
        end
	end
	
    function OnCommandAttachScale(client, x, y, z)
        x = tonumber(x) or 0
        y = tonumber(y) or 0
        z = tonumber(z) or 0
        local player = client:GetControllingPlayer()
        if Shared.GetCheatsEnabled() then
            if player.lastAttachedModel then
                player.lastAttachedModel.scale = Vector(x,y,z)
            end
        end
	end
	
	
    function OnCommandAttachSelect(client, number)
        local player = client:GetControllingPlayer()
        if Shared.GetCheatsEnabled() then
            local attachModels = GetChildEntities(player, "AttachModel")
            if attachModels and #attachModels > 0 then
                if not number then    
                    Shared.Message("Currently attached models:")        
                    for i, attachedModel in ipairs(attachModels) do
                        //Shared.Message(i ..": " .. attachedModel.model .. " ,attached at " .. attachedModel:GetAttached())
                        Shared.Message("%i: %s attached at %s", i, attachedModel.model, attachedModel:GetAttached() or "")
                    end
                else
                    number = math.min(tonumber(number), #attachModels)
                    player.lastAttachedModel = attachModels[number]
                    Shared.Message("Selected model is now: %s", player.lastAttachedModel.model) 
                    
                end
            else
                Shared.Message("Currently no models attached!")
            end
        end
	end
	
	
	
	Event.Hook("Console_attach_new", OnCommandAttachNew)
	Event.Hook("Console_attach_point", OnCommandAttachPoint)
	Event.Hook("Console_attach_rotate", OnCommandAttachRotate)
	Event.Hook("Console_attach_move", OnCommandAttachMove)
	Event.Hook("Console_attach_scale", OnCommandAttachScale)
	Event.Hook("Console_attach_select", OnCommandAttachSelect)
end

