{ audio: la } = love

class Sound
  new: =>
    @sounds = {}

  get: (sound) =>
    unless @sounds[sound]
      @sounds[sound] = la.newSource "assets/sounds/#{sound}.wav"

    @sounds[sound]

  play: (sound, volume=1, loop=false, pos) =>
    with @get sound
      \setVolume volume
      \setLooping loop
      \setPosition (pos/1000)\unpack! if pos
      \play!

  stop: =>
    for k, sound in pairs @sounds
      sound\stop!
      @sounds[k] = nil

  setVolume: (...) => la.setVolume ...
  setPosition: (vec) => la.setPosition (vec / 1000)\unpack!

{
  :Sound
}
