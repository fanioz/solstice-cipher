const fs = require('fs');

const rooms = [
    {
        id: 1,
        title: 'Dawn Chamber',
        mirrors: [
            { id: 1, x: 150, y: 200, rotation: 135 },
            { id: 2, x: 350, y: 150, rotation: 45 },
            { id: 3, x: 250, y: 300, rotation: 90 }
        ],
        cipherSymbols: [
            { id: 1, x: 450, y: 380, symbol: 'S' },
            { id: 2, x: 500, y: 350, symbol: 'U' },
            { id: 3, x: 520, y: 300, symbol: 'N' }
        ],
        sunPosition: { x: 50, y: 50 }
    },
    {
        id: 2,
        title: 'Morning Hall',
        mirrors: [
            { id: 1, x: 100, y: 180, rotation: 120 },
            { id: 2, x: 300, y: 120, rotation: 60 },
            { id: 3, x: 400, y: 250, rotation: 150 },
            { id: 4, x: 200, y: 320, rotation: 30 }
        ],
        cipherSymbols: [
            { id: 1, x: 480, y: 380, symbol: 'R' },
            { id: 2, x: 520, y: 320, symbol: 'I' },
            { id: 3, x: 540, y: 280, symbol: 'S' },
            { id: 4, x: 500, y: 220, symbol: 'E' }
        ],
        sunPosition: { x: 80, y: 60 }
    },
    {
        id: 3,
        title: 'Noon Sanctum',
        mirrors: [
            { id: 1, x: 120, y: 150, rotation: 90 },
            { id: 2, x: 280, y: 100, rotation: 135 },
            { id: 3, x: 380, y: 200, rotation: 45 },
            { id: 4, x: 250, y: 300, rotation: 180 },
            { id: 5, x: 450, y: 280, rotation: 270 }
        ],
        cipherSymbols: [
            { id: 1, x: 500, y: 380, symbol: 'A' },
            { id: 2, x: 530, y: 340, symbol: 'N' },
            { id: 3, x: 550, y: 300, symbol: 'D' }
        ],
        sunPosition: { x: 100, y: 40 }
    },
    {
        id: 4,
        title: 'Afternoon Court',
        mirrors: [
            { id: 1, x: 80, y: 200, rotation: 110 },
            { id: 2, x: 250, y: 140, rotation: 70 },
            { id: 3, x: 350, y: 220, rotation: 130 },
            { id: 4, x: 180, y: 320, rotation: 50 },
            { id: 5, x: 420, y: 180, rotation: 160 }
        ],
        cipherSymbols: [
            { id: 1, x: 480, y: 370, symbol: 'S' },
            { id: 2, x: 520, y: 330, symbol: 'E' },
            { id: 3, x: 540, y: 290, symbol: 'T' }
        ],
        sunPosition: { x: 60, y: 80 }
    },
    {
        id: 5,
        title: 'Sunset Spire',
        mirrors: [
            { id: 1, x: 100, y: 170, rotation: 100 },
            { id: 2, x: 260, y: 110, rotation: 80 },
            { id: 3, x: 360, y: 190, rotation: 140 },
            { id: 4, x: 200, y: 290, rotation: 40 },
            { id: 5, x: 440, y: 240, rotation: 170 }
        ],
        cipherSymbols: [
            { id: 1, x: 490, y: 360, symbol: 'S' },
            { id: 2, x: 530, y: 320, symbol: 'O' },
            { id: 3, x: 550, y: 280, symbol: 'L' }
        ],
        sunPosition: { x: 40, y: 100 }
    }
];

function calculateAngle(fromX, fromY, toX, toY) {
    return Math.atan2(toY - fromY, toX - fromX) * (180 / Math.PI);
}

function calculateDistance(fromX, fromY, toX, toY) {
    return Math.sqrt(Math.pow(toX - fromX, 2) + Math.pow(toY - fromY, 2));
}

function getDistanceToRay(rayStartX, rayStartY, rayEndX, rayEndY, symbolCenterX, symbolCenterY) {
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

    return calculateDistance(closestX, closestY, symbolCenterX, symbolCenterY);
}

rooms.forEach(room => {
    console.log(`\nRoom: ${room.title}`);
    const sunX = room.sunPosition.x;
    const sunY = room.sunPosition.y;

    room.mirrors.forEach(mirror => {
        const mirrorCenterX = mirror.x + 30;
        const mirrorCenterY = mirror.y + 30;
        
        let bestTarget = null;
        let bestDist = 100;
        let bestAngle = -1;

        for (let angle = 0; angle < 360; angle += 5) {
            const currentRotation = angle;
            
            const incidentAngle = calculateAngle(sunX, sunY, mirrorCenterX, mirrorCenterY);
            const normalAngle = currentRotation - 90;
            const reflectionAngle = 2 * normalAngle - incidentAngle - 180;

            const rayLength = 800;
            const reflectedEndX = mirrorCenterX + Math.cos(reflectionAngle * Math.PI / 180) * rayLength;
            const reflectedEndY = mirrorCenterY + Math.sin(reflectionAngle * Math.PI / 180) * rayLength;

            room.cipherSymbols.forEach(symbol => {
                const symbolCenterX = symbol.x + 25;
                const symbolCenterY = symbol.y + 25;
                const dist = getDistanceToRay(mirrorCenterX, mirrorCenterY, reflectedEndX, reflectedEndY, symbolCenterX, symbolCenterY);
                if (dist < 30 && dist < bestDist) {
                    bestDist = dist;
                    bestAngle = currentRotation;
                    bestTarget = symbol.symbol;
                }
            });
        }
        if (bestTarget) {
            console.log(`Mirror ${mirror.id} hits '${bestTarget}' at rotation ${bestAngle}° (dist: ${bestDist.toFixed(2)})`);
        }
    });
});
