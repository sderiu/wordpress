# Wordpress

[Vapor 4](https://vapor.codes/) Provider for Wordpress REST API.

* Supports `POSTS/MEDIA`

### Installation (SPM)
 ```ruby
.package(url: "https://github.com/sderiu/wordpress.git", from: "1.0.0")
 ```

### Configuration

- Add in your configure.swift file.

```
import Wordpress

app.wordpress = .init(user: "YOUR_USERNAME",
                          password: "YOUR_PASSWORD",
                          domain: "https://example.com")
```

### Usage
#### Posts
The functions for posts management are accessible directly from Request 
###### Create
```ruby
func createPost(_ req: Request) throws -> EventLoopFuture<WordpressPost>{
  return req.wordpress.posts.create(title: "New Post",
                                    content: "A new post on my wordpress site",
                                    categories: [10], // See your categories id on Wordpress
                                    tags: [1,2,3] // see yout tags ids on Wordpress)
}
```

###### List
```ruby
func listPosts(_ req: Request) throws -> EventLoopFuture<[WordpressPost]>{
        return req.wordpress.posts.list()
}
```

###### Get
```ruby
func getPost(_ req: Request) throws -> EventLoopFuture<WordpressPost>{
        return req.wordpress.posts.get(id: 1)
}
```
###### Update
```ruby
func editPost(_ req: Request) throws -> EventLoopFuture<WordpressPost>{
        return req.wordpress.posts.update(id: 1, 
                                          title: "Updated Title")
}
```
###### Delete
```ruby
func deletePost(_ req: Request) throws -> EventLoopFuture<WordpressPost>{
        return req.wordpress.posts.delete(id: 1, force: false) //Use force true to delete permanently
}
```
#### Media
The function for posts management are accessible directly from Request 
###### Create
```ruby
func updloadMedia(_ req: Request) throws -> EventLoopFuture<WordpressMedia>{
  return req.wordpress.media.upload(file: myFile)
}
```

###### List
```ruby
func listMedia(_ req: Request) throws -> EventLoopFuture<[WordpressMedia]>{
        return req.wordpress.media.list()
}
```

###### Get
```ruby
func getMedia(_ req: Request) throws -> EventLoopFuture<WordpressMedia>{
        return req.wordpress.media.get(id: 1)
}
```
###### Delete
```ruby
func deleteMedia(_ req: Request) throws -> EventLoopFuture<DeletedMedia>{
        return req.wordpress.media.delete(id: 1, force: false) //Use force true to delete permanently
}
```

### Advanced Useage
a http client is accessible from requests to extend the implemented functions.

```ruby
func myCustomWPRequest(_ req: Request) throws -> EventLoopFuture<MyCustomReturnType>{
  return req.wordpress.client. ... // all availables http methods with wordpress basic auth header.
}
```
