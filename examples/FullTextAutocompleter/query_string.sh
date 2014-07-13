curl -XGET 'localhost:9200/booksindex/booksidx/_search?pretty=true' -d '{
  "query": {
    "query_string": {
      "query": "mastering by marek",
      "fields": [
        "title.title_shingles^2",
        "author.author_shingles"
      ]
    }
  }
}'
