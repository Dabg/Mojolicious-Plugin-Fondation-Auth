package Mojolicious::Plugin::Fondation::Auth::Provider;
use Mojo::Base -base, -signatures;

has 'app';
has 'name';     # provider name (ex: 'file', 'dbix')
has 'timeout_sessions';

# Methods that each concrete provider must implement
sub validate_user { die "Method 'validate_user' must be implemented by provider" }
sub load_user     { die "Method 'load_user' must be implemented by provider" }

# Helper to log easily from any provider
# sub log ($self, $level, $message) {
#     return unless $self->app && $self->app->can('log');
#     $self->app->log->$level("Auth::Multi::$self->name: $message");
# }

sub log ($self) {
    return unless $self->app && $self->app->can('log');
    $self->app->log;
}

sub apply_timeout ($self) {
    return unless $self->timeout_sessions && $self->app;
    $self->app->sessions->default_expiration($self->timeout_sessions);
    $self->log->info("Session timeout applied: $self->timeout_sessions seconds");
}

sub auth_form ($self) {
    # Provides a minimal generic HTML form by default
    return <<'HTML';
<form method="post">
<p>Login form not implemented for this provider</p>
</form>
HTML
}

1;

__END__

=head1 NAME

Mojolicious::Plugin::Fondation::Auth::Provider - Base class for authentication providers

=head1 SYNOPSIS

    package Mojolicious::Plugin::Fondation::Auth::Provider::File;
    use Mojo::Base 'Mojolicious::Plugin::Fondation::Auth::Provider', -signatures;

    # Then implement validate_user() and load_user()
=cut

1;
