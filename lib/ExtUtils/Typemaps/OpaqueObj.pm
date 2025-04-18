package ExtUtils::Typemaps::OpaqueObj;

use strict;
use warnings;

use parent 'ExtUtils::Typemaps';

sub new {
	my $class = shift;

	my $self = $class->SUPER::new(@_);

	$self->add_inputmap(xstype => 'T_OPAQUEOBJ', code => <<'END');
    {
		SV * sv = $arg;
		if (SvROK(sv) && SvPOK(SvRV(sv)) && SvCUR(SvRV(sv)) == sizeof(*$var))
			$var = ($type)SvPV_nolen(SvRV(sv));
		else
			croak(\"%s: %s is not of type %s\", ${$ALIAS?\q[GvNAME(CvGV(cv))]:\qq[\"$pname\"]}, \"$var\", \"$ntype\");
    }
END

	$self->add_inputmap(xstype => 'T_OPAQUEOBJ_MAYBE', code => <<'END');
	{
		SV * sv = $arg;
		if (SvOK(sv)) {
			if (SvROK(sv) && SvPOK(SvRV(sv)) && SvCUR(SvRV(sv)) == sizeof(*$var))
				$var = ($type)SvPV_nolen(SvRV(sv));
			else
				croak(\"%s: %s is not of type %s\", ${$ALIAS?\q[GvNAME(CvGV(cv))]:\qq[\"$pname\"]}, \"$var\", \"$ntype\");
		} else
			$var = NULL;
	}
END

	$self->add_outputmap(xstype => 'T_OPAQUEOBJ', code => <<'END');
	{
		sv_usepvn(newSVrv($arg, \"$ntype\"), (char*)$var, sizeof(*$var));
		SvREADONLY_on(SvRV($arg));
	}
END

	$self->add_outputmap(xstype => 'T_OPAQUEOBJ_MAYBE', code => <<'END');
	if (SvOK($var)) {
		sv_usepvn(newSVrv($arg, \"$ntype\"), (char*)$var, sizeof(*$var));
		SvREADONLY_on(SvRV($arg));
	}
END


	return $self;
}

1;

# ABSTRACT: Typemap for storing objects as a string reference

=head1 SYNOPSIS

In typemap

 Foo::Bar	T_OPAQUEOBJ

In your XS:

 typedef struct foo_bar* Foo__Bar;
 
 MODULE = Foo::Bar    PACKAGE = Foo::Bar    PREFIX = foobar_
 
 Foo::Bar foobar_new(SV* class, int argument)

 int foobar_baz(Foo::Bar self)

=head1 DESCRIPTION

C<ExtUtils::Typemaps::OpaqueObj> is an C<ExtUtils::Typemaps> subclass that stores an object inside a string reference. It is particularly suitable for objects whose entire state is helt in the struct (e.g. no pointers, handles, descriptors, …). In such cases the object will serialize and deserialize cleanly, and is safe with regards to thread cloning.

=head1 INCLUSION

To use this typemap template you need to include it into your local typemap. The easiest way to do that is to use the L<typemap> script in L<App::typemap>. E.g.

 typemap --merge ExtUtils::Typemaps::OpaqueObj

If you author using C<Dist::Zilla> you can use L<Dist::Zilla::Plugin::Typemap> instead.

Alternatively, you can include it at runtime by adding the following to your XS file:

 INCLUDE_COMMAND: $^X -MExtUtils::Typemaps::Cmd -e "print embeddable_typemap('OpaqueObj')"

That does require adding a build time dependency on this module.
