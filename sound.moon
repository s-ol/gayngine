class Sound
  new: =>
    @sounds = {}

  play: (sound, volume=1) =>
    unless @sounds[sound]
      @sounds[sound] = love.audio.newSource "assets/sounds/#{sound}.wav"

    source = @sounds[sound]

    source\setVolume volume
    source\play!

{
  :Sound
}
