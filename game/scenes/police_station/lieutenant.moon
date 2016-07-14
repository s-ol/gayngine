Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>
  if SCENE.state.police == 1
		if SCENE.lieutenant == nil
			@lieutenant\say "officer, you got the pictures?"
			res = @player\choice { yes: "yes, sir. here you go", _label: "yes" },
													 { no: "no, sir. ill pick them up now", _label: "no" }
			if res == "yes"
				@description\say "you gave the pictures to lieutenant mcmiller"
				SCENE.state.police = 2
			if res == "no"
				@lieutenant\say "hurry up parelli"
			SCENE.lieutenant = 1
		elseif SCENE.lieutenant == 1
			@lieutenant\say "officer, you got the pictures?"
			res = @player\choice { yes: "yes, sir. here you go", _label: "yes" },
													 { no: "no, sir. ill pick them up now", _label: "no" }
			if res == "yes"
				@cdescription\say "you gave the pictures to lieutenant mcmiller"
				SCENE.state.police = 2
			if res == "no"
				@lieutenant\say "what is wrong with you parelli?"
				@lieutenant\say "how can it be so hard to pick up some pictures?"

	elseif SCENE.state.police > 1 and SCENE.state.police < 6
		@lieutenant\say "Parelli, i hope it is important"
		@player\say ".%%%%%%.%%%%%%.%%%%%% not really"
		@lieutenant\say "Then move your lazy ass back to work!"
	
	elseif SCENE.state.police == 6
		@lieutenant\say "Parelli, what is it now?"
		@player\say "Lieutenant, do you know a man called johnson?"
		@player\say "David johnson?"
		@lieutenant\say "Yes i do officer, why would you want to know?"
		res = @player\choice { pictures: "I was looking through the surveillance photos", _label: "inconsistent pictures" },
												 { war: "Maybe this sounds strange to you sir", _label: "wartime stories" },
												 { personal: "I have a problem with my daughter", _label: "personal favour" }
		
		if res == "pictures"
		
			@player\say "And i noticed something was off"
			@player\say "There is a man on some of the photos"
			@player\say "Who we didnt even talk about as a suspect"
			@player\say "Though i think he is pretty suspicious"
			@player\say "Anyways"
			@player\say "I asked around and found out that david johnson took the pictures"
			@player\say "So i wanted to ask him about it"
			@player\say "Maybe he remembers him"
			@player\say "Maybe not"
			@lieutenant\say "I see parelli"
			@lieutenant\say "Good police work you did there"
			@lieutenant\say "But try not to overstep the mark"
			@lieutenant\say "People dont like over-achievers"
			@lieutenant\say ".%%%%%%.%%%%%%.%%%%%"
			@lieutenant\say "I know david"
			@lieutenant\say "I know him well"
			@lieutenant\say "We served together "
			@lieutenant\say "I guess you young folks dont even know what that means to a man"
			@lieutenant\say "But maybe its for the better"
			@lieutenant\say ".%%%%%%.%%%%%%.%%%%%"
			@lieutenant\say "You are lucky parelli"
			@lieutenant\say "David is in the department right now"
			@lieutenant\say "He is working in his part-time office down the hall"
			@lieutenant\say "Room 201"
			@lieutenant\say "Say hello from me"
			@player\say "I will"
			@player\say "Thank you, sir!"
			@lieutenant\say "And parelli!"
			@lieutenant\say "Next time you ask me first, understood?"
			@player\say "Sir, yes sir, thank you sir."
			
			@description\say "It seems to be my lucky day"
			@description\say "Not only did the lieutenant believe all my bullshit"
			@description\say "It seems as if johnson is right here down the hall, in room 201!"
			
			SCENE.state.police = 7
			
		elseif res == "war"
		
			@player\say "But lately i became deeply interested in the war"
			@player\say "I have talked to alot of people"
			@player\say "Veterans, reporters, photographers"
			@player\say "And i dont know why"
			@player\say "But im deeply moved by those stories"
			@player\say "You know, how people like you protected our freedom"
			@player\say "Anyways"
			@player\say "I found out that you and a man called david johnson are the last veterans in the department"
			@player\say "So i wanted to talk to you about the war"
			@player\say "If you dont mind of course"
			@lieutenant\say "I see parelli"
			@lieutenant\say "I would have never thought that young people like you"
			@lieutenant\say "Would have any inetrest in the old stories"
			@lieutenant\say "I am genuinely surprised and touched by that"
			@lieutenant\say ".%%%%%%.%%%%%%.%%%%%"
			@lieutenant\say "I would like to talk to you but right now is not a good time"
			@lieutenant\say "The department is understaffed and i have barely a minute of free time"
			@lieutenant\say "But i guess you could ask david"
			@lieutenant\say "He loves to talk about the old times"
			@lieutenant\say ".%%%%%%.%%%%%%.%%%%%"
			@lieutenant\say "You are lucky parelli"
			@lieutenant\say "He even is in the department right now"
			@lieutenant\say "He is working in his part-time office down the hall"
			@lieutenant\say "Room 201"
			@lieutenant\say "Say hello from me"
			@player\say "I will"
			@player\say "Thank you, sir!"
			
			@description\say "It seems to be my lucky day"
			@description\say "Not only did the lieutenant believe all my bullshit"
			@description\say "It seems as if johnson is right here down the hall, in room 201!"
			
			SCENE.state.police = 7
		
		elseif res == "personal"
		
			@player\say "I have the feeling she found some new friends at highschool"
			@player\say "But the wrong kind of friends, you know?"
			@player\say "I am afraid she might do something stupid"
			@player\say "And she is only seventeen"
			@player\say "Anyways"
			@player\say "I cant tail her, she would hate me if she found out"
			@player\say "And she also knows most of the guys from the department"
			@player\say "So i asked around and found out that david johnson is a very talented investigator"
			@player\say "Specialized in my kind of"
			@player\say ".%%%%%%.%%%%%%.%%%%%"
			@player\say "Problem"
			@player\say "Coincidentally he even took the pictures for lovebugs"
			@player\say "So i thought i could ask him if he would do me the favor"
			@player\say "Of course i would pay him and all"
			@player\say ".%%%%%%.%%%%%%.%%%%%"
			@lieutenant\say "I see parelli"
			@lieutenant\say "I know how it feels to have daughter"
			@lieutenant\say "I have three of them myself"
			@lieutenant\say "But i got to tell you something and this is not easy to hear"
			@lieutenant\say ".%%%%%%.%%%%%%.%%%%%"
			@lieutenant\say "They will do stupid things"
			@lieutenant\say "Boys, parties, drugs"
			@lieutenant\say "You name it!"
			@lieutenant\say "We can not protect them from themselves"
			@lieutenant\say ".%%%%%%.%%%%%%.%%%%%"
			@lieutenant\say "But i appreciate the try"
			@lieutenant\say "You are lucky parelli"
			@lieutenant\say "David is in the departmen right now"
			@lieutenant\say "He is working in his part-time office down the hall"
			@lieutenant\say "Room 201"
			@lieutenant\say "Say hello from me"
			@player\say "I will"
			@player\say "Thank you, sir!"
			
			@description\say "It seems to be my lucky day"
			@description\say "Not only did the lieutenant believe all my bullshit"
			@description\say "It seems as if johnson is right here down the hall, in room 201!"
			
			
			SCENE.state.police = 7
			
	elseif SCENE.state.police == 7
		@lieutenant\say "Go now!"