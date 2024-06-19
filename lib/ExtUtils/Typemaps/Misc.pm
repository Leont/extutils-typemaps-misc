package ExtUtils::Typemaps::Misc;

use strict;
use warnings;

1;

# ABSTRACT: A collection of miscelaneous typemap templates

=head1 DESCRIPTION

This distribution is a collection of the following typemap bundles:

=head2 OpaqueObj

L<ExtUtils::Typemaps::OpaqueObj> is a typemap bundle that contains C<T_OPAQUEOBJ>, a typemap for objects that are self contained and therefore can safely be copied for serialization and thread cloning.

=head2 IntObj

L<ExtUtils::Typemaps::IntObj> is a typemap bundle that contains C<T_INTOBJ> and C<INTREF>. This allows you to wrap an integer-like datatype (such as a handle) into a Perl object.

=head2 Slurp

L<ExtUtils::Typemaps::Slurp> is a typemap bundle that contains C<T_SLURP_VAL>, C<T_SLURP_VAR> and C<T_SLURP_AV>. These help when slurping all remaining arguments into a single value.
