package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"path"
	"strconv"

	"github.com/gorilla/mux"

	_ "github.com/go-sql-driver/mysql"
)

/*
	TAG
*/
type Recipe struct {
	Name  string `json:"name"`
	Time  string `json:"time"`
	HowTo string `json:"howto"`
}
type List struct {
	Ingredient string `json:"ingredient"`
	Quantity   int    `json:"quantity"`
}
type Ingredient struct {
	Name     string `json:"name"`
	Calorie  int    `json:"calorie"`
	Type     string `json:"type"`
	Quantity string `json:"quantity"`
}
type RecipeAndIngredients struct {
	Recipe         string `json:"recepie_name"`
	NameIngredient string `json:"ingredients_name"`
	Quantity       int    `json:"needed_quantity"`
}
type Days struct {
	Day  string `json:"day"`
	Name string `json:"recepie_name"`
}

var ingredients []Ingredient
var recepies []Recipe
var notes []List
var recipesandingredients []RecipeAndIngredients
var days []Days

// Serve index file
func homePage(w http.ResponseWriter, r *http.Request) {
	//fmt.Fprintf(w, "Welcome to the HomePage !")
	p := path.Dir("./GoRestServer/index.html")
	w.Header().Set("Content-type", "text/html")
	http.ServeFile(w, r, p)

	fmt.Println("Endpoint Hit: homepage")
}

func createRecipe(w http.ResponseWriter, r *http.Request) {
	var recipe Recipe
	recepies = nil
	reqBody, _ := ioutil.ReadAll(r.Body)
	json.Unmarshal(reqBody, &recipe)
	db, err := sql.Open("mysql", "root:hean2000@tcp(recipeapp:3306)/godb")
	if err != nil {
		panic(err.Error())
	}
	defer db.Close()
	//Insertion code
	insert, err := db.Query("INSERT INTO `godb`.`recepie` (`name`, `time`, `howto`) VALUES ('" + recipe.Name + "', '" + recipe.Time + "', '" + recipe.HowTo + "');")
	if err != nil {
		panic(err.Error())
	}
	defer insert.Close()
}
func createRecipeWithIngredient(w http.ResponseWriter, r *http.Request) {
	var recipeWithIngredient RecipeAndIngredients
	recepies = nil
	recipesandingredients = nil
	reqBody, _ := ioutil.ReadAll(r.Body)
	json.Unmarshal(reqBody, &recipeWithIngredient)
	db, err := sql.Open("mysql", "root:hean2000@tcp(recipeapp:3306)/godb")
	if err != nil {
		panic(err.Error())
	}
	defer db.Close()

	//Insertion code
	insert, err := db.Query("INSERT INTO `godb`.`recepie_has_ingredients` (`recepie_name`, `ingredients_name`, `needed_quantity`) VALUES ('" + recipeWithIngredient.Recipe + "', '" + recipeWithIngredient.NameIngredient + "', '" + strconv.Itoa(recipeWithIngredient.Quantity) + "');")
	if err != nil {
		panic(err.Error())
	}
	defer insert.Close()
}

func DeleteRecipe(w http.ResponseWriter, r *http.Request) {
	db, err := sql.Open("mysql", "root:hean2000@tcp(recipeapp:3306)/godb")
	if err != nil {
		panic(err.Error())
	}
	//emp := r.URL.Query().Get("id")
	vars := mux.Vars(r)
	name := vars["id"]
	delform, err := db.Query("DELETE FROM `godb`.`recepie` WHERE (`name` = '" + name + "');")
	if err != nil {
		panic(err.Error())
	}
	//delform.Exec(emp)
	defer delform.Close()
	fmt.Println("Delete" + name)
	defer db.Close()
}
func UpdateRecipe(w http.ResponseWriter, r *http.Request) {
	var recipe Recipe
	recepies = nil
	reqBody, _ := ioutil.ReadAll(r.Body)
	json.Unmarshal(reqBody, &recipe)
	db, err := sql.Open("mysql", "root:hean2000@tcp(recipeapp:3306)/godb")
	if err != nil {
		panic(err.Error())
	}
	defer db.Close()
	//Get ID passed as parameter
	vars := mux.Vars(r)
	id := vars["id"]
	//Update Code
	upform, err := db.Query("UPDATE `godb`.`recepie` SET `name` = '" + recipe.Name + "', `time` = '" + recipe.Time + "', `howto`= '" + recipe.HowTo + "' WHERE (`name` = '" + id + "');")
	if err != nil {
		panic(err.Error())
	}
	fmt.Println("Updated" + id)
	defer upform.Close()
}
func handleRequests() {
	//Create a new instance of MuxRouter
	myRouter := mux.NewRouter().StrictSlash(true)
	//Use MuxRouter instead of http.handlefunc
	myRouter.HandleFunc("/", homePage)
	myRouter.HandleFunc("/recepies", returnAllRecepies)
	myRouter.HandleFunc("/fullrecipe/{id}", returnRecipeAndIngredient).Methods("POST")
	myRouter.HandleFunc("/getingredient/{name}", GetIngredientById).Methods("POST")
	myRouter.HandleFunc("/ingredients", returnAllIngredients)
	myRouter.HandleFunc("/updaterecipe/{id}", UpdateRecipe).Methods("PUT")
	myRouter.HandleFunc("/newrecipe", createRecipe).Methods("POST")
	myRouter.HandleFunc("/newrecipewithingredients", createRecipeWithIngredient).Methods("POST")
	myRouter.HandleFunc("/deleterecipe/{id}", DeleteRecipe).Methods("DELETE")
	//myRouter.HandleFunc("/notes/{name}", returnChecklist).Methods("PUT")
	myRouter.HandleFunc("/tobuy", returnIngredientsToBuy)
	myRouter.HandleFunc("/week", returnRecipesOfWeeks)
	myRouter.HandleFunc("/week/{day}", updateRecipeForADay).Methods("PUT")
	// Finally, instead of passing a nil, we wanty to pass our newly created router as second argument
	log.Fatal(http.ListenAndServe(":10000", myRouter))
}

