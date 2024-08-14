ACT_KIRYU_ATTACK = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING)
ACT_COMBO_1 = allocate_mario_action(ACT_FLAG_ATTACKING | ACT_GROUP_MOVING | ACT_FLAG_MOVING)
ACT_COMBO_2 = allocate_mario_action(ACT_FLAG_ATTACKING | ACT_GROUP_MOVING | ACT_FLAG_MOVING)
ACT_COMBO_3 = allocate_mario_action(ACT_FLAG_ATTACKING | ACT_GROUP_MOVING | ACT_FLAG_MOVING)
ACT_COMBO_4 = allocate_mario_action(ACT_FLAG_ATTACKING | ACT_GROUP_MOVING | ACT_FLAG_MOVING)
ACT_DROPKICK = allocate_mario_action(ACT_FLAG_ATTACKING | ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_KIRYU_BOWSER_THROW = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING)

PUNCH_1_SOUND = audio_sample_load("punch1.ogg")
PUNCH_2_SOUND = audio_sample_load("punch2.ogg")
PUNCH_3_SOUND = audio_sample_load("punch4.ogg") --why you may ask? idk
PUNCH_4_SOUND = audio_sample_load("punch3.ogg")
DROPKICK_SOUND = audio_sample_load("dropkick.ogg")
HIT_SOUND = audio_sample_load("hit_sfx.ogg")


function kiryu_attack(m)
    set_mario_animation(m, CHAR_ANIM_A_POSE)
    if mario_check_object_grab(m) ~= 0 and (m.input & INPUT_A_DOWN) == 0 then
        mario_grab_used_object(m)
        if obj_has_behavior_id(m.usedObj, id_bhvKingBobomb) ~= 0 or obj_has_behavior_id(m.usedObj, id_bhvBowser) ~= 0 then
            audio_sample_play(DROPKICK_SOUND, m.pos, 1)
            set_mario_action(m, ACT_HOLD_HEAVY_WALKING, 0)
            m.marioBodyState.grabPos = GRAB_POS_HEAVY_OBJ
        else
            set_mario_action(m, ACT_HOLD_WALKING, 0)
            m.marioBodyState.grabPos = GRAB_POS_LIGHT_OBJ
        end
        return 1
    end
    stepResult = perform_ground_step(m)
    if is_anim_at_end(m) ~= 0 then
        gPlayerSyncTable[m.playerIndex].checked = false
        audio_sample_play(PUNCH_1_SOUND, m.pos, 1)
        return set_mario_action(m, ACT_COMBO_1, 0)
    end
    m.actionTimer = m.actionTimer + 1
end

function combo1(m)

    set_mario_animation(m, CHAR_ANIM_FIRST_PUNCH)

    smlua_anim_util_set_animation(m.marioObj, "K_Punch1")

    if m.actionTimer < 4 then
        mario_set_forward_vel(m, 20)
    else
        mario_set_forward_vel(m, 0)
    end
    if (m.input & INPUT_B_PRESSED) ~= 0 and (m.actionTimer > 4 and m.actionTimer <= 15) then

        gPlayerSyncTable[m.playerIndex].checked = false

        audio_sample_play(PUNCH_2_SOUND, m.pos, 1)
        return set_mario_action(m, ACT_COMBO_2, 0)
    end
    if m.actionTimer > 15 then
        return set_mario_action(m, ACT_WALKING, 0)
    end

    check_for_behaviours(m)

    stepResult = perform_ground_step(m)

    m.actionTimer = m.actionTimer + 1
end

function combo2(m)

    set_mario_animation(m, CHAR_ANIM_SECOND_PUNCH)

    smlua_anim_util_set_animation(m.marioObj, "K_Punch2")

    if m.actionTimer < 3 then
        mario_set_forward_vel(m, 5)
    else
        mario_set_forward_vel(m, 0)
    end
    if (m.input & INPUT_B_PRESSED) ~= 0 and (m.actionTimer > 4 and m.actionTimer <= 15) then

        gPlayerSyncTable[m.playerIndex].checked = false

        audio_sample_play(PUNCH_3_SOUND, m.pos, 1)
        return set_mario_action(m, ACT_COMBO_3, 0)
    end
    if m.actionTimer > 15 then
        return set_mario_action(m, ACT_WALKING, 0)
    end

    check_for_behaviours(m)

    stepResult = perform_ground_step(m)

    m.actionTimer = m.actionTimer + 1
end

function combo3(m)

    set_mario_animation(m, CHAR_ANIM_FIRST_PUNCH)

    smlua_anim_util_set_animation(m.marioObj, "K_Punch3")

    if m.actionTimer < 3 then
        mario_set_forward_vel(m, 5)
    else
        mario_set_forward_vel(m, 0)
    end
    if (m.input & INPUT_B_PRESSED) ~= 0 and (m.actionTimer > 7 and m.actionTimer <= 15) then

        gPlayerSyncTable[m.playerIndex].checked = false
        
        audio_sample_play(PUNCH_4_SOUND, m.pos, 1)
        mario_set_forward_vel(m, 100)
        return set_mario_action(m, ACT_COMBO_4, 0)
    end
    if m.actionTimer > 15 then
        return set_mario_action(m, ACT_WALKING, 0)
    end

    check_for_behaviours(m)

    stepResult = perform_ground_step(m)

    m.actionTimer = m.actionTimer + 1
