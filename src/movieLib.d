import std.stdio;
import std.file;
import std.conv;
import std.string;
import std.algorithm;
import std.container; 
import std.regex;

Movie[] movieList;

void main()
{
	File splashDisp = File("splash", "r");
	
	while(!splashDisp.eof())
	{
		string s 	= chomp(splashDisp.readln());
		writeln(s);
	}
	splashDisp.close();
	writeln("---------------------------------------------");
	//to read data from previous session
	File fileIn = File("moviedata.txt", "r");
	
	while(!fileIn.eof())
	{
		string movtitle 	= chomp(fileIn.readln());
		string movdirector  = chomp(fileIn.readln());
		string yearStr      = chomp(fileIn.readln());
		string durationStr  = chomp(fileIn.readln());
		string genre 		= chomp(fileIn.readln());
		string ratingStr 	= chomp(fileIn.readln());
		string ratingCountStr  = chomp(fileIn.readln());

		uint year 		= to!uint(yearStr);
		uint dur 		= to!uint(durationStr);
		float rating 	= to!float(ratingStr);
		int ratingCount = to!int(ratingCountStr);


		Movie movie = new Movie(movtitle, movdirector, year, dur, genre, rating, ratingCount);
		movieList ~= movie; //adds movie to the list
	}
	fileIn.close();

	string userChoice;
	string userInput;
	auto reg = regex("^[1-7]$"); //regex for input validation

	do{
			writeln("What would you like to do?\n");
			writeln("1) Display Full List of Movies\n2) Search for a movie\n3) Add a new movie\n4) Leave a review\n5) Update a movie's information\n6) Delete a movie\n7) Exit"); 
						
				write("Enter Choice: ");
				readf("%s\n", &userChoice);

				if(!(matchFirst(userChoice, reg)))
				{
					writeln("\nInvalid Choice!"); 
				}		

		}while(!(matchFirst(userChoice, reg))); 

	do{
		switch(userChoice){
			case("1"):{
				writeln("\n");
				displayMovieList();
			}
			break;
			case("2"):{
				writeln("\nSearch by:\n");
				writeln("1) By title\n2) By genre");

				readf("%s\n", &userChoice);

				writeln("\nEnter what you want to search for: ");
				readf("%s\n", &userInput);
				userInput = strip(userInput); 

				switch(userChoice){
					case("1"):{
						search(userInput.toLower(),1);
					}
					break;
					case("2"): search(userInput.toLower(),2);
					default: break; 
				}
			}
			break; 

			case("3"):{
				addNewMovie(); 
			}
			break;

			case("4"):{
				addNewReview();
			}
			break;

			case("5"):{
				writeln("\nEnter what you want to search for: ");
				readf("%s\n", &userInput);
				userInput = strip(userInput); 

				editMovie(userInput.toLower()); 
			}
			break;

			case("6"):{
				writeln("\nEnter the title you want to delete: ");
				readf("%s\n", &userInput);
				userInput = strip(userInput);
				deleteMovie(userInput.toLower()); 

			}

			break;

			case("7"): userChoice = "7"; 

			default: break; 
		}//end of switch

		
		if(userChoice == "7")
			break; 

		do{
			writeln("\nWhat would you like to do next? ");
			writeln("1) Display Full List of Movies\n2) Search for a movie\n3) Add a new movie\n4) Leave a review\n5) Update a movie's information\n6) Delete a movie\n7) Exit"); 
			write("Enter Choice: ");
			readf("%s\n", &userChoice); 

			if(!(matchFirst(userChoice, reg))){
				writeln("That input is invalid."); 
			}

		}while(!(matchFirst(userChoice, reg))); 

	}while(true);

	

	//to write data to new file after current session (for persistence)
	File fileOut = File("moviedata.txt", "w");//TODO - probably rewrite to same file
	Movie temp;
	for(int i; i < movieList.length; i++)
	{

		temp = movieList[i];
				
		fileOut.writeln(temp.getTitle());
		fileOut.writeln(temp.getDirector());
		fileOut.writeln(temp.getYearReleased());
		fileOut.writeln(temp.getDuration());
		fileOut.writeln(temp.getGenre());
		fileOut.writeln(temp.getRating());
		if(i < movieList.length - 1)
		{
			fileOut.writeln(temp.getRatingCount());
		}
		else
		{
			fileOut.write(temp.getRatingCount());
		}		
	}
	fileOut.close();

}

