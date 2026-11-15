use bevy::{gltf::GltfMesh, prelude::*};

#[derive(Resource)]
pub struct Buildings {
    pub greenhouse: Gltf,
    pub large_crew_cabin: Gltf,
    pub small_crew_cabin: Gltf,
    pub solar_panel: SolarPanel,
    pub storage_silo: Gltf,
    pub miscellaneous: Gltf,
}

#[non_exhaustive]
pub enum BuildingType {
    SolarPanel,
    SmallCrewCabin,
    LargeCrewCabin,
    StorageSilo,
    Greenhouse,
    Miscellaneous,
}

pub struct SolarPanel {
    pub panel: Gltf,
    pub root: Gltf,
}

pub fn sys_load_buildings_resource(
    mut loaded: Local<bool>,
    mut commands: Commands,
    gltf_assets: Res<Assets<Gltf>>,
    asset_server: Res<AssetServer>,
) {
    if *loaded {
        return;
    }

    let greenhouse = GltfAssetLabel::Scene(0).from_asset("models/greenhouse.glb");

    commands.spawn((
        WorldAssetRoot(asset_server.load(greenhouse)),
        Transform::from_xyz(0.0, 0.0, 0.0),
    ));

    *loaded = true;

    println!("Loading Done!");
}
