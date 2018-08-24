# DPA

My DPA BASH scripts.

All my RESTful API testings using 'Client for URLs' (or 'cURL' / 'curl')

### REST API requests using cURL

Client for URLs (or cURL) is a software project comprised of two development efforts - cURL and libcurl.

libcurl is a free, client-side URL transfer library with support for a wide range of protocols. libcurl is portable, thread-safe, feature rich, and well supported on virtually any platform. It is probably the most popular C-based, multi-platform file transfer library in use.

cURL is a command-line tool for getting or sending files using URL syntax. Since cURL uses libcurl, it supports the same range of common Internet protocols that libcurl does.

### Why curl?

One of the advantages of REST APIs is that you can use almost any programming language to call the endpoint. The endpoint is simply a resource located on a web server at a specific path.

Each programming language has a different way of making web calls. Rather than exhausting your energies trying to show how to make web calls in Java, Python, C++, JavaScript, Ruby, and so on, you can just show the call using curl.

curl provides a generic, language agnostic way to demonstrate HTTP requests and responses. Users can see the format of the request, including any headers and other parameters. Your users can translate this into the specific format for the language they’re using.

### Common curl commands related to REST

curl has a lot of possible commands, but the following are the most common when working with REST APIs.

#### -i or --include	

Includes the response headers in the response.	

curl -i http://www.example.com

#### -d or --data	

Includes data to post to the URL. The data needs to be url encoded. Data can also be passed in the request body.	

curl -d "data-to-post" http://www.example.com

#### -H or --header	

Submits the request header to the resource. This is very common with REST API requests because the authorization is usually included in the header.	

curl -H "key:12345" http://www.example.com

#### -X POST	

Specifies the HTTP method to use with the request (in this example, POST). If you use -d in the request, curl automatically specifies a POST method. With GET requests, including the HTTP method is optional, because GET is the default method used.	

curl -X POST -d "resource-to-update" http://www.example.com

Methods :

POST	    - Create a resource

GET	      - Read a resource

PUT	      - Update a resource

DELETE	  - Delete a resource

#### @filename	/  -T, --upload-file filename

Loads content from a file.	

curl -X POST -d @mypet.json http://www.example.com

curl -X POST -T filename http://www.example.com

curl -X POST -T "{file1,file2}" http://www.example.com
