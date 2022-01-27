## We specify the base image we need for our go App
FROM golang:1.17

## We create an app directory in our image that will host our app source files
RUN mkdir /app

##We copy everithing in the root directory into our app directory
ADD . /app

## We specify that we now wish to execute any furthercommand inside our Go program
WORKDIR /app

#We run go build to compile the binary
RUN go build -o main .

## Our start  command whish kicks off our newly created binary executable
CMD ["/app/main"]
