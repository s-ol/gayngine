During the project planning, I decided to write a custom engine with features that empower our artist.
One of these features is the direct loading of photoshop .PSD files and the automatic reloading.

I started implementing this as a small demo and to see whether there would be any major issues with my idea.
As it turns out, not so much:

In the clip above you can see me adding a "3" to a new layer in photoshop and saving it, which automatically
triggers a sprite reload in the game window. There's no need to export to a spritesheet or anything similar,
the different animation frames can lie on top of each other like they usually do in the workflow and all it takes to preview them in action is a `ctrl + s`.
