# Sample Project for Bose Professional 

Description of the application:

Hello :) 
Craving something sweet? Satisfy your sweet tooth with RecipeHut!

This app shows a list of desert items and once you click on it you can view the reciepe for the desert
It uses TheMealDb API's for fetching the information

It has the ability to show error and loading states

On the detail screen, you can click on the "instruction" text to view an exploded view of the text.



Notes to reviewer:

Data Flow:
   
    App home screen - HomePageViewController
    
    request network call via ViewModelSerivce
    
    make network call via NetworkService
    
    convert the response(MealObjectFromServer, MealDetailsObjectFromServer) to interface object (Meal,MealDetail) - defined in modal class
    
    data sorting based on Name - ViewModel
    
    Display Data - HomePageViewController
    
    When you click on an item -> DetailViewControler is called.


-- The project includes test cases majorly for the network mocking and view model functions.
