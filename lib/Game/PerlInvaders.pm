package Game::PerlInvaders;
use 5.010;
use strict;
use warnings;

use version 0.77; our $VERSION = qv('0.0.1');
1;

__END__

=head1 NAME

Game::PerlInvaders - space invaders game implemented using SDL

=head1 SYNOPSIS

  # no usage atm

=head1 DESCRIPTION

A rather simple game of Space Invaders, implemented in a few hours 
during YAPC::Europe 2009 to get people interested in developing games 
using Perl and SDL.

As I'm far from a SDL expert, the implementation might suck. If so, 
patches welcome!

Installation currently does not work, so you should run PerlInvaders 
in the project directory:
  
  perl -Ilib bin/perl_invaders.pl

=head1 AUTHOR

Thomas Klausner E<lt>domm {at} cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

