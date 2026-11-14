mod player_camera_plugin;

use bevy::{
    camera_controller::pan_orbit_camera::controller::component::{OrbitConstraint, PanOrbitCamera},
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
struct Player;

fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .init_state::<GameState>()
        .add_systems(Startup, (sys_setup_player).chain())
        .add_systems(
            OnEnter(GameState::Menu),
            (
                sys_toggle_menu_visibility,
                // Yes this is a horrible shortcut but if anyone breaks this, its their fault
                (sys_load_font, sys_create_menu_camera, sys_create_menu_ui)
                    .run_if(run_once)
                    .chain(),
            )
                .chain(),
        )
        .add_systems(OnExit(GameState::Menu), sys_toggle_menu_visibility)
        .add_systems(Update, sys_button_hover_style)
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
    let camera = commands
        .spawn((Camera2d, Visibility::Visible, GameMenuItem))
        .id();

    commands.insert_resource(MenuCamera { camera });
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

fn sys_setup_player(mut commands: Commands) {
    commands.spawn((
        PanOrbitCamera::default(),
        Player,
        Transform::from_xyz(1.0, 1.0, 1.0).look_at(Vec3::new(0.0, 0.0, 0.0), Vec3::Y),
    ));
}

fn sys_setup_game(mut commands: Commands) {
    todo!()
}
