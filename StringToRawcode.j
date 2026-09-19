//字符串转RAWCODE

//============================================================
// StringToRawcode
//
// "Nbrn" -> 'Nbrn'
// "Hpal" -> 'Hpal'
// "Hamg" -> 'Hamg'
//
// 要求：输入必须是 4 个 ASCII 可打印字符。
//============================================================

function CharToAscii takes string c returns integer
    local string chars = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
    local integer i = 0

    loop
        exitwhen i >= StringLength(chars)

        if SubString(chars, i, i + 1) == c then
            return i + 32
        endif

        set i = i + 1
    endloop

    return -1
endfunction


function StringToRawcode takes string s returns integer
    local integer a
    local integer b
    local integer c
    local integer d

    if StringLength(s) != 4 then
        return 0
    endif

    set a = CharToAscii(SubString(s, 0, 1))
    set b = CharToAscii(SubString(s, 1, 2))
    set c = CharToAscii(SubString(s, 2, 3))
    set d = CharToAscii(SubString(s, 3, 4))

    if a < 0 or b < 0 or c < 0 or d < 0 then
        return 0
    endif

    return a * 16777216 + b * 65536 + c * 256 + d
endfunction