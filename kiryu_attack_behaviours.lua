local chainChompHealth = 4
function check_for_chainchomp(m, enemyobj)
    m.particleFlags = m.particleFlags | PARTICLE_HORIZONTAL_STAR
    chainChompHealth = chainChompHealth - 1
    currentBoss = "Chain Chomp"
    if chainChompHealth <= 0 then
        --bhv_chain_chomp_gate_update()
        enemyobj.oSubAction = CHAIN_CHOMP_SUB_ACT_LUNGE
        enemyobj.oChainChompMaxDistFromPivotPerChainPart = 9999999.0
        enemyobj.oForwardVel = -300.0
        enemyobj.oVelY = 300.0
        enemyobj.oGravity = -10.0
        enemyobj.oChainChompTargetPitch = -0x3000
        enemyobj.oChainChompHitGate = 1
        currentBoss = nil
        chainChompHealth = 4
    else
        enemyobj.oVelY = 30.0
    end
    currentBossHealth = chainChompHealth/4*100
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
local kingBobombHealth = 20
function check_for_kingbobomb(m, enemyobj)
    m.particleFlags = m.particleFlags | PARTICLE_HORIZONTAL_STAR
    currentBoss = "King Bobomb"
    if m.action == ACT_COMBO_4 or m.action == ACT_DROPKICK then
        enemyobj.oForwardVel = enemyobj.oForwardVel - 90
        enemyobj.oVelY = 40
        kingBobombHealth = kingBobombHealth - 3
    else
        enemyobj.oForwardVel = enemyobj.oForwardVel - 20
        enemyobj.oVelY = 4
        kingBobombHealth = kingBobombHealth - 1
    end
    if kingBobombHealth <= 0 then
        currentBoss = nil
        enemyobj.oActiveParticleFlags = enemyobj.oActiveParticleFlags | ACTIVE_PARTICLE_TRIANGLE
        obj_mark_for_deletion(enemyobj)
        local star = spawn_default_star(enemyobj.oPosX, enemyobj.oPosY + 100, enemyobj.oPosZ)
        star.oStarSelectorType = 1
        bhv_camera_lakitu_init()
        bhv_camera_lakitu_update()
        kingBobombHealth = 20
    end
    currentBossHealth = kingBobombHealth/20*100
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
            if enemyobj ~= nil and enemyobj.oDistanceToMario <= 450.0 then
                if kiryu_attack_targets[key] then
                    gPlayerSyncTable[m.playerIndex].checked = true
                    kiryu_attack_targets[key](m, enemyobj)
                end
            end
        end
    end
end