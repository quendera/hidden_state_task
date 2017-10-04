extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var HTTP = HTTPClient.new()
	var url = "http://10.40.11.166/index.php"
	var RESPONSE = HTTP.connect("10.40.11.166",80)
	
	while(HTTP.get_status() == HTTPClient.STATUS_CONNECTING or HTTP.get_status() == HTTPClient.STATUS_RESOLVING):
		HTTP.poll()
		OS.delay_msec(300)
	assert(HTTP.get_status() == HTTPClient.STATUS_CONNECTED)
	var r=RawArray()
	r.append("----WebKitFormBoundaryePkpFF7tjBAqx29L\n")
	r.append("Content-Disposition: form-data; name=\"imgFile\"; filename=\"cube.png\"\n")
	r.append("Content-Type: image/png\n")
	r.append("\n")
	var file = File.new()
	file.open("user://cube.png", file.READ) #Either have cube.png in appdata folder (see README)
	var content = file.get_buffer(file.get_len())
	file.close()
	r.append_array(content)
	r.append("----WebKitFormBoundaryePkpFF7tjBAqx29L")
	var headers=[
		"Content-Type: multipart/form-data,  boundary=----WebKitFormBoundaryePkpFF7tjBAqx29L",
		"Content-Length: "+String(content.size())
	]
	RESPONSE = HTTP.request_raw(HTTPClient.METHOD_POST, url, headers, r)
	assert(RESPONSE == OK)
	
	while (HTTP.get_status() == HTTPClient.STATUS_REQUESTING):
		HTTP.poll()
		OS.delay_msec(300)
	#    # Make sure request finished
	assert(HTTP.get_status() == HTTPClient.STATUS_BODY or HTTP.get_status() == HTTPClient.STATUS_CONNECTED)
	print("got here")
	print(str(RESPONSE))
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
	print(str(RESULT))