end

function combo4(m)

    set_mario_animation(m, CHAR_ANIM_SECOND_PUNCH)
    
    smlua_anim_util_set_animation(m.marioObj, "K_Punch4")

    if m.actionTimer < 4 then
        mario_set_forward_vel(m, 15)
    else
        mario_set_forward_vel(m, 0)
    end
    if m.actionTimer > 24 then
        return set_mario_action(m, ACT_WALKING, 0)
    end
    stepResult = perform_ground_step(m)

    check_for_behaviours(m)

    m.actionTimer = m.actionTimer + 1
end

function dropkick(m)
    set_mario_animation(m, CHAR_ANIM_DIVE)

    smlua_anim_util_set_animation(m.marioObj, "K_DropKick")
    --m.forwardVel = 15
    if m.actionTimer == 0 then
        gPlayerSyncTable[m.playerIndex].checked = false
        audio_sample_play(DROPKICK_SOUND, m.pos, 1)
        m.vel.y = 30
    end

    check_for_behaviours(m)
    -- if m.actionTimer >= 16 then
    --     set_anim_to_frame(m, 16)
    -- end
    if m.actionTimer >= 16 then
        m.faceAngle.y = m.faceAngle.y + 180
        return set_mario_action(m, ACT_DIVE_SLIDE, 0)
    end

    stepResult = perform_air_step(m, 0)

    m.actionTimer = m.actionTimer + 1
end

function act_kiryu_bowser_throw(m)

    if (m.actionTimer == 7) then
        mario_throw_held_object(m)
        m.usedObj.oBowserHeldAngleVelYaw = 0x500
        m.usedObj.oBowserHeldAnglePitch = -0x500
        play_character_sound_if_no_flag(m, CHAR_SOUND_SO_LONGA_BOWSER, MARIO_MARIO_SOUND_PLAYED)
        play_sound_if_no_flag(m, SOUND_ACTION_THROW, MARIO_ACTION_SOUND_PLAYED)
    end

    animated_stationary_ground_step(m, CHAR_ANIM_GROUND_THROW, ACT_IDLE)
    
    m.actionTimer = m.actionTimer + 1
    return false
end

function on_interact(m, o, intType, value)

    if gPlayerSyncTable[m.playerIndex].charMoveset ~= true then
        return
    end
    
    -- Properly grab stuff. (Bit taken from Sharen's Pasta Castle)
    local grabActions = {
        [ACT_KIRYU_ATTACK] = true
    }

    if (o.oInteractStatus & INT_STATUS_WAS_ATTACKED) ~= 0 then
        audio_sample_play(HIT_SOUND, m.pos, 1)
        if m.action == ACT_COMBO_1 or m.action == ACT_COMBO_2 or m.action == ACT_COMBO_3 or m.action == ACT_COMBO_4 then
            m.particleFlags = m.particleFlags | PARTICLE_HORIZONTAL_STAR
            o.oVelY = 30
            o.oForwardVel = -50
        end 
        if m.action == ACT_DROPKICK then
            m.particleFlags = m.particleFlags | PARTICLE_HORIZONTAL_STAR
            o.oVelY = 40
            o.oForwardVel = -100
        end
    end

    if m.action == ACT_KIRYU_ATTACK then
        if (intType & (INTERACT_GRABBABLE) ~= 0) and o.oInteractionSubtype & (INT_SUBTYPE_NOT_GRABBABLE) == 0 then
            m.interactObj = o
            m.input = m.input | INPUT_INTERACT_OBJ_GRABBABLE
            if o.oSyncID ~= 0 then
                network_send_object(o, true)
            end
        end
    end
end

function on_mario_action(m)

    if gPlayerSyncTable[m.playerIndex].charMoveset ~= true then
        return
    end
    if (m.action == ACT_PUNCHING or m.action == ACT_MOVE_PUNCHING) and m.actionArg ~= 9 then
        return set_mario_action(m, ACT_KIRYU_ATTACK, 0)
    end
    if (m.action == ACT_DIVE and (m.prevAction & ACT_FLAG_AIR) == 0) and m.actionArg ~= 9 then
        return set_mario_action(m, ACT_DROPKICK, 0)
    end
    if obj_has_behavior_id(m.usedObj, id_bhvBowser) ~= 0 and m.action == ACT_HEAVY_THROW then
        return set_mario_action(m, ACT_KIRYU_BOWSER_THROW, 0)
    end
end

hook_event(HOOK_ON_SET_MARIO_ACTION, on_mario_action)

hook_event(HOOK_ON_INTERACT, on_interact)

hook_mario_action(ACT_KIRYU_ATTACK, kiryu_attack, INTERACT_PLAYER)
hook_mario_action(ACT_COMBO_1, combo1, INT_PUNCH)
hook_mario_action(ACT_COMBO_2, combo2, INT_PUNCH)
hook_mario_action(ACT_COMBO_3, combo3, INT_PUNCH)
hook_mario_action(ACT_COMBO_4, combo4, INT_KICK)
hook_mario_action(ACT_DROPKICK, dropkick, INT_SLIDE_KICK)
hook_mario_action(ACT_KIRYU_BOWSER_THROW, act_kiryu_bowser_throw, INTERACT_PLAYER)