(require '[org.httpkit.server :as http])

(defn step [n]
  (if (even? n) (quot n 2) (inc (* 3 n))))

(defn handler [{:keys [query-string]}]
  (let [n (some->> query-string (re-find #"(?:^|&)n=(\d+)") second parse-long)]
    (if (and n (pos? n))
      {:status 200 :headers {"Content-Type" "text/plain"} :body (str (step n))}
      {:status 400 :headers {"Content-Type" "text/plain"} :body "need ?n=<positive integer>"})))

(http/run-server handler {:ip "0.0.0.0" :port 8000})
(println "Clojure (babashka) is listening on :8000")
@(promise)
