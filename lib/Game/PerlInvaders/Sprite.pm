package Game::PerlInvaders::Sprite;
use Moose;

# TODO contain x/y via Type/Constraint?
has 'position_x' => (is=>'rw',isa=>'Int',required=>0);
has 'position_y' => (is=>'rw',isa=>'Int',required=>0);
has 'direction_x' => (is=>'rw',isa=>'Int',default=>0);
has 'direction_y' => (is=>'rw',isa=>'Int',default=>0);
has 'image'   => (is=>'rw',isa=>'Str',required=>1);
has 'surface' => (is=>'rw',isa=>'SDL::Surface');
has 'rect' => (is=>'rw',isa=>'SDL::Rect');
has 'name' => (is=>'rw',isa=>'Str');

sub BUILD {
    my $self = shift;
    my $surface = SDL::Surface->new( -name => 'stuff/'.$self->image );
    my $rect= SDL::Rect->new(
        -height => $surface->height,
        -width  => $surface->width,
        -x =>$self->position_x,
        -y=>$self->position_y,
    );
    $self->surface($surface);
    $self->rect($rect);
}



sub move_right {
    my $self = shift;
    $self->position_x($self->position_x + 1);
}

sub move_left {
    my $self = shift;
    $self->position_x($self->position_x - 1);
}

sub move_up {
    my ($self, $step) = @_;
    $step//=1;
    $self->position_y($self->position_y - $step);
}

sub move_down {
    my $self = shift;
    $self->position_y($self->position_y +1);
}

no Moose;
__PACKAGE__->meta->make_immutable;

q{ listening to: various talks at YAPC::Europe 2009 }

