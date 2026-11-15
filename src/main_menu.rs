use bevy::picking::hover::Hovered;
use bevy::prelude::*;
use bevy::ui_widgets::{Activate, ActivateOnPress, Button, observe};

use bevy::prelude::If as SkipSystemOnNone;

use crate::{GameFont, GameState};

#[derive(Component)]
pub struct MainMenuItem;

const NORMAL_BUTTON: Color = Color::srgb(0.15, 0.15, 0.15);
const HOVERED_BUTTON: Color = Color::srgb(0.25, 0.25, 0.25);

pub fn sys_make_main_menu(mut commands: Commands, font: SkipSystemOnNone<Res<GameFont>>) {
    let _camera = commands
        .spawn((
            Camera::default(),
            Camera2d::default(),
            Transform::default(),
            MainMenuItem,
            Visibility::Visible,
        ))
        .id();

    let _start_button = commands
        .spawn((
            Node {
                width: percent(100),
                height: percent(100),
                justify_content: JustifyContent::Center,
                align_items: AlignItems::Center,
                ..default()
            },
            MainMenuItem,
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
}

pub fn sys_toggle_main_menu(query: Query<&mut Visibility, With<MainMenuItem>>) {
    for mut vis in query {
        vis.toggle_visible_hidden();
    }
}

fn observe_on_game_start(_: On<Activate>, mut next_state: ResMut<NextState<GameState>>) {
    next_state.set(GameState::Playing);
    println!("Game Started!");
}

fn observe_on_settings_request(_: On<Activate>, mut next_state: ResMut<NextState<GameState>>) {
    next_state.set(GameState::Settings);
    println!("Settings Requested");
}
