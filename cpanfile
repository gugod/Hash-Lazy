requires 'self';
requires 'Sub::Exporter';
requires 'Tie::ExtraHash';

on test => sub {
    requires 'Test::More', 0.90;
    requires 'Test2::V0';
};

on develop => sub {
    requires 'App::ModuleBuildTiny';
};
