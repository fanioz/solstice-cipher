function calculateAngle(fromX, fromY, toX, toY) {
    return Math.atan2(toY - fromY, toX - fromX) * (180 / Math.PI);
}

function currentFormula(incidentAngle, rotation) {
    const normalAngle = rotation - 90;
    return (2 * normalAngle - incidentAngle - 180 + 720 * 10) % 360;
}

function vectorFormula(incidentAngle, rotation) {
    const normalAngle = rotation - 90;
    
    // Convert to radians
    const iRad = incidentAngle * Math.PI / 180;
    const nRad = normalAngle * Math.PI / 180;
    
    // Vectors
    const Ix = Math.cos(iRad);
    const Iy = Math.sin(iRad);
    const Nx = Math.cos(nRad);
    const Ny = Math.sin(nRad);
    
    // Dot product
    const dot = Ix * Nx + Iy * Ny;
    
    // Reflected vector
    const Rx = Ix - 2 * dot * Nx;
    const Ry = Iy - 2 * dot * Ny;
    
    // Back to angle
    let rAngle = Math.atan2(Ry, Rx) * 180 / Math.PI;
    return (rAngle + 360 * 10) % 360;
}

console.log("Comparing current angle formula vs vector formula:");
const incidentAngle = 45;
for (let rotation = 0; rotation < 360; rotation += 45) {
    const cur = currentFormula(incidentAngle, rotation);
    const vec = vectorFormula(incidentAngle, rotation);
    console.log(`Rot: ${rotation} -> Cur: ${cur.toFixed(1)}, Vec: ${vec.toFixed(1)}`);
}