//Lets Update a recipe for a day
func updateRecipeForADay(w http.ResponseWriter, r *http.Request) {
	var day Days
	days = nil
	reqBody, _ := ioutil.ReadAll(r.Body)
	json.Unmarshal(reqBody, &day)
	db, err := sql.Open("mysql", "root:hean2000@tcp(recipeapp:3306)/godb")
	if err != nil {
		panic(err.Error())
	}
	defer db.Close()
	//Get day passed as parameter
	vars := mux.Vars(r)
	dayOfWeek := vars["day"]
	//recipeForThisDay := vars["recipe"]
	// Update the recipe of a day. Old ingredients of the old recipe will automaticaly deleted from the database according to a trigger.
	recipeOfTheDay, err := db.Query("UPDATE `godb`.`recipesofweek` SET `recepie_name` = '" + day.Name + "' WHERE (`day` = '" + dayOfWeek + "');")
	if err != nil {
		panic(err.Error())
	}
	fmt.Println("Updated " + dayOfWeek)
	defer recipeOfTheDay.Close()
}

func returnAllRecepies(w http.ResponseWriter, r *http.Request) {
	db, err := sql.Open("mysql", "root:hean2000@tcp(recipeapp:3306)/godb")
	//Execute the query to get all recipies names
	results, err := db.Query("SELECT * FROM godb.recepie")
	recepies = nil
	if err != nil {
		panic(err.Error())
	}
	for results.Next() {
		var tag Recipe

		//for each row, scan the result into our tag struct
		err = results.Scan(&tag.Name, &tag.Time, &tag.HowTo)
		if err != nil {
			panic(err.Error())
		}

		//then, print out the tags
		log.Printf(tag.Name)
		recepies = append(recepies, tag)
	}
	json.NewEncoder(w).Encode(recepies)
	fmt.Println("Endpoint Hit: returnAllRecepies")
}

//Return recipes to cook during the week. Only one by day
func returnRecipesOfWeeks(w http.ResponseWriter, r *http.Request) {
	db, err := sql.Open("mysql", "root:hean2000@tcp(recipeapp:3306)/godb")
	//Execute the query to get all recipies names
	results, err := db.Query("SELECT * FROM godb.recipesofweek")
	days = nil
	if err != nil {
		panic(err.Error())
	}
	for results.Next() {
		var day Days

		//for each row, scan the result into our tag struct
		err = results.Scan(&day.Day, &day.Name)
		if err != nil {
			panic(err.Error())
		}

		//then, print out tags
		days = append(days, day)
	}
	json.NewEncoder(w).Encode(days)
	fmt.Println("Endpoint Hit: Retour du Menu")
}

