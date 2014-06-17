# Define custom server-side HTTP routes for lineman's development server
#   These might be as simple as stubbing a little JSON to
#   facilitate development of code that interacts with an HTTP service
#   (presumably, mirroring one that will be reachable in a live environment).
#
# It's important to remember that any custom endpoints defined here
#   will only be available in development, as lineman only builds
#   static assets, it can't run server-side code.
#
# This file can be very useful for rapid prototyping or even organically
#   defining a spec based on the needs of the client code that emerge.
#
#
module.Posts = [
  {
    id: 1
    title: "This is Post #1"
    body: "This is some text I've put here for you to read."
    user_id: 1
    created_at: new Date(2014, 1, 1)
  },
  {
    id: 2
    title: "This is Post #2"
    body: "This is my great post about something. I hope you enjoy it."
    user_id: 1
    created_at: new Date(2014, 0, 27)
  }
]

module.Products = [
  { 
    id: 1
    name: "Product #1"
    description: "A product"
    category: "Category #1" 
    price: 100
    created_at: new Date(2014, 5, 1)
  },
  { 
    id: 2
    name: "Product #2"
    description: "A product"
    category: "Category #1" 
    price: 110
    created_at: new Date(2014, 5, 1)
  },
  { 
    id: 3
    name: "Product #3"
    description: "A product"
    category: "Category #2" 
    price: 210
    created_at: new Date(2014, 5, 1)
  },
  { 
    id: 4
    name: "Product #4"
    description: "A product"
    category: "Category #3" 
    price: 202
    created_at: new Date(2014, 5, 1)
  }
]

module.Orders = [
]

module.Users = [
  {
    id: 1
    name: "Homer Simpson"
    username: "homer"
  }
]

module.DB =
  find: (table, id, col = 'id') ->
    obj = null
    for p in module[table]
      if p[col] is id
        obj = p
    return obj

  create: (table, obj) ->
    date = new Date()
    obj.id = date.getTime()
    obj.created_at = date
    module[table].push obj
    return obj

  destroy: (table, id, col ='id') ->
    obj = this.find(table, id, col)
    ind = module[table].indexOf(obj)
    module[table].splice(ind, 1)
    return obj

module.exports =
  drawRoutes: (app) ->
    app.get '/api/posts', (req, res) ->
      res.json(module.Posts)

    app.get '/api/posts/:id', (req, res) ->
      post = module.DB.find("Posts", parseInt(req.params.id))
      if post?
        res.json(post)

    app.put '/api/posts/:id', (req, res) ->
      post = module.DB.find("Posts", parseInt(req.params.id))
      for key, value of req.body
        post[key] = value
      console?.log "post", JSON.stringify(post)
      if post?
        res.json(post)
      else
        res.json(404, {error: "Post not found."})

    app.delete '/api/posts/:id', (req, res) ->
      obj = module.DB.destroy("Posts", parseInt(req.params.id))
      res.json(obj)

    app.post '/api/posts', (req, res) ->
      res.json(module.DB.create("Posts", req.body))

    app.get '/api/users/auth/:username', (req, res) ->
      user = module.DB.find("Users", req.params.username, 'username')
      if user?
        res.json(user)
      else
        res.json(401, {error: "User not found!"})

    app.get '/api/users/:id', (req, res) ->
      user = module.DB.find("Users", parseInt(req.params.id))
      if user?
        res.json(user)

    app.get '/api/products', (req, res) ->
      res.json(module.Products)

    app.get '/api/products/:id', (req, res) ->
      product = module.DB.find("Products", parseInt(req.params.id))
      if product?
        res.json(product)

    app.put '/api/products/:id', (req, res) ->
      product = module.DB.find("Products", parseInt(req.params.id))
      for key, value of req.body
        product[key] = value

      console?.log "product", JSON.stringify(product)
      if product?
        res.json(product)
      else
        res.json(404, {error: "Product not found."})

    app.delete '/api/products/:id', (req, res) ->
      obj = module.DB.destroy("Products", parseInt(req.params.id))
      res.json(obj)

    app.post '/api/products', (req, res) ->
      res.json(module.DB.create("Products", req.body))

    app.get '/api/orders', (req, res) ->
      res.json(module.Orders)

    app.get '/api/orders/:id', (req, res) ->
      order = module.DB.find("Orders", parseInt(req.params.id))
      if product?
        res.json(order)

    app.put '/api/orders/:id', (req, res) ->
      order = module.DB.find("Orders", parseInt(req.params.id))
      for key, value of req.body
        order[key] = value

      console?.log "order", JSON.stringify(order)
      if order?
        res.json(order)
      else
        res.json(404, {error: "Order not found."})

    app.delete '/api/orders/:id', (req, res) ->
      obj = module.DB.destroy("Orders", parseInt(req.params.id))
      res.json(obj)

    app.post '/api/orders', (req, res) ->
      res.json(module.DB.create("Orders", req.body))
