curl -XGET 'localhost:9200/booksindex/booksidx/_search?pretty=true' -d '{
    "query": {
        "match": {
            "title" : "elasticsearch"
        }
    }
}'

