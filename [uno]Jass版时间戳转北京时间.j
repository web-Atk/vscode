library dateTimeLib
    struct DateTime
        static integer year
        static integer month
        static integer day
        static integer hour
        static integer minute
        static integer second
    
        // 是否闰年
        private static method isLeapYear takes integer y returns boolean
            local boolean cd1 = ModuloInteger(y, 4) == 0
            local boolean cd2 = ModuloInteger(y, 100) != 0
            local boolean cd3 = ModuloInteger(y, 400) == 0
            return cd1 and cd2 or cd3 
        endmethod

        // 取某年天数
        private static method getYearDays takes integer y returns integer
            if .isLeapYear(y) then
                return 31622400
            else
                return 31536000
            endif
        endmethod

        // 取某月天数
        private static method getMonDays takes integer y, integer m returns integer
            if m == 2 then
                if isLeapYear(y) then
                    return 29
                else
                    return 28
                endif
            elseif m == 4 or m == 6 or m == 9 or m == 11 then
                return 30
            endif
            return 31
        endmethod
    
        // 转换（北京时间）
        static method convert takes integer ts returns nothing
            local integer s
            local integer d
            set ts = ts + (8 * 3600)
            set.year = 1970
            loop
                set s = .getYearDays( .year) 
                exitwhen ts < s
                set ts = ts - s
                set.year = .year + 1
            endloop
            set.month = 1
            loop
                set d = .getMonDays( .year, .month)
                set s = d * 86400
                exitwhen ts < s
                set ts = ts - s
                set.month = .month + 1
            endloop
            set.day = ts / 86400 + 1
            set ts = ModuloInteger(ts, 86400)
            set.hour = ts / 3600
            set ts = ModuloInteger(ts, 3600)
            set.minute = ts / 60
            set.second = ModuloInteger(ts, 60)
        endmethod
    
    endstruct
    
endlibrary
