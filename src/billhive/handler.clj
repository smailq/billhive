(ns billhive.handler
  (:use compojure.core clostache.parser)
  (:require [compojure.handler :as handler]
            [compojure.route :as route]))


(defn show-landing-page [req] ;; ordinary clojure function, accepts a request map, returns a response map
  ;; return landing page's html string. possible template library:
  ;; mustache (https://github.com/shenfeng/mustache.clj, https://github.com/fhd/clostache...)
  ;; enlive (https://github.com/cgrand/enlive)
  ;; hiccup(https://github.com/weavejester/hiccup)
  {:status  200
   :headers {"Content-Type" "text/html"}
   :body    (render (slurp "templates/landing.html") {
                      :total_due "1230"})
  })


(defroutes app-routes
  (GET "/" [] show-landing-page)
  (route/resources "/")
  (route/not-found "Not Found"))

(def app
  (handler/site app-routes))
