//up主 以天下为之笼 魔兽Jass教程（十七）结构体  
library include initializer init 

    globals 
        private integer a = 100 
        public integer b = 200 
        constant real PI = 3.14 
    endglobals 

    struct Hero 

        private integer id 
        private string name 
        private handle hero 

        public method setId takes integer id returns Hero 
            set this.id = id 
            return this 
        endmethod 

        public method getId takes nothing returns integer 
            return this.id 
        endmethod 

        public method setName takes string name returns Hero 
            set this.name = name 
            return this 
        endmethod 

        public method getName takes nothing returns string 
            return this.name 
        endmethod 

        public static method print takes string msg returns nothing 
            call BJDebugMsg(msg) 
        endmethod 
    endstruct 

    function init takes nothing returns nothing 

        //local Hero hero = Hero.create()  

        //set hero.id = 100  
        //set hero.name = "恶魔猎手"  
        //set hero.hero = CreateUnit(Player(0),'Edem',-569.7,-470.3,90)  

        //call hero.setId(200)  
        //call hero.setName("恶魔猎手")  

        //call hero.setId(200).setName("恶魔猎手")  

        //call BJDebugMsg(I2S(hero.getId()))  
        //call BJDebugMsg(hero.getName())  
        //call BJDebugMsg(I2S(GetHandleId(hero.hero)))  

        call Hero.print("Hello World") 

        //call hero.destroy()  

        

    endfunction 

endlibrary