void addNewReview(){
	string userInput; 
	float rating;
	auto reg = regex(["(\\d)+.?(\\d)?"]);
	writeln("\nEnter what title you want to rate: ");
	readf("%s\n", &userInput);
	userInput = strip(userInput); 

	int element = searchExact(userInput); 
	string ratingS; 
	if(element == -1){
		writeln("Title not found.");
	}
	else{
		Movie currentMovie = movieList[element]; 
		do
		{
		writeln("What is your rating? ");
		ratingS = chomp(readln());
		if (matchFirst(ratingS, reg))
		{
			rating = to!float(ratingS);
			if(rating > 5 || rating < 0)
			{
				writeln("Invalid Rating.");
			}
			else
			{
				currentMovie.addRating(rating); 			
			}		
		}
		else{
			writeln("Invalid Rating.");
		}
		}while(rating > 5 || rating < 0);
		

	}

}

void displayMovieList()
{
	writeln("\nAll Movies:");
	writeln("--------------------------------");
	for(int i; i < movieList.length; i++)
	{
		writeln(movieList[i].toString());
	}
}
void addNewMovie(){
	string title;
	string genre;
	string director;
	string yearReleasedStr;
	string runtimeStr;
	uint yearReleased; 
	uint duration;
	float rating; 

	writeln("\nEnter the title: ");
	readf("%s\n", &title);
	title = strip(title); 

	writeln("\nEnter the director: ");
	readf("%s\n", &director);
	director = strip(director);  

	//TODO - Input Validation?
	do
	{
		writeln("\nEnter the release year: ");
		yearReleasedStr = chomp(readln());
		yearReleasedStr = replaceAll(yearReleasedStr, regex([`\D`]), "");
		if (yearReleasedStr != "")
		{
			yearReleased = to!int(yearReleasedStr);
		}
		else
		{
			writeln("Invalid Input.");
			yearReleased = 0;
		}

	}while(yearReleased <= 0);

	do
	{
		writeln("\nEnter the runtime: ");
		runtimeStr = chomp(readln());
		runtimeStr = replaceAll(runtimeStr, regex([`\D`]), "");
		if (runtimeStr != "")
		{
			duration = to!int(runtimeStr);
		}
		else
		{
			writeln("Invalid Input.");
			duration = 0;
		}

	}while(duration <= 0);

	

	writeln("\nEnter the genre: ");
	readf("%s\n", &genre);
	genre = strip(genre);
	genre = genre.chomp(); 

	Movie newMovie = new Movie(title, director, yearReleased, duration, genre, 0, 0);
	movieList ~= newMovie;
	movieList.sort();
}

void editMovie(string title){
	int movieIndex = searchExact(title.toLower());
	auto editMovReg = regex("^[1-5]$");

	if (movieIndex != -1) {
		string editChoice;

		do {
			writeln("What field would you like to alter?\n1) Title\n2) Genre\n3) Director\n4) Release Year\n5) Runtime\n");
			readf("%s\n", &editChoice);

			if(!(matchFirst(editChoice, editMovReg))){
				writeln("That input is invalid."); 
			}
		} while (!(matchFirst(editChoice, editMovReg)));

		switch (editChoice) {
			case("1"): {

				writeln("Enter the new title: \n");
				string newTitle;
				readf("%s\n", &newTitle);
				movieList[movieIndex].setTitle(newTitle);
				movieList.sort();
			}
			break;

			case("2"): {
				writeln("Enter the new genre: \n");
				string newGenre;
				readf("%s\n", &newGenre);
				movieList[movieIndex].setGenre(newGenre);
			}
			break;

			case("3"): {
				writeln("Enter the new director: \n");
				string newDirector;
				readf("%s\n", &newDirector);
				movieList[movieIndex].setDirector(newDirector);
			}
			break;

			case("4"): {
				
				uint yearReleased;
				string yearReleasedStr;
				do{
	
						writeln("\nEnter the release year: ");
						yearReleasedStr = chomp(readln());
						yearReleasedStr = replaceAll(yearReleasedStr, regex([`\D`]), "");
						if (yearReleasedStr != "")
						{
							yearReleased = to!int(yearReleasedStr);
							movieList[movieIndex].setYearReleased(yearReleased);
						}
						else
						{
							writeln("Invalid Input.");
							yearReleased = 0;
						}

				}while(yearReleased <= 0);
			}
			break;

			case("5"): {
				writeln("Enter the new runtime: \n");
				uint newDuration;
				string runtimeStr;
				
				do
				{
					writeln("\nEnter the runtime: ");
					runtimeStr = chomp(readln());
					runtimeStr = replaceAll(runtimeStr, regex([`\D`]), "");
					if (runtimeStr != "")
					{
						newDuration = to!int(runtimeStr);
						movieList[movieIndex].setDuration(newDuration);
					}
					else
					{
						writeln("Invalid Input.");
						newDuration = 0;
					}

				}while(newDuration <= 0);
			}
			break;

			default: break;
		}
	}
	else {
		writeln("Movie not found.");
	}
}

