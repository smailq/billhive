(defproject billhive "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :dependencies [[org.clojure/clojure "1.5.1"]
                 [compojure "1.1.5"]
                 [de.ubercode.clostache/clostache "1.3.1"]]
  :plugins [[lein-ring "0.8.2"]]
  :ring {:handler billhive.handler/app}
  :profiles
  {:dev {:dependencies [[ring-mock "0.1.3"]]}})
