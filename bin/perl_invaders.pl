use 5.010; use strict; use warnings;
use SDL::App;
use SDL::Event;
use PerlInvaders::Sprite;
use PerlInvaders::App;

my $app=PerlInvaders::App->new(
    background_image=>'stuff/stars.png',
);

my $onion = PerlInvaders::Sprite->new(
    image=>'onion.png',
    position_x      => int(rand($app->background->width / 2)),
);
$onion->rect->y($app->background->height - ($onion->surface->height +5));

my $dir_x=0;
my $dir_y=0;

$app->load_enemies(10);

my $shot;

while (1) {
    while ($app->event->poll) {
        my $type = $app->event->type;
        exit if ($type == SDL_QUIT());
        exit if ($type == SDL_KEYDOWN() && $app->event->key_name eq 'escape');
    
        my $key = $app->event->key_name();
        if ($type == SDL_KEYDOWN()) {
            given ($key) {
                when ('right') { $dir_x=1 }
                when ('left') { $dir_x=-1 }
                when ('space') {
                    unless ($app->shooting) {
                        $app->shooting(1);
                        $shot= PerlInvaders::Sprite->new(
                            position_x=>$onion->rect->x + int($onion->surface->width / 2),
                            position_y=>$onion->rect->y,
                            direction_x=>0,
                            direction_y=>1,
                            image=>'shot.png',
                        );
                    }
                }
            }
        }
        if ($type == SDL_KEYUP()) {
            given ($key) {
                when ('right') { $dir_x=0 }
                when ('left') { $dir_x=0 }
            }
        }
    }

    foreach (sort keys %{$app->enemies}) {
        my $enemy = $app->enemies->{$_};
        $app->move_like_a_space_invader($enemy);
        $app->check_collision($enemy,$shot) if $app->shooting;
        $app->draw_sprite($enemy);
    }
    if ($app->shooting && $shot) {
        $app->move_shot($shot);
        $app->draw_sprite($shot);
    }
    
    # move onion TODO refactor
    $dir_x=0 if ($onion->rect->x >= ($app->background->width - 
    $onion->surface->width)) && $dir_x==1;
    $dir_x=0 if $onion->rect->x <= 0 && $dir_x == -1;
    $dir_y=0 if $onion->rect->y >= ($app->background->height - 
    $onion->surface->height) && $dir_y==1;
    $dir_y=0 if $onion->rect->y <= 0 && $dir_y ==-1;
    $app->background->blit($onion->rect,$app->window,$onion->rect);
    $onion->rect->x($onion->rect->x + $dir_x);
    $onion->rect->y($onion->rect->y + $dir_y);
    $onion->surface->blit( undef, $app->window, $onion->rect );
    
    $app->window->sync;
}
