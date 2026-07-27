# Brute Force - Lockpicking for Barbarians (OpenMW)

## 1.5.3

- Fixed crime detection

## 1.5.2

- Fixed issue when bashing trapped containers with Hidden Traps
- Fixed bashing a trapped door/container with Hidden Traps triggering Convenient Thief Tools's probe equipment instead of the trap (thx Foxunder)
- Compatible only with Hidden Traps 1.0.2 or newer

## 1.5.1

- Added Hidden Traps support

## 1.5

- Breaking a lock on a door now also opens it

## 1.4

- Added follower checks when breaking owned lock. Requires Follower Detection Util to work, but it's not enforced

## 1.3

### Features

- New SFX for breaking and bending locks
- Breaking trapped locks trigger traps
- Hitting non-locked objects trigger traps too
- Improved ownership checking
- Restructured code. Hopefully, everything has been left in tact

## 1.2.4

### Fixes

- Fixed message disabling

## 1.2.3

### Fixes

- Fixed hits against non-objects (terrain, water) breaking the mod

## 1.2.2

### Fixes

- Fixed not dealing damage to player on h2h hits and misses

## 1.2.1

### Fixes

- Fixed blunt weapons once again. Hopefully, for the last time
- Fixed the "Enable Unlocking with Too Worn or Weak Weapons" feature assuming weapon condition = max weapon health

## 1.2

### Features

- Rearranged settings
- Weapon now is getting damaged when hitting a lock depending on lock's level. Weapon wears out on successful unlocks or getting the lock bent
- If weapon's durability is too low, it will either wear out to 0 durability or prevent player from breaking the lock with it (default)
- Improved and more informative messages
- Option to disable getting damaged on h2h misses
- Option to ignore bent locks
- Option to disable messages (why?)

### Fixes

- Whitelisted just NPCs for alerting checks

## 1.1.2

### Fixes

- Fixed error when trying to check NPC class for alerting

## 1.1.1

### Fixes

- Fixed blunt weapons not hitting the doors/containers

## 1.1

### Features

- Hitting locks with bare hands will damage the player (thanks Hemaris for the idea)

## 1.0

Initial release