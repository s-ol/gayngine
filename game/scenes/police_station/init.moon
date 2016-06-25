import Dialogue from require "game.dialogue"

main = Dialogue =>
  @lieutenant\say "ok fellas, listen up!"
  @lieutenant\say "we all know whats on stake here. weve been preparing for this operation for two months now!"
  @lieutenant\say "i will go over the details quickly:"
  @lieutenant\say "as you all know have we been investigating on several nightclubs and comparable establishments in the past months."
  @lieutenant\say "reports by our undercover investigators revealed a healthy amount of drug use and most likely drug trafficking within those clubs."
  @lieutenant\say "after last weeks razzia of club cyclops we have confiscated less than expected and i sincerely hope that we can change this tonight"
  @lieutenant\say "further investigation is still pending but as far a i know the pictures being developed as we speak. "
  @lieutenant\say "in fact i would like officer parelli to go down to the lab and pick them up. i am sure you are familiar with the details parelli?!"

  res = @rayintro\choice { ofcourse: "of course, sir", _label: "of course"},
                       { work: "sure thing, sir", _label: "sure"},
                       { onehundred: "one hundred percent, sir", _label: "one hundred percent"}

  @lieutenant\say "ok go ahead, then!"

{
  init: =>
    if @last_scene
      for pattern, spawn in pairs @tags.spawns
        if @last_scene\match pattern
          spawn\init!
          break
    else
      k, v = next @tags.spawns
      v\init!

    --main\start!
}
