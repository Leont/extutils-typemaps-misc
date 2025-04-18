package ExtUtils::Typemaps::Slurp;

use strict;
use warnings;

use parent 'ExtUtils::Typemaps';

sub new {
	my $class = shift;

	my $self = $class->SUPER::new(@_);

	$self->add_inputmap(xstype => 'T_SLURP_VAL', code => '	$var = ${ntype}_gather(&ST($argoff), items - $argoff)');
	$self->add_inputmap(xstype => 'T_SLURP_VAR', code => '	${ntype}_gather(&$var, &ST($argoff), items - $argoff)');
	$self->add_inputmap(xstype => 'T_SLURP_AV',  code => '	$var = av_make(items - $argoff, &ST($argoff))');
	
	return $self;
}

1;

# ABSTRACT: Typemap for slurping arguments

=head1 SYNOPSIS

In typemap

 my_init_t    T_SLURP_VAR
 My::Object   T_OPAQUEOBJ

In your XS:

 static void my_init_t_gather(my_init_t* init, SV** args, size_t count) {
     ...;
 }

 typedef object_t* My__Object;

 static object_t* object_new(my_init_t* init_arg) {
     ...;
 }
 
 MODULE = My::Object    PACKAGE = My::Object    PREFIX = object_
 
 My::Object object_new(SV* class, my_init_t arguments, ...)
	C_ARGS: &arguments

=head1 DESCRIPTION

C<ExtUtils::Typemaps::Slurp> is a typemap bundle that provides three typemaps that will all slurp all remaining arguments to an xsub: C<T_SLURP_VAL>, C<T_SLURP_VAR> and C<T_SLURP_AV>. This should always be used as final argument, and should be followed by a C<...> argument.

C<T_SLURP_VAL> expects you to define a function C<$type ${ntype}_gather(SV** arguments, size_t count)>. It will call that function with the argument, and it will return the appropriate value.

C<T_SLURP_VAR> expects you to define a function C<void ${ntype}_gather($type* var, SV** arguments, Size_t count)>. It works much the same as C<TL_SLURP_VAL> except it takes a pointer as its first argument that it will store the value in instead of returning it.

C<T_SLURP_AV> is a specialization of C<T_SLURP_VAL> that returns the values as an C<AV*>.

=head1 INCLUSION

To use this typemap template you need to include it into your local typemap. The easiest way to do that is to use the L<typemap> script in L<App::typemap>. E.g.

 typemap --merge ExtUtils::Typemaps::IntObj

If you author using C<Dist::Zilla> you can use L<Dist::Zilla::Plugin::Typemap> instead.

Alternatively, you can include it at runtime by adding the following to your XS file:

 INCLUDE_COMMAND: $^X -MExtUtils::Typemaps::Cmd -e "print embeddable_typemap('IntObj')"

That does require adding a build time dependency on this module.
