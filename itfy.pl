require FindBin;
{
  'Model::ItfyDB' => {
    schema_class => 'itfy::Schema::ItfyDB',
    connect_info => [
      "dbi:SQLite:dbname=$FindBin::Bin/../itfy.sqlite",
    ],
  },
  meta_json => "",
  meta_repo_root => "$FindBin::Bin/../meta_repo",
}
