# LineServer

## Requirements
Docker

## Questions
### How does your system work? (if not addressed in comments in source)
At application start (lib/line_server/application.ex) the file to be served is read to create the line index 
and save in ETS (http://erlang.org/doc/man/ets.html). This is done by using the IndexCreator module and IndexRepository module. After this, lines can be server through the REST API.

The index saves for each the number of bytes in the file up till the end of that line. In order to get the start and end of a line (in byte offset) retrieve the index for that line and the previous one.

Lines are served in the `GET /lines/:line_number` endpoint.
If the submitted :line_number is out of bounds for that file a 415 error code is returned.
When a request comes in, a lookup is performed in the index to retrieve the necessary information to retrieve that line from the line. Afterwards the file is read at a specific byte offset where the line starts for the amount of bytes of that line. The request returns with 200 code and the line.

### What documentation, websites, papers, etc did you consult in doing this assignment?
https://hexdocs.pm/elixir/File.html
http://erlang.org/doc/man/file.html#type-mode
http://erlang.org/doc/man/file.html#pread-2
http://erlang.org/doc/man/ets.html
https://gist.github.com/brienw/85db445a0c3976d323b859b1cdccef9a
http://engineering.avvo.com/articles/using-env-with-elixir-and-docker.html
https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
https://www.digitalocean.com/community/tutorials/how-to-share-data-between-the-docker-container-and-the-host

### What third-party libraries or other tools does the system use? How did you choose each library or framework you used?
- https://phoenixframework.org - the go-to web framework for elixir projects
- https://github.com/bitwalker/distillery - utility library to help with deploys and releases
- https://github.com/rockneurotiko/config_tuples - mainly to help with having the FILE_PATH as a runtime environment variable
- Docker - to avoid the "works on my machine" issue when sharing the project and simplify running it on different computers, no need to install all the elixir stuff.


### How long did you spend on this exercise? If you had unlimited more time to spend on this, how would you spend it and how would you prioritize each item?
Around 7 hours I believe, not sure.
I would run some performance testing covering different file sizes and number of users to observe how the system would behave.
Off of those results see if the solution needs adjustments.
I would also consider adding a cache to avoid reading from disk on every request. Although, the effectiveness of the cache is highly dependant on the traffic patterns and the format of the file being served (e.g. number of lines and size of each line).

### How will your system perform with a 1 GB file? a 10 GB file? a 100 GB file?
For 1 and 10GB I believe it would perform well, but 100GB raises some questions.
At the moment the one case I can think of would be the size of the index being
too big to fit into memory. Lets say were working with a server
with 8GB in memory, a +100GB file with a small amount of characters on each line could
surpass that in index size. Also, constantly reading lines that fill up memory would absolutely cause slowness. Apart from that, not having a caching solution and always reading from disk does influence performance.

### How will your system perform with 100 users? 10000 users? 1000000 users?
If I'm not mistaken I believe the system would scale well horizontally. To with the increase in req/s we could add more servers, each server with a copy of the file to serve.

### If you were to critique your code, what would you have to say about it?
I think the IndexCreator needs some improvement, could make it easier to read and a simpler implementation.
I'm not very used to using the `{:ok}` and `{:err}` for contracts. It is commonly used pattern in the elixir community and something I wanted to try out. I think I would need to use them in a larger project to understand the best cases for it.