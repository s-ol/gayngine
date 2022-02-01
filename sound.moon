{ audio: la } = love

class Sound
  new: =>
    @sounds = {}
    @loops = {}

  get: (sound) =>
    unless @sounds[sound]
      @sounds[sound] = la.newSource "assets/sounds/#{sound}.wav", "static"

    @sounds[sound]

  play: (sound, volume=1, loop=false, pos) =>
    with @get sound
      \setVolume volume
      \setLooping loop
      \setPosition (pos/100)\unpack!, 0 if pos
      \play!

  stop: (scene) =>
    for patt, sound in pairs @loops
      unless scene and scene\match patt
        @loops[patt]\stop!
        @loops[patt] = nil

    for k, sound in pairs @sounds
      sound\stop!
      @sounds[k] = nil

  loopWhile: (sound, scene, volume=1, pos) =>
    return if @loops[scene]

    with @loops[scene] = la.newSource "assets/sounds/#{sound}.wav", "stream"
      \setVolume volume
      \setLooping true
      \setPosition (pos/100)\unpack!, 0 if pos
      \play!

  setVolume: (...) => la.setVolume ...
  setPosition: (vec) => la.setPosition (vec / 100)\unpack!, 0

{
  :Sound
}
