const fs = require('fs');

const rooms = [
    {
        id: 1,
        title: 'Dawn Chamber',
        timer: '06:00 → 09:00',
        mirrors: [
            { id: 1, x: 150, y: 200, rotation: 135 },
            { id: 2, x: 350, y: 150, rotation: 45 },
            { id: 3, x: 250, y: 300, rotation: 90 }
        ],
        cipherSymbols: [
            { id: 1, x: 450, y: 380, symbol: 'S', revealed: false },
            { id: 2, x: 500, y: 350, symbol: 'U', revealed: false },
            { id: 3, x: 520, y: 300, symbol: 'N', revealed: false }
        ],
        sunPosition: { x: 50, y: 50 },
        completed: false
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

    if (lenSq !== 0) param = -dot / lenSq; // Corrected formula

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
        
        let hits = {};
        for (let angle = 0; angle < 360; angle++) {
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
                if (dist < 30) {
                    if (!hits[symbol.symbol]) hits[symbol.symbol] = [];
                    hits[symbol.symbol].push(angle);
                }
            });
        }
        for (let sym in hits) {
            console.log(`Mirror ${mirror.id} hits '${sym}' at rotations: ${Math.min(...hits[sym])} to ${Math.max(...hits[sym])}`);
        }
    });
});
