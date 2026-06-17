---
title: "Building Solstice Cipher: A Light-Based Puzzle Game for the Browser"
description: "How I built a complete browser puzzle game with light ray casting, mirror physics, and cipher decoding mechanics for the Dev.to Solstice Hackathon"
published: false
tags: [javascript, gamedev, webdev, hackathon]
canonical_url: https://github.com/fanioz/solstice-cipher
cover_image: https://fanioz.github.io/solstice-cipher/screenshot.png
---

# Building Solstice Cipher: A Light-Based Puzzle Game for the Browser

When I saw the Dev.to Solstice Hackathon announcement, I wanted to create something that captured the essence of the solstice theme—light, shadow, and the transition from dawn to dusk. What started as a simple puzzle concept evolved into **Solstice Cipher**, a complete browser game where players manipulate mirrors to cast revealing shadows and decode ancient symbols.

## The Concept

The core idea was deceptively simple: create a puzzle game where players rotate mirrors to direct light rays onto hidden cipher symbols. Each revealed letter contributes to a larger message, and completing all five chambers (from Dawn to Sunset) reveals the complete solstice cipher.

What appealed to me about this concept was the thematic connection between the mechanics and the subject matter. You're literally "illuminating" hidden knowledge—perfect for a solstice-themed game about the journey from darkness to light.

## Technical Architecture

I wanted to keep this as a single-file implementation using vanilla JavaScript. No frameworks, no build tools—just pure browser APIs. This decision made the game instantly playable and easy to host anywhere.

### The Game Loop

The game follows a straightforward state machine:

```javascript
const game = {
    currentRoomIndex: 0,
    selectedMirror: null,
    collectedSymbols: [],
    isComplete: false
};
```

Each room contains mirrors, cipher symbols, and a sun position. When the player rotates a mirror, the game recalculates all light rays and checks which cipher symbols are illuminated.

### Light Ray Casting

The most challenging technical problem was implementing realistic light reflection. I needed to:

1. Cast rays from the sun to each mirror
2. Calculate the reflection angle based on the mirror's rotation
3. Cast the reflected ray across the room
4. Detect when reflected rays hit cipher symbols

Here's the core ray-casting logic:

```javascript
function castLightRays() {
    room.querySelectorAll('.light-ray').forEach(ray => ray.remove());

    const currentRoom = getCurrentRoom();
    const sunX = currentRoom.sunPosition.x;
    const sunY = currentRoom.sunPosition.y;

    currentRoom.mirrors.forEach(mirror => {
        const mirrorCenterX = mirror.x + 30;
        const mirrorCenterY = mirror.y + 30;

        // Ray from sun to mirror
        createLightRay(sunX, sunY, mirrorCenterX, mirrorCenterY);

        // Calculate reflection angle based on mirror rotation
        const incidentAngle = calculateAngle(sunX, sunY, mirrorCenterX, mirrorCenterY);
        const normalAngle = mirror.rotation - 90;
        const reflectionAngle = 2 * normalAngle - incidentAngle - 180;

        // Cast reflected ray
        const rayLength = 800;
        const reflectedEndX = mirrorCenterX + Math.cos(reflectionAngle * Math.PI / 180) * rayLength;
        const reflectedEndY = mirrorCenterY + Math.sin(reflectionAngle * Math.PI / 180) * rayLength;

        createLightRay(mirrorCenterX, mirrorCenterY, reflectedEndX, reflectedEndY, true);

        // Check if reflected ray hits any cipher symbols
        currentRoom.cipherSymbols.forEach(symbol => {
            if (rayHitsSymbol(mirrorCenterX, mirrorCenterY, reflectedEndX, reflectedEndY, symbol)) {
                symbol.revealed = true;
            }
        });
    });

    renderCipherSymbols();
    updateDecodedMessage();
}
```

The reflection formula uses the law of reflection: the angle of reflection equals the angle of incidence, measured from the surface normal. The key insight was realizing that the mirror's rotation value isn't the normal angle—I needed to subtract 90 degrees to get the actual surface normal.

### Ray-Circle Collision Detection

Detecting when a light ray hits a cipher symbol required calculating the distance from the symbol's center to the line segment representing the ray. I used point-to-line-segment distance calculation:

