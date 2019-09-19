package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

func IndexHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "hello world")
	//fmt.Printf("%+v",r)
	//readCloser, _ := r.GetBody()
	bytes, e := ioutil.ReadAll(r.Body)
	fmt.Println(string(bytes), e)
	panic("test")
}

func main() {
	http.HandleFunc("/", IndexHandler)
	http.ListenAndServe(":3333", nil)
}
