extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var HTTP = HTTPClient.new()
	var url = "http://10.40.11.166/"
#	url = "http://posttestserver.com/post.php"
#	var RESPONSE = HTTP.connect("posttestserver.com",80)
	var RESPONSE = HTTP.connect("10.40.11.166",80)
	
	while(HTTP.get_status() == HTTPClient.STATUS_CONNECTING or HTTP.get_status() == HTTPClient.STATUS_RESOLVING):
		HTTP.poll()
		OS.delay_msec(300)
	assert(HTTP.get_status() == HTTPClient.STATUS_CONNECTED)
	var data = {"a": [3,1,2], "b" : ["ww", "ee"]}
	var QUERY = HTTP.query_string_from_dict(data)
	var HEADERS = ["User-Agent: Pirulo/1.0 (Godot)", "Content-Type: application/x-www-form-urlencoded", "Content-Length: " + str(QUERY.length())]
	RESPONSE = HTTP.request(HTTPClient.METHOD_POST, url, HEADERS, QUERY)
	assert(RESPONSE == OK)
	
	while (HTTP.get_status() == HTTPClient.STATUS_REQUESTING):
		HTTP.poll()
		OS.delay_msec(300)
#    # Make sure request finished
	assert(HTTP.get_status() == HTTPClient.STATUS_BODY or HTTP.get_status() == HTTPClient.STATUS_CONNECTED)
	var RB = RawArray()
	var CHUNK = 0
	var RESULT = 0
	print(str(HTTP.get_status() ))
	if HTTP.has_response():
        # Get response headers
		var headers = HTTP.get_response_headers_as_dictionary()
		while(HTTP.get_status() == HTTPClient.STATUS_BODY):
			HTTP.poll()
			CHUNK = HTTP.read_response_body_chunk()
			if(CHUNK.size() == 0):
				OS.delay_usec(100)
			else:
				RB = RB + CHUNK
	HTTP.close()
	RESULT = RB.get_string_from_ascii()
	# Do something with the response
	print(str(RESULT))