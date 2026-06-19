---
title: "Building Solstice Cipher: A Light-Based Puzzle Game for the Browser"
description: "How I built a complete browser puzzle game with light ray casting, mirror physics, and cipher decoding mechanics for the Dev.to June Solstice Game Jam"
published: false
tags: [godot, gamedev, webdev, hackathon]
canonical_url: https://github.com/fanioz/solstice-cipher
cover_image: https://fanioz.github.io/solstice-cipher/screenshot.png
---

*This is a submission for the [June Solstice Game Jam](https://dev.to/challenges/june-game-jam-2026-06-03)*

## What I Built

When I saw the Dev.to Solstice Game Jam announcement, I wanted to create something that captured the essence of the solstice theme—light, shadow, and the transition from dawn to dusk. What started as a simple puzzle concept evolved into **Solstice Cipher**, a complete browser puzzle game where players manipulate mirrors to cast revealing shadows and decode ancient symbols.

The core idea is deceptively simple: players rotate mirrors to direct light rays onto hidden cipher symbols. Each revealed letter contributes to a larger message, and completing all five chambers (from Dawn to Sunset) reveals the complete solstice cipher. You're literally "illuminating" hidden knowledge—perfect for a solstice-themed game about the journey from darkness to light.

You can play Solstice Cipher right here—no downloads required:
{% embed https://solstice-cipher-game.vercel.app/ %}

## Video Demo

{% embed https://www.youtube.com/watch?v=YOUR_VIDEO_ID_HERE %}

## Code

{% github fanioz/solstice-cipher %}

## How I Built It

I didn't write a single line of GDScript by hand. Instead, I took on the role of Game Director, and used **Google Antigravity**—a Gemini-powered autonomous coding agent—as my lead programmer.

I chose **Godot 4.6** as our target engine, utilizing its **Compatibility Renderer (WebGL 2)** for smooth HTML5 browser exports. My process was entirely prompt-driven and architecturally focused:

### 1. Establishing Architecture Decision Records (ADRs)
Before any code was written, I worked with Antigravity to establish strict ADRs. We defined the constraints: the light beams had to snap to 15-degree increments, saves had to be atomic to prevent corruption, and drag-and-drop had to work via physics proxies. By setting these ground rules, the AI had a solid framework to generate code that actually worked together.

### 2. Delegating the Raycasting Physics
The most mathematically complex part of the game was the light reflection. Instead of wrestling with trigonometry, I instructed the AI to leverage Godot's Jolt-backed `PhysicsDirectSpaceState3D`. Antigravity generated the implementation, using `intersect_ray()` to cast beams from the sun and `Vector3.bounce()` to calculate precise 15-degree reflections off the mirror colliders. 

### 3. Procedural Puzzle Generation
To ensure we had enough content, I tasked Antigravity with writing a Wave Function Collapse algorithm to procedurally generate the puzzle rooms. I provided the constraints (the puzzles must be mathematically solvable without trapping the light), and the AI generated an A* backwards-solver that guarantees every room has a valid solution before it's even presented to the player.

### The Shift in Development
Building *Solstice Cipher* taught me that the role of a solo dev is changing. By offloading the raw syntax and API boilerplate to Google Antigravity, I was able to spend 100% of my time on game design, balance, and user experience.

## Prize Category

**Best Ode to Alan Turing**

*Solstice Cipher* is fundamentally a game about cryptography, computation, and mechanical decryption—an interactive homage to Alan Turing's legacy. 

Just as Turing's Bombe machine required engineers to meticulously align electrical rotors to complete a circuit and crack the Enigma code, players in *Solstice Cipher* must align optical mirrors to complete a light circuit and decode a hidden message. 

Furthermore, the game's core mechanic operates as an "Optical Turing Machine." The mirrors and light beams function as physical logic gates within the game's universe. A cipher symbol is only revealed when the precise combination of angles creates a valid path—meaning every puzzle chamber is effectively a mechanical computer that the player must program using light. By blending cryptography with spatial logic, the game celebrates the intersection of mathematics and puzzle-solving that defined Turing's genius.

**Best Google AI Usage**

While the game itself doesn't make runtime API calls, its entire existence is a testament to Google's AI capabilities. *Solstice Cipher* was built from the ground up using **Google Antigravity**, a powerful Gemini-powered autonomous coding agent, acting as my Technical Director and Godot Engine Specialist. 

From finalizing the Game Design Documents (GDD) and structuring Architecture Decision Records (ADRs), to writing complex GDScript for the Jolt Physics raycasting and wave-function collapse procedural generation, Gemini co-developed every aspect of the project. It even helped me solve complex floating-point drift issues with the 15-degree light bounces! This project demonstrates the immense power of Google AI not just as an interactive feature, but as a robust game development partner.
