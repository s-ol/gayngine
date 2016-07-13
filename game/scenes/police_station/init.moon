import Dialogue from require "game.dialogue"

main = Dialogue =>
  SCENE.state.received_briefing = true
  @lieutenant\say "ok fellas, listen up!"
  @lieutenant\say "we all know whats on stake here. weve been preparing for this operation for two months now!"
  @lieutenant\say "i will go over the details quickly:"
  @lieutenant\say "as you all know we have been investigating several nightclubs and other establishments in the past months."
  @lieutenant\say "reports by our undercover investigators revealed a healthy amount of drug use and most likely drug trafficking within those clubs."
  @lieutenant\say "after last weeks razzia of club cyclops we have confiscated less than we hoped and i sincerely hope that we can change that tonight"
  @lieutenant\say "further investigation is still pending but as far a i know the pictures are being developed as we speak."
  @lieutenant\say "in fact i would like officer parelli to go down to the lab and pick them up. i am sure you are familiar with the details parelli?"

  res = @rayintro\choice { ofcourse: "of course, sir", _label: "of course"},
                       { work: "sure thing, sir", _label: "sure"},
                       { onehundred: "one hundred percent, sir", _label: "one hundred percent"}

  @lieutenant\say "ok go ahead, then!"

{
  init: =>
    SOUND\play "jazz", 1, true

    @state.stlouis or= {}
    @state.hagen or= {}
    @state.trout or= {}
    @state.klein or= {}
    @state.spiegel or= {}

    if @last_scene
      for spawn in *@instances.playerspawn
        if @last_scene\match spawn.pattern
          spawn\start!
          break
    else
      @instances.playerspawn[1]\start!

    if @scene == "police_station" and not @state.received_briefing and (not @lastscene or not @last_scene\match "police_station")
      main\start!
}