//Show ingredients names and quantity when getting a recipe name
func returnRecipeAndIngredient(w http.ResponseWriter, r *http.Request) {
	db, err := sql.Open("mysql", "root:hean2000@tcp(recipeapp:3306)/godb")
	//Execute the query to get all recipies names
	vars := mux.Vars(r)
	name := vars["id"]

	results, err := db.Query("SELECT * FROM godb.recepie_has_ingredients WHERE recepie_name = " + strconv.Quote(name) + " ;")
	recipesandingredients = nil
	if err != nil {
		panic(err.Error())
	}
	for results.Next() {
		var tag RecipeAndIngredients

		//for each row, scan the result into our tag struct
		err = results.Scan(&tag.Recipe, &tag.NameIngredient, &tag.Quantity)
		if err != nil {
			panic(err.Error())
		}
		//then, print out the tags
		recipesandingredients = append(recipesandingredients, tag)
	}
	json.NewEncoder(w).Encode(recipesandingredients)
	fmt.Println("Endpoint Hit: returnRecepiesAndIngredients")
}

//Get an ingredient's carateristic by name entry
func GetIngredientById(w http.ResponseWriter, r *http.Request) {
	db, err := sql.Open("mysql", "root:hean2000@tcp(recipeapp:3306)/godb")
	//Execute the query to get all recipies names
	vars := mux.Vars(r)
	name := vars["name"]
	results, err := db.Query("SELECT * FROM godb.ingredients WHERE name = " + strconv.Quote(name) + ";")
	ingredients = nil
	if err != nil {
		panic(err.Error())
	}
	for results.Next() {
		var tag Ingredient

		//for each row, scan the result into our tag struct
		err = results.Scan(&tag.Name, &tag.Calorie, &tag.Type, &tag.Quantity)
		if err != nil {
			panic(err.Error())
		}

		//then, print out the tags
		ingredients = append(ingredients, tag)
	}
	json.NewEncoder(w).Encode(ingredients)
	fmt.Println("Endpoint Hit: GetIngredientsById")
}

//Get a list of all ingredients
func returnAllIngredients(w http.ResponseWriter, r *http.Request) {
	db, err := sql.Open("mysql", "root:hean2000@tcp(recipeapp:3306)/godb")
	//Execute the query to get all recipies names
	results, err := db.Query("SELECT * FROM godb.ingredients")
	ingredients = nil
	if err != nil {
		panic(err.Error())
	}
	for results.Next() {
		var ingredient Ingredient

		//for each row, scan the result into our tag struct
		err = results.Scan(&ingredient.Name, &ingredient.Calorie, &ingredient.Type, &ingredient.Quantity)
		if err != nil {
			panic(err.Error())
		}
		ingredients = append(ingredients, ingredient)
	}
	json.NewEncoder(w).Encode(ingredients)
	fmt.Println("Endpoint Hit: returnAllIngredients")
}

// Return Ingredients list to buy
func returnIngredientsToBuy(w http.ResponseWriter, r *http.Request) {
	db, err := sql.Open("mysql", "root:hean2000@tcp(recipeapp:3306)/godb")
	//Execute the query to get all recipies names
	results, err := db.Query("SELECT * FROM godb.list")
	notes = nil
	if err != nil {
		panic(err.Error())
	}
	for results.Next() {
		var ingredient List

		//for each row, scan the result into our tag struct
		err = results.Scan(&ingredient.Ingredient, &ingredient.Quantity)
		if err != nil {
			panic(err.Error())
		}
		notes = append(notes, ingredient)
	}
	json.NewEncoder(w).Encode(notes)
	fmt.Println("return Ingredient to Buy")
}

func returnChecklist(w http.ResponseWriter, r *http.Request) {
	db, err := sql.Open("mysql", "root:hean2000@tcp(recipeapp:3306)/godb")
	vars := mux.Vars(r)
	name := vars["name"]
	//Execute the query to get all recipies names
	results, err := db.Query("SELECT ingredients_name FROM godb.recepie_has_ingredients WHERE recepie_name = " + strconv.Quote(name) + ";")
	notes = nil
	if err != nil {
		panic(err.Error())
	}
	for results.Next() {
		var tag List

		//for each row, scan the result into our tag struct
		err = results.Scan(&tag.Ingredient)
		if err != nil {
			panic(err.Error())
		}

		//then, print out the tags
		notes = append(notes, tag)
	}
	json.NewEncoder(w).Encode(notes)
	fmt.Println("Endpoint Hit: returnAllNotes")
}

func main() {

	fmt.Println("Go & MySQL App")
	//lets open our database godb started on my local machine
	db, err := sql.Open("mysql", "root:hean2000@tcp(recipeapp:3306)/godb")

	//If an error occur, launch
	if err != nil {
		panic(err.Error())
	}
	//defer the close till after the main function has finished
	//executing
	defer db.Close()
	/*
		//perfomr a db.query insert
		insert, err := db.Query("INSERT INTO `godb`.`recepie` (`name`, `time`) VALUES ('Lasagne', '05:02')")

		if err != nil {
			panic(err.Error())
		}
		defer insert.Close()
	*/

	handleRequests()
}
