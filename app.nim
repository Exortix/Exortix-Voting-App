import jester
import strutils
import json
import views
import httpcore
import tables
import misc
import strformat
import browsers

type
    Choice = ref object
        value: string
        count: int32

type
    Post = object
        post_id: string
        title: string
        topic: string
        choices: seq[Choice]
        author: string

type
    User =  object
        username: string
        email: string
        password: string


var posts = parseJson readFile("json/posts.json")
var postsSeq: seq[Post];
for post in posts:
    postsSeq.add(to(post, Post))

var users = parseJson readFile("json/users.json")
var usersSeq: seq[User];
for user in users:
    usersSeq.add(to(user, User))

openDefaultBrowser("http://127.0.0.1:5000/")

routes:
    get "/":
        posts = parseJson readFile("json/posts.json")
        users = parseJson readFile("json/users.json")
        var content = newJObject()
        content["page_title"] = newJString("Exortix Voting")
        content["logged_in"] = newJBool(checkLoggedIn(request.cookies))
        content["posts"] = posts
        if(checkLoggedIn(request.cookies)):
            content["username"] = newJString(request.cookies["username"])
        resp showPage("index", content, @[])
    get "/register":
        var content = newJObject()
        content["page_title"] = newJString("Register")
        content["logged_in"] = newJBool(checkLoggedIn(request.cookies))
        resp showPage("register", content, @[])
    post "/register":
        users = parseJson readFile("json/users.json")
        usersSeq = @[]
        for user in users:
            usersSeq.add(to(user, User))
        var my_user: User;
        var validUser: bool = true;
        for user in usersSeq:
            if toLowerAscii(user.username) == toLowerAscii(request.params["username"]) or toLowerAscii(user.email) == toLowerAscii(request.params["email"]) or not passwordValidator(request.params["password"]):
                validUser = false
        if validUser:
            my_user = User(username: request.params["username"], email: request.params["email"], password: request.params["password"]);
            usersSeq.add(my_user)
            setCookie("username", $(my_user.username), daysForward(5))
            writeFile("json/users.json", $(%usersSeq).pretty)
            usersSeq = @[]
            users = parseJson readFile("json/users.json")
            for user in users:
                usersSeq.add(to(user, User))
            redirect "/"
        else:
            resp("<h1><a href='/register'>Please Try Again</h1>")
    get "/login":
        var content = newJObject()
        content["page_title"] = newJString("Login")
        content["logged_in"] = newJBool(checkLoggedIn(request.cookies))
        resp showPage("login", content, @[])
    post "/login":
        users = parseJson readFile("json/users.json")
        usersSeq = @[]
        for user in users:
            usersSeq.add(to(user, User))
        var my_user: User;
        var userValid: bool = false;
        for user in usersSeq:
            if (toLowerAscii(user.username) == toLowerAscii(request.params["username-email"]) or toLowerAscii(user.email) == toLowerAscii(request.params["username-email"])) and user.password == request.params["password"]:
                my_user = user
                userValid = true
                break
        if userValid:
            setCookie("username", $(my_user.username), daysForward(5))
            redirect "/"
        else:
            resp("<h1><a href='/login'>Please Try Again</h1>")

    get "/vote/@post_id":
        var content = newJObject()
        content["logged_in"] = newJBool(checkLoggedIn(request.cookies))
        for post in posts:
            if post["post_id"].getStr() == @"post_id":
                content["post"] = post
                content["page_title"] = content["post"]["title"];
                break
        resp showPage("vote", content, @[])
    post "/vote/@post_id":
        if not(checkLoggedIn(request.cookies)):
            redirect "/request_login"
            break
        for post in postsSeq:
            if post.post_id == request.params["post_id"]:
                for choice in post.choices:
                    if request.params.hasKey($choice.value):
                        if request.params[$choice.value] == "on":
                            choice.count += 1
                break;
        writeFile("json/posts.json", $(%postsSeq).pretty)
        postsSeq = @[]
        posts = parseJson readFile("json/posts.json")
        for post in posts:
            postsSeq.add(to(post, Post))
        redirect "/vote/" & @"post_id"
    get "/request_login":
        if (checkLoggedIn(request.cookies)):
            redirect "/login"
        else:
            var content = newJObject()            
            content["page_title"] = newJString("Please Login")
            resp showPage("request_login", content, @[])
    get "/new":
        var content = newJObject()
        content["page_title"] = newJString("Create Post")
        content["logged_in"] = newJBool(checkLoggedIn(request.cookies))
        content["username"] = newJString(request.cookies["username"])
        resp showPage("create_post", content, @[])
    post "/new":
        posts = parseJson readFile("json/posts.json")
        postsSeq = @[]
        for post in posts:
            postsSeq.add(to(post, Post))
        var newPost: Post;
        newPost.post_id = fmt("{(parseInt(postsSeq[^1].post_id) + 1):04}");
        newPost.topic = request.params["topic"]
        newPost.title = request.params["title"]
        newPost.author = request.cookies["username"].toLowerAscii()
        newPost.choices =  @[]
        var count:int32 = 0
        while true:
            if (request.params.hasKey("choice" & $count)):
                var newChoice: Choice;
                newChoice = Choice(value : request.params["choice" & $count],count : 0) 
                newPost.choices.add(newChoice)
                count = count + 1
            else:
                break
        if(count >= 2):
            postsSeq.add(newPost)
            writeFile("json/posts.json", $(%postsSeq).pretty)
            posts = parseJson readFile("json/posts.json")
            postsSeq = @[]
            for post in posts:
                postsSeq.add(to(post, Post))
        redirect "/"
    get "/logout":
        setCookie("username", "")
        redirect "/"