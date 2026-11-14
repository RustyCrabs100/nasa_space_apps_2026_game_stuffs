use bevy::prelude::*;

/// The type of mutually exclusive camera motion.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum MotionKind {
    /// The camera is orbiting and zooming.
    OrbitZoom,
    /// The camera is panning and zooming.
    PanZoom,
    /// The camera is only zooming.
    Zoom,
}