void deleteMovie(string title){
	int toDelete = searchExact(title); 
	if(toDelete != -1)
	{
		Movie m = movieList[toDelete];//temp record of deleted entry
		movieList = remove(movieList, toDelete);
		writeln("\nDeleted: ", m.toString());
	}
	else
	{
		writeln("\n", title, " not found.\n");
	}

}

/* Simple linear search that returns the index of a movie based on its title (if it exists). Returns -1 otherwise.
   Can expand on this if required.
*/
int searchExact(string title){

	Movie temp;
	
	for(int i; i < movieList.length; i++)
	{
		temp = movieList[i];

		if(temp.getTitle().toLower() == title.toLower()) //ignore case?
		{
			return i;
		}		
	}

	return -1;
}

void search(string searchStr, int typeOfSearch){
	
	auto r = regex(searchStr);
	Movie[] searchRecord;
	Movie temp;
	int count = 0; 
	for(int i; i < movieList.length; i++)
	{
		temp = movieList[i];
		if(typeOfSearch == 1)//title
		{
			if((matchFirst(temp.getTitle().toLower(), searchStr))) //ignore case?
			{
				searchRecord ~= temp;
				count++;
			}
		}
		else//genre
		{
			if((matchFirst(temp.getGenre().toLower(), searchStr))) //ignore case?
			{
				searchRecord ~= temp;
				count++;
			}

		}
		//can add more search types		
	}

	writeln("\nResults Found: ", count);
	write("--------------------------------\n");
	for(int i; i < searchRecord.length; i++)
	{
		
		writeln(searchRecord[i].toString());	
	}
}

class Movie{

	private string title;
	private string genre;
	private string director ;
	private uint yearReleased;
	private uint duration;
	private float rating; 
	private int ratingCount; 
	
 

	//this() is used to define a constructor 
	this(string title, string director, uint yearReleased, uint duration, string genre, float rating, int ratingCount){
		this.title = title;
		this.genre = genre; 
		this.director = director;
		this.yearReleased = yearReleased;
		this.duration = duration;
		this.rating = rating; 
		this.ratingCount = ratingCount++; 
	}

	//some getters 
	string getTitle(){
		return title;
	}

	void setTitle(string newTitle){
		this.title = newTitle;
	}

	string getGenre(){
		return genre;
	}

	void setGenre(string newGenre){
		this.genre = newGenre;
	}

	string getDirector(){
		return director;
	}

	void setDirector(string newDirector){
		this.director = newDirector;
	}

	uint getYearReleased(){
		return yearReleased;
	}
	float getRating(){
		return rating;
	}
	int getRatingCount(){
		return this.ratingCount;
	}

	void setYearReleased(uint newRelease){
		this.yearReleased = newRelease;
	}

	uint getDuration(){
		return this.duration;
	}

	void setDuration(uint newDuration){
		this.duration = newDuration;
	}

	void addRating(float r){
		
		this.rating = this.rating * ratingCount;
		ratingCount ++;
		this.rating = (this.rating + r)/ ratingCount;

	}

	//opCmp overload -- for use with sorting (by title)
	override int opCmp(Object o)
	{
		Movie other = cast(Movie)o;
		if(this.title > other.title)
		{
			return 1;
		} 
		else if(this.title < other.title)
		{
			return -1;
		}
		else
		{
			return 0;
		}
	}

	
	override string toString(){
		string movieStr;
		movieStr ~= this.title;
		movieStr ~= "(";
		movieStr ~= to!string(this.yearReleased);
		movieStr ~= ")";
		movieStr ~= " - Directed By ";
		movieStr ~= this.director;
		movieStr ~= " - Genre: ";
		movieStr ~= this.genre; 
		movieStr ~= " - Runtime: ";
		movieStr ~= to!string(this.getDuration);
		movieStr ~= " minutes";
		movieStr ~= " - Rating: ";
		movieStr ~= to!string(this.getRating);
		
		
		return movieStr;
	}

	//TODO - Destruct?

}