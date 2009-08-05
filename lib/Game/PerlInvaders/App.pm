package Game::PerlInvaders::App;
use Moose;
use 5.010;

has event => (is=>'ro',isa=>'SDL::Event',required=>1,default=>sub {SDL::Event->new});
has background => (is=>'rw',isa=>'SDL::Surface');
has background_image => (is=>'rw',isa=>'Str',required=>1);
has window=>(is=>'rw',isa=>'SDL::App');
has shooting => (is=>'rw',isa=>'Bool');
has enemies => (is=>'rw',isa=>'HashRef');

sub BUILD {
    my $self = shift;

    $self->background(SDL::Surface->new(-name=>$self->background_image));
    $self->window(SDL::App->new(
    -width  => $self->background->width, 
    -height => $self->background->height,
    -depth  => 16,
        
    ));
    $self->background->blit( undef, $self->window, undef );

}

sub load_enemies {
    my ($self, $count) = @_;
    $count ||= 10;
    my %enemies;
    my $pos=20;
    
    foreach my $cnt (1 .. $count) {
        my $e =Game::PerlInvaders::Sprite->new({
            image=>'enemy.png',
            position_x=>$pos,
            position_y=>20,
            direction_x=>1,
            direction_y=>0,
            name=>$cnt,
        });
        $pos+='50';
        $self->draw_sprite($e);
        $enemies{$cnt}=$e;
    }
    $self->enemies(\%enemies);
}

sub draw_sprite {
    my ($self, $sprite) = @_;
    
    $self->background->blit($sprite->rect,$self->window,$sprite->rect);
    
    $sprite->rect->x($sprite->position_x);
    $sprite->rect->y($sprite->position_y);

    $sprite->surface->blit( undef, $self->window, $sprite->rect );
}

sub move_like_a_space_invader {
    my ($self,$sprite) = @_;

    my $dir = $sprite->direction_x;
    if ($dir == '1') {
        if ($sprite->position_x <= ($self->background->width - 
        $sprite->surface->width)) {
            $sprite->move_right;
        }
        else {
            $sprite->position_y($sprite->position_y + $sprite->surface->height + 5);
            $sprite->direction_x('-1');
        }
    }
    elsif ($dir == '-1') {
        if ($sprite->position_x > 0) {

            $sprite->move_left;
        }
        else {
            $sprite->position_y($sprite->position_y + $sprite->surface->height + 5);
            $sprite->direction_x('1');
        }
    }
}

sub move_shot {
    my ($self,$sprite) = @_;
    if ($sprite->position_y > (0 - $sprite->surface->height)) {
        $sprite->move_up(3);
    }
    else {
        $self->background->blit($sprite->rect,$self->window,$sprite->rect);
        undef $sprite;
        $self->shooting(0);
    }
}

sub check_collision {
    my ($self,$enemy,$shot) = @_;
    if ($self->rects_overlap($enemy->rect,$shot->rect)) {
        $self->background->blit($shot->rect,$self->window,$shot->rect);
        undef $shot;
        $self->shooting(0);
        $self->background->blit($enemy->rect,$self->window,$enemy->rect);
        delete $self->enemies->{$enemy->name};
    }
}

sub rects_overlap {
      my($self,$r1, $r2) = @_;

      my $r1x1 = $r1->x;
      my $r1y1 = $r1->y;

      my $r1x2 = $r1->x + $r1->width;
      my $r1y2 = $r1->y + $r1->height;

      my $r2x1 = $r2->x;
      my $r2y1 = $r2->y;

      my $r2x2 = $r2->x + $r2->width;
      my $r2y2 = $r2->y + $r2->height;

      return 0 if ($r2y2 < $r1y1);
      return 0 if ($r1y2 < $r2y1);

      return 0 if ($r2x2 < $r1x1);
      return 0 if ($r1x2 < $r2x1);

      return 1;

}

no Moose;
__PACKAGE__->meta->make_immutable;

q{ listening to: various talks at YAPC::Europe 2009 }
