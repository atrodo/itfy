require FindBin;
{
  'Model::ItfyDB' => {
    schema_class => 'itfy::Schema::ItfyDB',
    connect_info => [
      "dbi:sqlite:database='$FindBin::Bin/../itfy.sqlite",
    ],
  }
}