```javascript
function rayHitsSymbol(rayStartX, rayStartY, rayEndX, rayEndY, symbol) {
    const symbolCenterX = symbol.x + 25;
    const symbolCenterY = symbol.y + 25;

    // Calculate distance from point to line segment
    const A = rayStartX - symbolCenterX;
    const B = rayStartY - symbolCenterY;
    const C = rayEndX - rayStartX;
    const D = rayEndY - rayStartY;

    const dot = A * C + B * D;
    const lenSq = C * C + D * D;
    let param = -1;

    if (lenSq !== 0) param = dot / lenSq;

    let closestX, closestY;

    if (param < 0) {
        closestX = rayStartX;
        closestY = rayStartY;
    } else if (param > 1) {
        closestX = rayEndX;
        closestY = rayEndY;
    } else {
        closestX = rayStartX + param * C;
        closestY = rayStartY + param * D;
    }

    const distance = calculateDistance(closestX, closestY, symbolCenterX, symbolCenterY);

    return distance < 30;
}
```

This calculates the closest point on the ray segment to the symbol's center, then checks if that distance is within the symbol's radius (30 pixels).

## Challenges and Solutions

### The Reflection Formula

The biggest challenge was getting the light reflection physics right. My first attempt used simple angle addition, which produced completely wrong reflections. The light would bounce in impossible directions.

I spent hours debugging this, drawing diagrams on paper and researching reflection physics. The breakthrough was realizing I needed to:

1. Calculate the incident angle (from sun to mirror)
2. Find the surface normal (mirror rotation minus 90 degrees)
3. Apply the reflection formula: `reflectionAngle = 2 * normalAngle - incidentAngle - 180`

The `-180` offset accounts for the coordinate system differences between mathematical angles and CSS rotations.

### Visual Feedback

Another challenge was making the game feel responsive. Players needed instant feedback when they rotated a mirror. I implemented this by:

- Recalculating all rays immediately after each rotation
- Animating cipher symbol revelation with CSS transitions
- Showing the decoded message update in real-time

The "aha!" moment when a player finally aligns the mirrors correctly and sees all symbols light up is pure satisfaction.

### Mobile Responsiveness

I wanted the game to work on mobile devices. This required restructuring the layout from side-by-side (game area + controls) to vertical stacking on smaller screens:

```css
@media (max-width: 768px) {
    .game-area {
        flex-direction: column;
    }

    h1 {
        font-size: 1.8rem;
    }
}
```

The touch controls already worked since they were based on click events, but I added keyboard shortcuts (arrow keys and Q/E) for desktop players who prefer keyboard navigation.

## What I Learned

Building this game taught me several unexpected lessons:

**Trigonometry in game development is non-negotiable.** I hadn't touched `Math.sin`, `Math.cos`, and `Math.atan2` since college, but they're fundamental to anything involving angles, movement, or collision detection.

**Visual feedback is everything.** Early versions had no animations, and the game felt flat. Adding CSS transitions for symbol revelation, glow effects, and smooth mirror rotation made the game feel alive.

**Scope matters.** I initially considered adding features like moving obstacles, limited rotation attempts, or a hint system. But for a hackathon submission, polishing the core mechanic was more valuable than half-implemented extras.

**Single-file architecture has trade-offs.** While it makes deployment trivial, debugging a 900-line file with HTML, CSS, and JS mixed together is challenging. For future projects, I'd separate concerns even if bundling for deployment.

## Play the Game

You can play Solstice Cipher right here—no downloads required.

{% embed https://fanioz.github.io/solstice-cipher/ }

**[Get the source code](https://github.com/fanioz/solstice-cipher)** - Available under MIT license

## The Complete Cipher

Without spoiling too much, completing all five chambers reveals a message about the solstice theme itself. The journey from dawn's first light to sunset's final shadow mirrors the player's progression through the game's mechanics.

Each chamber represents a time of day, and the collected symbols form a poetic reflection on light, shadow, and the cyclical nature of the solstice.

## Discussion

I'd love to hear your thoughts on puzzle game design:

**What's your approach to balancing puzzle difficulty?** Do you prefer hand-holding with hints, or do you let players struggle through the "aha!" moments on their own?

I chose to keep Solstice Cipher relatively simple—each room has 3-5 mirrors and 3-4 symbols, and the solutions are rarely more than a few rotations away. But I wonder if I should have added a hint system for frustrated players, or if the simplicity is part of the charm.

Let me know in the comments how you approach puzzle design in your own games!

---

**Technical Details:**
- **Language:** Vanilla JavaScript (ES6+)
- **Rendering:** Pure DOM manipulation (no Canvas)
- **File Structure:** Single HTML file (~1000 lines)
- **Browser Support:** All modern browsers
- **Mobile:** Responsive design with touch controls

**Hackathon:** Dev.to Solstice Hackathon 2026
**Theme:** Solstice / Light & Shadow
**Play Time:** 5-10 minutes
**Difficulty:** Beginner-friendly
