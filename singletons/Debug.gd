extends Node

#
# Debug script to connect to a remote console for debugging on standalone VR headsets
#
# For Android, don't forget to enable "Internet" in permissions of the export dialog
#

# set to true to enable this script
var debugging = false

# define url of the nodejs server
const URL: String = "http://192.168.3.252:4096/debug"

# set headers for the HTTP request
const HEADERS: Array = ["User-Agent: VRHeadset", "Content-Type: application/json"]

# flag so we know when the HTTP Server is busy.  I'm sure theres a better way than this
var httpBusy = false

# array of queued messages yet to be sent
var messageQueue = []

# array of messages curently being sent to the server
var messagesCurrentlySending = []

# create a new HTTPRequest object
onready var HTTP: HTTPRequest = HTTPRequest.new()

func _ready():
	# check if debugging is on
	if debugging:
		# add a HTTP node
		self.add_child(HTTP)
		# create a signal to handle when the HTTPRequest is responded to
		var _result = HTTP.connect("request_completed",self,"_on_HTTP_request_completed")

# main loop
func _process(_delta):
	# check if there are any messages in the queue 
	if messageQueue.size() > 0:
	# is the HTTPRequest node still handling another request?
		if not httpBusy:
			# copy all the messages currently in the queue into a variable
			var messagesToBeSent = messageQueue
			# clear the current queue
			messageQueue = []
			# pass all the messages to the server 
			_send_to_server(messagesToBeSent)

func _print(originalMessage, node):
   # check if debugging is on
	if debugging:
	# builds a line that stores the timestamp and sending node too.  Handy!
		var message = get_timestamp()+" | "+str(node.name) + " : "+ str(originalMessage)
		# print out to console for PC debugging
		print(message)
		# add the message to the message queue
		messageQueue.append(message)

func _send_to_server(arrayToBeSent):
	# check if debugging is on
	if debugging:
		# set to true to prevent multiple sends at same time
		httpBusy = true
	# Put the message into a dictionary
	var data: Dictionary = {"messages":arrayToBeSent}
	# convert to JSON
	var jsonData = to_json(data)
	# send request with headers and JSON data
	var _result = HTTP.request(URL, HEADERS, false, HTTPClient.METHOD_POST, jsonData)

func _on_HTTP_request_completed(_result, _response_code, _headers, _body):
	httpBusy = false

func get_timestamp():
	var time = OS.get_datetime() 
	var timeStamp: String = "%02d/%02d/%02d %02d:%02d:%02d" % [time.day, time.month, time.year,time.hour, time.minute, time.second]
	return timeStamp
