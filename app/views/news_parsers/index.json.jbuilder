json.array!(@news_parsers) do |news_parser|
  json.extract! news_parser, :id
  json.url news_parser_url(news_parser, format: :json)
end
