curl -XPUT 'http://localhost:9200/booksindex' -d '{
    "settings" : {
        "index" : {
            "number_of_shards" : 1,
            "number_of_replicas" : 1,
            "analysis" : {
               "analyzer" : {
                  "str_search_analyzer_1" : {
                        "tokenizer" : "keyword",
                        "filter" : ["lowercase","asciifolding"]
                   },
                   "str_index_analyzer_2" : {
                        "tokenizer" : "standard",
                        "filter" : ["lowercase","asciifolding","suggestions_shingle","edgengram"]
                   },
                   "str_index_analyzer_1": {
                        "tokenizer": "keyword",
                        "filter" : ["lowercase","asciifolding","edgengram"]
                    },
                    "str_search_analyzer_2":{
                        "tokenizer": "standard",
                        "filter": ["lowercase","asciifolding","suggestions_shingle"]
                    }
               },
               "filter" : {
                   "suggestions_shingle": {
                        "type": "shingle",
                        "min_shingle_size": 2,
                        "max_shingle_size": 5
                    },
                    "edgengram" : {
                        "type" : "edgeNGram",
                        "min_gram" : 3,
                        "max_gram" : 30,
                        "side"     : "front"
                    }
                    
               }
            }
        }
    }
}'

 curl -XPUT 'localhost:9200/booksindex/booksidx/_mapping' -d'{ 
	"booksidx":{
		"_boost": {
			"name":"rating",
			"null_value":2.0
		},
		"properties":{
			"title":{
                type : "multi_field",
                fields: {
                    "title": {  
                        "type":"string", 
                        "search_analyzer" : "str_search_analyzer_1",
                        "index_analyzer":"str_index_analyzer_1"
                    },
                    "title_shingles": {
                        "type":"string", 
                        "search_analyzer" : "str_search_analyzer_2",
                        "index_analyzer":"str_index_analyzer_2"
                    }
			    }	
             },
             "author":{
                type : "multi_field",
                fields: {
                    "author": {
                        "type":"string", 
                        "search_analyzer" : "str_search_analyzer_1",
                        "index_analyzer":"str_index_analyzer_1"
                    },
                    "author_shingles": {
                        "type":"string", 
                        "search_analyzer" : "str_search_analyzer_2",
                        "index_analyzer":"str_index_analyzer_2"
                    } 
                }   
             },
            "isbn": {
                 type : "string",
                 index : "not_analyzed"
            },
            "category": {
                 type : "string",
                 index : "not_analyzed"
            },
            "rating": {
                 type : "integer"
            }
		}
	}
}'

curl -XPUT 'http://localhost:9200/_river/booksindex/_meta' -d '{ 
    "type": "mongodb", 
    "mongodb": { 
    "host": "localhost",
	"port" : 27017,
	"db": "books",
    "collection": "books"
    }, 
    "index": {
        "name": "booksindex", 
        "type": "booksidx" 
    }
}'



















