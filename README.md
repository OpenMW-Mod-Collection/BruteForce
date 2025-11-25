# Brute Force - Lockpicking for Barbarians (OpenMW)

Break locks with the power of your muscles!

Thieves have lockpicks, wizards have spells, and what do barbarians have? A skill issue. I propose an immersive and vanilla-friendly approach to this problem.

## Features

### Split That Bastard in Half!

By hitting a locked door or container, you might strike the lock and force it open.  
The requirement is simple enough that any barbarian can figure it out:  
**Strength vs Lock Level + 25 (configurable)**  
So bring some sujamma next time you go adventuring.

Your weapon doesn't matter - but your skills do. The mod follows the vanilla hit chance formula, so that pesky little lock might still be tricky to hit.

But be careful!

### Don't Bend the Lock!

Since you're all brawn and no brains, you might just hit it the wrong way.  
Any lock has a **15% chance** to get bent in the process (configurable) and no longer "breakable", so keep a few Scrolls of Ondusi's Unhinging or an enchanted item handy.

This helps tone down the effectiveness of absurdly strong barbarians breaking every door in their way just by looking in their general direction.

### And Don't Forget That Breaking Locks is LOUD!

It shouldn't be a surprise that hitting a lock with a chunk of metal (or anything, really) is loud. So breaking locks in tombs, ruins, or caves shouldn't make much of a difference, but in cities... let's just say, get ready to cause some ruckus.

If you hit an owned lock, two things happen for each present NPC:

1. **A long distance line of sight check** (influenced by Sneak level) - NPC moved a head in the direction of noise and saw you with a weapon. Imagine a look on their face.
2. **A shorter distance distance check** (influenced by Weapon Skill level) - NPC heard loud noise even through a wall. Your crime has been reported immediately.

At first I thought that it would be too restrictive. But let's be real - barbarians aren't supposed to be super good at thievery in the first place. They don't avoid combat - they initiate it!  
All values, of course, are configurable too.

## Known Issues

### Lock's "bent" status is removed only when a player opens it's container/door

So if you bend a lock, unlock it the traditional way, lock it back with a spell or console command without interacting with door/container it was locking, the mod will continue thinking that the lock is still bent. This is intended, since it's impact is negligible and making additional checks on cell transition would harm the performance more than helping it.

## Requirements

[**Impact Effects**](https://www.nexusmods.com/morrowind/mods/55508) by taitechnic is a hard requirement.

## Special Thanks

**taitechnic** – making Impact Effects which is core to this mod and a fantastic mod by itself.
**AOSity** - idea for alarming NPC on breaking an owned lock.