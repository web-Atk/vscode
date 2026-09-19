#define interval 0.03
#define circle_round 1.2

function SetUnitZ takes unit whichUnit, real newZ returns nothing
	call UnitAddAbility(whichUnit, 'Amrf')
	call UnitRemoveAbility(whichUnit, 'Amrf')
	call SetUnitFlyHeight(whichUnit, newZ, 0.00)
endfunction

function Clamp takes real x, real min, real max returns real
    if (x > max) then
        return max
	endif
    if (x < min) then
        return min
    endif
    return x
endfunction

function MoveParticles takes nothing returns nothing
	local timer t = GetExpiredTimer()
	local unit u = LoadUnitHandle(udg_parhash, GetHandleId(t), StringHash("unit"))
    local real x = LoadReal(udg_parhash, GetHandleId(t), StringHash("target_x"))
    local real y = LoadReal(udg_parhash, GetHandleId(t), StringHash("target_y"))
    local location target = LoadLocationHandle(udg_parhash, GetHandleId(t), StringHash("target"))
    local real speed = LoadReal(udg_parhash, GetHandleId(t), StringHash("speed"))
    local real time=LoadReal(udg_parhash, GetHandleId(t), StringHash("past_time"))
    local real rand=LoadReal(udg_parhash, GetHandleId(t), StringHash("rand"))
    local real dx
    local real dy
    local real angle
    local location p = GetUnitLoc(u)
    set angle = AngleBetweenPoints(p, target)
    call RemoveLocation(p)

    call SaveReal(udg_parhash, GetHandleId(t), StringHash("past_time"), time + interval)

    call SetUnitFacing(u, angle)

	call SetUnitX(u, GetUnitX(u) + speed * Cos(angle * bj_DEGTORAD) * (Clamp(time, 0, circle_round) - 0.5) * 1.0)
	call SetUnitY(u, GetUnitY(u) + speed * Sin(angle * bj_DEGTORAD) * (Clamp(time, 0, circle_round) - 0.5) * 1.0)
	
	call SetUnitX(u, GetUnitX(u) + speed * Cos(angle * bj_DEGTORAD) * Clamp(time, 0, 2) * 0.8)
	call SetUnitY(u, GetUnitY(u) + speed * Sin(angle * bj_DEGTORAD) * Clamp(time, 0, 2) * 0.8)

	call SetUnitX(u, GetUnitX(u) + speed * Cos((angle + (90 * rand)) * bj_DEGTORAD) * Clamp(time, 0, circle_round) - circle_round)
	call SetUnitY(u, GetUnitY(u) + speed * Sin((angle + (90 * rand)) * bj_DEGTORAD) * Clamp(time, 0, circle_round) - circle_round)
	call SetUnitZ(u, speed * Sin(Clamp(time, 0, circle_round) - circle_round) * -4)

	set dx = GetUnitX(u) - x
	set dy = GetUnitY(u) - y

	if (SquareRoot(dx * dx + dy * dy) <= speed) then
		call FlushChildHashtable(udg_parhash, GetHandleId(t))
		call RemoveLocation(target)
		call DestroyTimer(t)
    endif
endfunction

function GenerateParticles takes unit u, real target_x, real target_y, real speed returns nothing
	local location target = Location(target_x, target_y)
    local timer t = CreateTimer()
    local real rand=GetRandomReal(-1, 1)
    
    call UnitAddAbility(u, 'Aloc')
    if (GetHandleId(udg_parhash) == 0) then
	    set udg_parhash=InitHashtable()
	endif

    call SaveUnitHandle(udg_parhash, GetHandleId(t), StringHash("unit"), u)
    call SaveReal(udg_parhash, GetHandleId(t), StringHash("target_x"), target_x)
    call SaveReal(udg_parhash, GetHandleId(t), StringHash("target_y"), target_y)
    call SaveLocationHandle(udg_parhash, GetHandleId(t), StringHash("target"), target)
    call SaveReal(udg_parhash, GetHandleId(t), StringHash("speed"), speed*interval)
    call SaveReal(udg_parhash, GetHandleId(t), StringHash("past_time"), 0)
    call SaveReal(udg_parhash, GetHandleId(t), StringHash("rand"), rand)

    call TimerStart(t, interval, true, function MoveParticles)
endfunction
