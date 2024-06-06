package ludi.commons.math;

import ludi.commons.math.Vec2;
import ludi.commons.math.IVec2;

class Physics {
    public static function pull(target: Vec2, moving: Vec2, force: Vec2): PullResult {
        var direction: Vec2 = new Vec2(target.x - moving.x, target.y - moving.y);
        
        var distanceSquared: Float = direction.x * direction.x + direction.y * direction.y;
        var forceSquared: Float = force.x * force.x + force.y * force.y;
        
        // If the squared distance is less than the squared force, snap to the target.
        if (distanceSquared < forceSquared) {
            return Complete(new Vec2(target.x, target.y));
        } else {
            // Normalize the direction vector
            var distance: Float = Math.sqrt(distanceSquared);
            direction.x /= distance;
            direction.y /= distance;
            
            // Add the force vector to the moving vector
            return Incomplete(new Vec2(moving.x + direction.x * force.x, moving.y + direction.y * force.y));
        }
    }
}

enum PullResult {
    Complete(v: Vec2);
    Incomplete(v: Vec2);
}