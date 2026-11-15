mod buildings;
mod resources;

use bevy::{
    camera_controller::pan_orbit_camera::controller::component::{OrbitConstraint, PanOrbitCamera},
    gltf::GltfMesh,
    mesh::PlaneMeshBuilder,
    picking::hover::Hovered,
    prelude::*,
    ui_widgets::{Activate, ActivateOnPress, Button, observe},
};

use bevy::prelude::If as SkipSystemOnNone;

#[derive(Debug, Clone, Copy, Default, Eq, PartialEq, Hash, States)]
enum GameState {
    #[default]
    Menu,
    Playing,
    Settings,
}

#[derive(Component)]
struct GameMenuItem;

#[derive(Component)]
struct GamePlayingItem;

#[derive(Component)]
struct Building;

#[derive(Component)]
struct Player;

fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .init_state::<GameState>()
        .add_systems(PreStartup, buildings::sys_load_buildings_resource)
        /*
        .add_systems(
            OnEnter(GameState::Playing),
            (
                sys_setup_game,
                (
                    // this cant be triggered after the player is made so it won't bug out
                    sys_player_modify_visibility,
                    sys_setup_player.run_if(run_once),
                )
                    .chain(),
            ),
        )
        .add_systems(
            OnExit(GameState::Playing),
            (sys_player_modify_visibility, sys_modify_game_view),
        ) */
        .add_systems(
            OnEnter(GameState::Menu),
            (
                sys_toggle_menu_visibility,
                sys_create_menu_camera,
                // Yes this is a horrible shortcut but if anyone breaks this, its their fault
                (sys_load_font, sys_create_menu_ui).run_if(run_once).chain(),
            )
                .chain(),
        )
        .add_systems(
            OnExit(GameState::Menu),
            (sys_toggle_menu_visibility, sys_destroy_menu_camera),
        )
        .add_systems(Update, (sys_button_hover_style,))
        .run();
}

const NORMAL_BUTTON: Color = Color::srgb(0.15, 0.15, 0.15);
const HOVERED_BUTTON: Color = Color::srgb(0.25, 0.25, 0.25);

#[derive(Resource)]
struct GameFont {
    source: FontSource,
}

#[derive(Resource)]
struct MenuCamera {
    camera: Entity,
}

#[derive(Resource)]
struct MenuData {
    start: Entity,
}

fn sys_load_font(mut commands: Commands, asset_server: Res<AssetServer>) {
    let font = asset_server.load::<bevy::prelude::Font>("others/pixels_bjn5.ttf");

    let font_source = FontSource::Handle(font);

    println!("Size of Font: {0}", core::mem::size_of_val(&font_source));

    commands.insert_resource(GameFont {
        source: font_source,
    });
}

fn sys_create_menu_camera(mut commands: Commands) {
    let camera = commands.spawn((Camera2d, GameMenuItem)).id();

    commands.insert_resource(MenuCamera { camera });
}

fn sys_destroy_menu_camera(mut commands: Commands, mc: Res<MenuCamera>) {
    commands.entity(mc.camera).despawn();
}

fn sys_create_menu_ui(mut commands: Commands, font: SkipSystemOnNone<Res<GameFont>>) {
    let start_button = commands
        .spawn((
            Node {
                width: percent(100),
                height: percent(100),
                justify_content: JustifyContent::Center,
                align_items: AlignItems::Center,
                ..default()
            },
            GameMenuItem,
            Visibility::Visible,
            children![(
                Visibility::Inherited,
                Button,
                ActivateOnPress,
                Hovered::default(),
                Node {
                    width: px(150),
                    height: px(65),
                    justify_content: JustifyContent::Center,
                    align_items: AlignItems::Center,
                    ..Default::default()
                },
                BackgroundColor(NORMAL_BUTTON),
                children![(
                    Visibility::Inherited,
                    Text::new("Start"),
                    TextFont {
                        font_size: FontSize::Px(33.0),
                        font: font.source.clone(),
                        ..default()
                    },
                    TextColor(Color::srgb(0.9, 0.9, 0.9)),
                )],
                observe(observe_on_game_start)
            )],
        ))
        .id();

    commands.insert_resource(MenuData {
        start: start_button,
    });
}

fn sys_toggle_menu_visibility(
    mut commands: Commands,
    menu_item_query: Query<&mut Visibility, With<GameMenuItem>>,
) {
    for mut vis in menu_item_query {
        vis.toggle_visible_hidden();
    }
}

fn sys_button_hover_style(
    mut button_query: Query<(&Hovered, &mut BackgroundColor), (Changed<Hovered>, With<Button>)>,
) {
    for (hovered, mut color) in &mut button_query {
        if hovered.get() {
            *color = HOVERED_BUTTON.into();
        } else {
            *color = NORMAL_BUTTON.into();
        }
    }
}

fn observe_on_game_start(_: On<Activate>, mut next_state: ResMut<NextState<GameState>>) {
    next_state.set(GameState::Playing);
    println!("Game Started!");
}

fn sys_setup_player(
    mut commands: Commands,
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<StandardMaterial>>,
) {
    commands.spawn((
        Visibility::Visible,
        Camera::default(),
        Camera3d::default(),
        DirectionalLight {
            illuminance: 15000.0,
            ..default()
        },
        Player,
        Transform::from_xyz(00.0, 00.0, 1.0).look_at(Vec3::new(0.0, 0.0, 0.0), Vec3::Y),
    ));

    commands.spawn((
        Mesh3d(meshes.add(Cuboid::new(1.0, 1.0, 1.0))),
        MeshMaterial3d(materials.add(StandardMaterial {
            base_color: Color::srgb(1.0, 0.0, 0.0),
            ..default()
        })),
        Transform::default(),
    ));
}

fn sys_player_modify_visibility(mut player_query: Query<&mut Visibility, With<Player>>) {
    for mut vis in player_query {
        vis.toggle_visible_hidden();
    }
}

fn sys_setup_game(
    mut commands: Commands,
    asset_server: Res<AssetServer>,
    meshes: ResMut<Assets<Gltf>>,
    mut images: ResMut<Assets<Image>>,
    mut materials: ResMut<Assets<StandardMaterial>>,
    mut loaded: Local<bool>,
) {
    if *loaded {
        return;
    }

    // Load the assets

    *loaded = true;

    // Do smth idk
}

fn sys_modify_game_view(mut query_playing_items: Query<&mut Visibility, With<GamePlayingItem>>) {
    for mut vis in query_playing_items {
        vis.toggle_visible_hidden();
    }
}
