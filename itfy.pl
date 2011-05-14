require FindBin;
{
  'Model::ItfyDB' => {
    schema_class => 'itfy::Schema::ItfyDB',
    connect_info => [
      "dbi:SQLite:dbname=$FindBin::Bin/../itfy.sqlite",
    ],
  },
  meta_json => "",
}
