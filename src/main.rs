use bevy::prelude::*;

mod main_menu;

#[derive(Debug, Clone, Copy, Default, Eq, PartialEq, Hash, States)]
enum GameState {
    #[default]
    MainMenu,
    Settings,
    Playing,
}

#[derive(Resource)]
pub struct GameFont {
    source: FontSource,
}

fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .init_state::<GameState>()
        .add_systems(PreStartup, sys_load_font)
        .add_systems(
            OnEnter(GameState::MainMenu),
            main_menu::sys_toggle_main_menu,
        )
        .add_systems(Startup, main_menu::sys_make_main_menu.run_if(run_once))
        .add_systems(OnExit(GameState::MainMenu), main_menu::sys_toggle_main_menu)
        .run();
}

fn sys_load_font(mut commands: Commands, asset_server: Res<AssetServer>) {
    let font = asset_server.load::<bevy::prelude::Font>("others/pixels_bjn5.ttf");

    let font_source = FontSource::Handle(font);

    println!("Size of Font: {0}", core::mem::size_of_val(&font_source));

    commands.insert_resource(GameFont {
        source: font_source,
    });
}
