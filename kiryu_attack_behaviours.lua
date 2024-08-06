local chainChompHealth = 4
function check_for_chainchomp(m, enemyobj)
    m.particleFlags = m.particleFlags | PARTICLE_HORIZONTAL_STAR
    chainChompHealth = chainChompHealth - 1
    if chainChompHealth <= 0 then
        --bhv_chain_chomp_gate_update()
        enemyobj.oSubAction = CHAIN_CHOMP_SUB_ACT_LUNGE
        enemyobj.oChainChompMaxDistFromPivotPerChainPart = 9999999.0
        enemyobj.oForwardVel = -300.0
        enemyobj.oVelY = 300.0
        enemyobj.oGravity = -10.0
        enemyobj.oChainChompTargetPitch = -0x3000
        enemyobj.oChainChompHitGate = 1
        chainChompHealth = 4
    else
        enemyobj.oVelY = 30.0
    end
end

function check_for_bowser(m, enemyobj)
    m.particleFlags = m.particleFlags | PARTICLE_HORIZONTAL_STAR
    enemyobj.oForwardVel = enemyobj.oForwardVel - 20
    enemyobj.oVelY = 4
    if m.action == ACT_COMBO_4 or m.action == ACT_DROPKICK then
        enemyobj.oForwardVel = enemyobj.oForwardVel - 70
        enemyobj.oVelY = 40
    end
end
function check_for_kingbobomb(m, enemyobj)
    m.particleFlags = m.particleFlags | PARTICLE_HORIZONTAL_STAR
    enemyobj.oForwardVel = enemyobj.oForwardVel - 20
    enemyobj.oVelY = 4
    if m.action == ACT_COMBO_4 or m.action == ACT_DROPKICK then
        enemyobj.oForwardVel = enemyobj.oForwardVel - 70
        enemyobj.oVelY = 40
    end
end

kiryu_attack_targets = {
    [id_bhvBowser] = check_for_bowser,
    [id_bhvChainChomp] = check_for_chainchomp,
    [id_bhvKingBobomb] = check_for_kingbobomb,
}

function check_for_behaviours(m)
    if gPlayerSyncTable[m.playerIndex].checked == false then
        --djui_popup_create("\\#ffffdc\\\n"..tostring(kiryu_attack_targets[id_bhvChainChomp]), 6)
        for key,value in pairs(kiryu_attack_targets) do
            enemyobj = obj_get_nearest_object_with_behavior_id(m.marioObj,key)
            if enemyobj ~= nil and enemyobj.oDistanceToMario <= 300.0 then
                if kiryu_attack_targets[key] then
                    djui_popup_create("\\#ffffdc\\\n dasdasd", 1)
                    gPlayerSyncTable[m.playerIndex].checked = true
                    kiryu_attack_targets[key](m, enemyobj)
                end
            end
        end
    end
end