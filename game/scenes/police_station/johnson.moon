Vector = require "lib.hump.vector"
import clickable_dialogue, Dialogue from require "game.dialogue"
import wrapping_, Mixin from require "util"

vector = Vector!

clickable_dialogue Dialogue =>

  @player\say "Hello, sir?"
  @johnson\say "Yes? whats the matter son?"
  @player\say "Are you david johnson?"
  @player\say "Youou did the investigation on this club"
  @player\say "Whats the name again.%%%%%%%.%%%%%%%%%%.%%%%%%%"
  @player\say "Lovebugs or something...?"
  @johnson\say "Yea thats me"
  @johnson\say "Took some pictures, nothing much though"
  @johnson\say "How can I help you?"
  res = @player\choice { waters: "Well, I was at the lovebugs club", _label: "test the waters" },
                       { maneuver: "Today we arrested a man for anothother drug-related felony", _label: "strategic maneuver" },
                       { personal: "Ahh nothing special", _label: "personal interest"}
  
  if res == "maneuver"
	
		@player\say "carl .%%%%.%%%%%.%%%% wilder"
		@player\say "blond hair, muscular type"
		@player\say "we think that he could be connected to the clubs drugscene, but couldn't find him on the pictures"
		@player\say "do you maybe remember seeing him at the club?"
		@johnson\say "wilder you say?"
		@johnson\say "blond hair, muscular type?"
		@johnson\say ".%%%%%.%%%%%.%%%%%"
		@johnson\say "No, doesnt ring a bell, but maybe if you show me a picture of him..."
		@player\say ".%%%%%.%%%%%.%%%%%"
		@player\say "Damn forgot to bring one"
		@player\say "Thanks anyways"
		res = @johnson\choice { sensitive: "Look son", _label: "sensitive" },
                          { dismissive: "Look son", _label: "dismissive" },
                          { play: "Look son", _label: "play along"}
    
		if res == "sensitive"
			@johnson\say "I can imagine how hard it can be"
			@johnson\say "You got family?"
			@player\say "Yes. a wife and a daughter"
			@johnson\say "I thought so"
			@johnson\say "You want to protect them"
			@johnson\say "Save them from the pain of losing you"
			@johnson\say "But you got to make a decision son"
			@johnson\say "Because at some point you will break"
			@johnson\say "And than they will lose you too"
			@player\say ".%%%%.%%%%%.%%%%%%"
			@player\say ".%%%%.%%%%%.%%%%%%"
			@player\say "Thank you mr.johnson"

			@description\say "I cant go on"
			@description\say "I feel like my game ends here"
			@description\say ".%%%%.%%%%%.%%%%%%"
			SCENE.state = {}
			SCENE\transition_to "first_encounter.menu", 4

			
		elseif res == "dismissive"
			@johnson\say "I can imagine its hard living a double life like that"
			@johnson\say "But come on..."
			@johnson\say "Visiting a club which you had to know would be observed sooner or later"
			@johnson\say "That was a bit dumb son"
			@johnson\say "I mean, i personally dont care"
			@johnson\say "I aint no snitch you know"
			@johnson\say "But sooner or later the cover will blow"
			@johnson\say "Like a grain of sand in a storm"
			@johnson\say "And then"
			@johnson\say "You will lose everything"
			@player\say ".%%%%.%%%%%.%%%%%%"
			@player\say ".%%%%.%%%%%.%%%%%%"

			@description\say "I cant go on"
			@description\say "I feel like my game ends here"
			@description\say ".%%%%.%%%%%.%%%%%%"
			SCENE.state = {}
			SCENE\transition_to "first_encounter.menu", 4

		elseif res == "play"
			@johnson\say "I appreciate your efforts"
			@johnson\say "But next time be a bit better prepared"
			@johnson\say "Ill have to leave now"
			@johnson\say "But maybe you can fax me a picture"
			@johnson\say "And ill get back at you as soon as possible"
			@player\say ".%%%%.%%%%%.%%%%%%"
			@player\say "Sure"
			@player\say "Thank you mr.johnson"

			@description\say "I cant go on"
			@description\say "I feel like my game ends here"
			@description\say ".%%%%.%%%%%.%%%%%%"
			SCENE.state = {}
			SCENE\transition_to "first_encounter.menu", 4

		
 
 elseif res == "personal"
 
		@player\say "just personal interest in your line of work"
		@player\say "i always wanted to become an investigator, but they said it wouldnt pay as well"
		@player\say "so i am curious"
		@player\say "do you remember all the people you takin pictures of or you writin some notes"
		@player\say "how you do it?"
		res = @johnson\choice { sensitive: "Look son", _label: "sensitive" },
                          { dismissive: "Look son", _label: "dismissive" },
                          { play: "Look son", _label: "play along"}
    
		if res == "sensitive"
			@johnson\say "I can imagine how hard it can be"
			@johnson\say "You got family?"
			@player\say "Yes. a wife and a daughter"
			@johnson\say "I thought so"
			@johnson\say "You want to protect them"
			@johnson\say "Save them from the pain of losing you"
			@johnson\say "But you got to make a decision son"
			@johnson\say "Because at some point you will break"
			@johnson\say "And than they will lose you too"
			@player\say ".%%%%.%%%%%.%%%%%%"
			@player\say ".%%%%.%%%%%.%%%%%%"
			@player\say "Thank you mr.johnson"

			@description\say "I cant go on"
			@description\say "I feel like my game ends here"
			@description\say ".%%%%.%%%%%.%%%%%%"
			SCENE.state = {}
			SCENE\transition_to "first_encounter.menu", 4
			
		elseif res == "dismissive"
			@johnson\say "I can imagine its hard living a double life like that"
			@johnson\say "But come on..."
			@johnson\say "Visiting a club which you had to know would be observed sooner or later"
			@johnson\say "That was a bit dumb son"
			@johnson\say "I mean, i personally dont care"
			@johnson\say "I aint no snitch you know"
			@johnson\say "But sooner or later the cover will blow"
			@johnson\say "Like a grain of sand in a storm"
			@johnson\say "And then"
			@johnson\say "You will lose everything"
			@player\say ".%%%%.%%%%%.%%%%%%"
			@player\say ".%%%%.%%%%%.%%%%%%"

			@description\say "I cant go on"
			@description\say "I feel like my game ends here"
			@description\say ".%%%%.%%%%%.%%%%%%"
			SCENE.state = {}
			SCENE\transition_to "first_encounter.menu", 4

		elseif res == "play"
			@johnson\say "Well, its true, the payment is miserable, you gotta love the job"
			@johnson\say "People distrust you for what you are doing"
			@johnson\say "You live kind of a double life, you know?"
			@johnson\say "But it never truly lets go of you"
			@johnson\say "But i guess there is nothing you can do about it"
			@johnson\say "Some people say its a choice"
			@johnson\say "That i call bullshit"
			@johnson\say "You can feel it"
			@johnson\say "And even if you dont want it"
			@johnson\say "You will never stop being"
			@johnson\say ".%%%%.%%%%%.%%%%%%"
			@johnson\say "an investigator"
			@player\say ".%%%%.%%%%%.%%%%%%"
			@player\say ".%%%%.%%%%%.%%%%%%"
			@player\say "Thank you mr.johnson"


			@description\say "I cant go on"
			@description\say "I feel like my game ends here"
			@description\say ".%%%%.%%%%%.%%%%%%"
			SCENE.state = {}
			SCENE\transition_to "first_encounter.menu", 4
		
  elseif res == "waters"
	
		@player\say "Doing my own little undercover-investigation"
		@player\say "To impress the lieutenant"
		@player\say "I really like it"
		@player\say "Without the uniform, questioning people who dont know youre a cop"
		@player\say "Its a bit like an actor in a film"
		@player\say "So i discovered a deep interest in your field"
		@player\say "And wanted to talk with real investigators about it"
		@player\say "What do you think makes a good investigator?"
		@player\say "Maybe ill change professions"
		res = @johnson\choice { sensitive: "Look son", _label: "sensitive" },
                          { dismissive: "Look son", _label: "dismissive" },
                          { play: "Look son", _label: "play along"}
    
		if res == "sensitive"
			@johnson\say "I can imagine how hard it can be"
			@johnson\say "You got family?"
			@player\say "Yes. a wife and a daughter"
			@johnson\say "I thought so"
			@johnson\say "You want to protect them"
			@johnson\say "Save them from the pain of losing you"
			@johnson\say "But you got to make a decision son"
			@johnson\say "Because at some point you will break"
			@johnson\say "And than they will lose you too"
			@player\say ".%%%%.%%%%%.%%%%%%"
			@player\say ".%%%%.%%%%%.%%%%%%"
			@player\say "Thank you mr.johnson"


			@description\say "I cant go on"
			@description\say "I feel like my game ends here"
			@description\say ".%%%%.%%%%%.%%%%%%"
			SCENE.state = {}
			SCENE\transition_to "first_encounter.menu", 4
			
		elseif res == "dismissive"
			@johnson\say "I can imagine its hard living a double life like that"
			@johnson\say "But come on..."
			@johnson\say "Visiting a club which you had to know would be observed sooner or later"
			@johnson\say "That was a bit dumb son"
			@johnson\say "I mean, i personally dont care"
			@johnson\say "I aint no snitch you know"
			@johnson\say "But sooner or later the cover will blow"
			@johnson\say "Like a grain of sand in a storm"
			@johnson\say "And then"
			@johnson\say "You will lose everything"
			@player\say ".%%%%.%%%%%.%%%%%%"
			@player\say ".%%%%.%%%%%.%%%%%%"


			@description\say "I cant go on"
			@description\say "I feel like my game ends here"
			@description\say ".%%%%.%%%%%.%%%%%%"
			SCENE.state = {}
			SCENE\transition_to "first_encounter.menu", 4
		
		
		elseif res == "play"
			@johnson\say "Well, you gotta love the job"
			@johnson\say "People distrust you for what you are doing"
			@johnson\say "You live kind of a double life, you know?"
			@johnson\say "But it never truly lets go of you"
			@johnson\say "But i guess there is nothing you can do about it"
			@johnson\say "Some people say its a choice"
			@johnson\say "That i call bullshit"
			@johnson\say "You can feel it"
			@johnson\say "And even if you dont want it"
			@johnson\say "You will never stop being"
			@johnson\say ".%%%%.%%%%%.%%%%%%"
			@johnson\say "an investigator"
			@player\say ".%%%%.%%%%%.%%%%%%"
			@player\say ".%%%%.%%%%%.%%%%%%"
			@player\say "Thank you mr.johnson"


			@description\say "I cant go on"
			@description\say "I feel like my game ends here"
			@description\say ".%%%%.%%%%%.%%%%%%"
			SCENE.state = {}
			SCENE\transition_to "first_encounter.menu", 4
		
