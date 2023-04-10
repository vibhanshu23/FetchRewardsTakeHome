# FetchRewardsTakeHome

Description of the application:

Welcome to RecipeHut!
The app shows a list of meal items and also displays the recipe:

Additional Features:
has the ability to show error and loading states and is integrated with the network.
click on the "instruction" to view an exploded view of the text.

Notes to reviewer:

Data Flow:
    App launch - HomePageViewController
    request network call - ViewModel
    make network call - NetworkHandler
    convert the response(MealObjectFromServer, MealDetailsObjectFromServer) to interface object (Meal,MealDetail) - Calling Logic is in ViewModel but the                   function is defined in (MealObjectFromServer, MealDetailsObjectFromServer)
    data sorting - ViewModel
    Display Data - HomePageViewController

-- Please pull the code from the branch "Dev".

-- During Friday and Saturday theMealDB was down and hence I included some test code to mock the response in the project. Please use the string "//DEBUG" to find the lines. Currently these lines are commented out.

-- I have also created a pull request on Github for your convenience 

-- The project includes test cases majorly for the network mocking and view model functions.
