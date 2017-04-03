import std.stdio;
import std.file;
import std.conv;
import std.string;
import std.algorithm;
import std.container; 

Movie[] movieList;

void main()
{
	
	
	//to read data from previous session
	File fileIn = File("moviedata.txt", "r");
	
	while(!fileIn.eof())
	{
		string movtitle 	= chomp(fileIn.readln());
		string movdirector  = chomp(fileIn.readln());
		string yearStr      = chomp(fileIn.readln());
		string durationStr  = chomp(fileIn.readln());
		string genre 		= chomp(fileIn.readln());

		uint year = to!uint(yearStr);
		uint dur  = to!uint(durationStr);

		Movie movie = new Movie(movtitle, movdirector, year, dur, genre);
		movieList ~= movie; //adds movie to the list
	}
	fileIn.close();

	int userChoice;
	string userInput;

	do{
		writeln("What would you like to do?\n");
		writeln("1) Search for a movie\n2) Add a new movie\n3) Leave a review\n4) Update a movie's information"); 

		readf("%d\n", &userChoice);

		if(userChoice < 1 || userChoice > 4){
			writeln("That input is invalid."); 
		}

	} while(userChoice < 1 || userChoice > 4); 

	switch(userChoice){
		case(1):{
			writeln("\nSearch by:\n");
			writeln("1) By title\n2) By genre");

			readf("%d\n", &userChoice);

			writeln("\nEnter what you want to search for: ");
			readf("%s\n", &userInput);
			userInput = strip(userInput); 

			switch(userChoice){
				case(1):{
					 searchByTitle(userInput);
					 if (searchByTitle(userInput) == -1)
					{
						writeln("Not Found.");
					}
					else
					{
						Movie found = movieList[searchByTitle(userInput)];
						writeln(found.getTitle(), " Director: ", found.getDirector());
					}
					writeln(userChoice);
				}
				case(2): searchByGenre(userInput);
				default: break; 
			}
		}
		break; 

		case(2):{
			addNewMovie(); 
		}
		break;

		case(3):{
			addNewReview();
		}
		break;

		case(4):{
			writeln("\nEnter what you want to search for: ");
			readf("%s\n", &userInput);
			userInput = strip(userInput); 

			editMovie(userInput); 
		}
		break;

		default: break; 
	}//end of switch




	//TODO -- MUCH.
	
	/*function calls for testing
	writeln("\nAdd New Movie Test ");
	writeln("------------------------\n");
	addNewMovie();
	
	writeln("\nSorting List... ");
	writeln("------------------------\n");
	sort(movieList);
	
	writeln("\nSearch By Title Test ");
	writeln("------------------------\n");
	string titleSearch;
	writeln("\nEnter search title: ");
	readf("%s\n", &titleSearch);
	titleSearch = strip(titleSearch); 
	titleSearch.toLower(); */

	

	//to write data to new file after current session (for persistence)
	File fileOut = File("moviedata2.txt", "w");//TODO - probably rewrite to same file
	Movie temp;
	for(int i; i < movieList.length; i++)
	{
		temp = movieList[i];
		fileOut.writeln(temp.getTitle());
		fileOut.writeln(temp.getDirector());
		fileOut.writeln(temp.getYearReleased());
		fileOut.writeln(temp.getDuration());
		fileOut.writeln(temp.getGenre());
		
	}
	fileOut.close();

}

void addNewReview(){

}

void addNewMovie(){
	string title;
	string genre;
	string director;
	uint yearReleased; 
	uint duration;

	writeln("\nEnter the title: ");
	readf("%s\n", &title);
	title = strip(title); 

	writeln("\nEnter the genre: ");
	readf("%s\n", &genre);
	genre = strip(genre);

	writeln("\nEnter the director: ");
	readf("%s\n", &director);
	director = strip(director);  

	//TODO - Input Validation?
	writeln("\nEnter the release year: ");
	readf("%d\n", &yearReleased); 

	writeln("\nEnter the running time: ");
	readf("%d\n", &duration); 

	Movie newMovie = new Movie(title, director, yearReleased, duration, genre);
	movieList ~= newMovie;
}

void editMovie(string title){

}

void deleteMovie(string title){
	int toDelete = searchByTitle(title); 
	movieList[toDelete] = null ;
}

/* Simple linear search that returns the index of a movie based on its title (if it exists). Returns -1 otherwise.
   Can expand on this if required.
*/
int searchByTitle(string title){

	Movie temp;
	
	for(int i; i < movieList.length; i++)
	{
		temp = movieList[i];

		if(temp.getTitle().toLower() == title) //ignore case?
		{
			return i;
			break;
		}		
	}

	return -1;
}

void searchByGenre(string genre){

}

class Movie{

	private string title;
	private string genre;
	private string director ;
	private uint yearReleased;
	private uint duration;
	
 

	//this() is used to define a constructor 
	this(string title, string director, uint yearReleased, uint duration, string genre){
		this.title = title;
		this.genre = genre; 
		this.director = director;
		this.yearReleased = yearReleased;
		this.duration = duration;
	}

	//some getters 
	string getTitle(){
		return title;
	}

	string getGenre(){
		return genre;
	}

	string getDirector(){
		return director;
	}

	uint getYearReleased(){
		return yearReleased;
	}
	uint getDuration(){
		return this.duration;
	}

	//opCmp overload -- for use with sorting (by title)
	int opCmp(ref const Movie other) const
	{
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

	//TODO - toString?

	//TODO - Deconstruct?

}