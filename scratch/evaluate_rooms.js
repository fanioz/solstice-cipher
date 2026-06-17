const rooms = [
    {
        id: 1,
        title: 'Dawn Chamber',
        timer: '06:00 → 09:00',
        mirrors: [
            { id: 1, x: 25, y: 45, rotation: 135 },
            { id: 2, x: 55, y: 35, rotation: 45 },
            { id: 3, x: 40, y: 65, rotation: 90 }
        ],
        cipherSymbols: [
            { id: 1, x: 80, y: 82, symbol: 'S', revealed: false },
            { id: 2, x: 88, y: 75, symbol: 'U', revealed: false },
            { id: 3, x: 92, y: 65, symbol: 'N', revealed: false }
        ],
        sunPosition: { x: 8, y: 10 },
        completed: false
    },
    {
        id: 2,
        title: 'Morning Hall',
        timer: '09:00 → 12:00',
        mirrors: [
            { id: 1, x: 16, y: 40, rotation: 120 },
            { id: 2, x: 48, y: 26, rotation: 60 },
            { id: 3, x: 70, y: 55, rotation: 150 },
            { id: 4, x: 35, y: 70, rotation: 30 }
        ],
        cipherSymbols: [
            { id: 1, x: 85, y: 82, symbol: 'R', revealed: false },
            { id: 2, x: 92, y: 70, symbol: 'I', revealed: false },
            { id: 3, x: 96, y: 61, symbol: 'S', revealed: false },
            { id: 4, x: 88, y: 48, symbol: 'E', revealed: false }
        ],
        sunPosition: { x: 13, y: 12 },
        completed: false
    },
    {
        id: 3,
        title: 'Noon Sanctum',
        timer: '12:00 → 15:00',
        mirrors: [
            { id: 1, x: 20, y: 33, rotation: 90 },
            { id: 2, x: 45, y: 22, rotation: 135 },
            { id: 3, x: 65, y: 44, rotation: 45 },
            { id: 4, x: 42, y: 66, rotation: 180 },
            { id: 5, x: 80, y: 60, rotation: 270 }
        ],
        cipherSymbols: [
            { id: 1, x: 88, y: 82, symbol: 'A', revealed: false },
            { id: 2, x: 94, y: 74, symbol: 'N', revealed: false },
            { id: 3, x: 98, y: 65, symbol: 'D', revealed: false }
        ],
        sunPosition: { x: 16, y: 8 },
        completed: false
    },
    {
        id: 4,
        title: 'Afternoon Court',
        timer: '15:00 → 18:00',
        mirrors: [
            { id: 1, x: 13, y: 44, rotation: 110 },
            { id: 2, x: 40, y: 31, rotation: 70 },
            { id: 3, x: 60, y: 48, rotation: 130 },
            { id: 4, x: 30, y: 70, rotation: 50 },
            { id: 5, x: 75, y: 40, rotation: 160 }
        ],
        cipherSymbols: [
            { id: 1, x: 85, y: 80, symbol: 'S', revealed: false },
            { id: 2, x: 92, y: 72, symbol: 'E', revealed: false },
            { id: 3, x: 96, y: 63, symbol: 'T', revealed: false }
        ],
        sunPosition: { x: 10, y: 16 },
        completed: false
    },
    {
        id: 5,
        title: 'Sunset Spire',
        timer: '18:00 → 21:00',
        mirrors: [
            { id: 1, x: 16, y: 38, rotation: 100 },
            { id: 2, x: 42, y: 24, rotation: 80 },
            { id: 3, x: 60, y: 42, rotation: 140 },
            { id: 4, x: 35, y: 64, rotation: 40 },
            { id: 5, x: 78, y: 52, rotation: 170 }
        ],
        cipherSymbols: [
            { id: 1, x: 87, y: 78, symbol: 'S', revealed: false },
            { id: 2, x: 94, y: 70, symbol: 'O', revealed: false },
            { id: 3, x: 98, y: 61, symbol: 'L', revealed: false }
        ],
        sunPosition: { x: 7, y: 20 },
        completed: false
    }
];

function calculateAngle(fromX, fromY, toX, toY) {
    return Math.atan2(toY - fromY, toX - fromX) * (180 / Math.PI);
}

function calculateDistance(fromX, fromY, toX, toY) {
    return Math.sqrt(Math.pow(toX - fromX, 2) + Math.pow(toY - fromY, 2));
}

function rayHitsSymbol(rayStartX, rayStartY, rayEndX, rayEndY, symbol, roomRect) {
    const symbolX = (symbol.x / 100) * roomRect.width;
    const symbolY = (symbol.y / 100) * roomRect.height;

    const symbolSize = Math.min(roomRect.width * 0.08, 50);
    const symbolCenterX = symbolX + symbolSize / 2;
    const symbolCenterY = symbolY + symbolSize / 2;

    const A = rayStartX - symbolCenterX;
    const B = rayStartY - symbolCenterY;
    const C = rayEndX - rayStartX;
    const D = rayEndY - rayStartY;

    const dot = A * C + B * D;
    const lenSq = C * C + D * D;
    let param = -1;

    if (lenSq !== 0) param = -dot / lenSq;

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
    const hitThreshold = symbolSize * 0.6;
    return distance < hitThreshold;
}

const roomRect = { width: 800, height: 600 };

rooms.forEach(room => {
    console.log(`\nRoom: ${room.title}`);
    const sunX = (room.sunPosition.x / 100) * roomRect.width;
    const sunY = (room.sunPosition.y / 100) * roomRect.height;

    room.mirrors.forEach(mirror => {
        const mirrorX = (mirror.x / 100) * roomRect.width;
        const mirrorY = (mirror.y / 100) * roomRect.height;
        const mirrorSize = Math.min(roomRect.width * 0.1, 60);
        const mirrorCenterX = mirrorX + mirrorSize / 2;
        const mirrorCenterY = mirrorY + mirrorSize / 2;

        let hits = [];
        // Test all rotations in 5 degree increments (since buttons rotate by 5 or 45 degrees, wait,
        // rotation left is -5, right is +5? Or is it -45 and +45?
        // Let's check buttons:
        // button id="rotate-left" -> -45
        // button id="rotate-right" -> +45
        // But keyboard arrow keys and 'q'/'e' rotate by 5 degrees:
        // rotateMirror(direction) -> const rotation = direction === 'left' ? -5 : 5;
        // So any 5 degree rotation is reachable!
        for (let rotation = 0; rotation < 360; rotation += 5) {
            const incidentAngle = calculateAngle(sunX, sunY, mirrorCenterX, mirrorCenterY);
            const normalAngle = rotation - 90;
            const reflectionAngle = 2 * normalAngle - incidentAngle - 180;

            const rayLength = Math.max(roomRect.width, roomRect.height) * 2;
            const reflectedEndX = mirrorCenterX + Math.cos(reflectionAngle * Math.PI / 180) * rayLength;
            const reflectedEndY = mirrorCenterY + Math.sin(reflectionAngle * Math.PI / 180) * rayLength;

            room.cipherSymbols.forEach(symbol => {
                if (rayHitsSymbol(mirrorCenterX, mirrorCenterY, reflectedEndX, reflectedEndY, symbol, roomRect)) {
                    hits.push({ rotation, symbol: symbol.symbol });
                }
            });
        }
        
        if (hits.length > 0) {
            // Group by symbol
            const syms = [...new Set(hits.map(h => h.symbol))];
            syms.forEach(s => {
                const rots = hits.filter(h => h.symbol === s).map(h => h.rotation);
                console.log(`  Mirror ${mirror.id} can hit '${s}' at rotations: ${rots.join(', ')}`);
            });
        } else {
            console.log(`  Mirror ${mirror.id} cannot hit any symbol.`);
        }
    });
});
