# MovieRecommender
UBCF/IBCF Movie Recommendation based on the MovieLens dataset, course project for CS598@UIUC built on shinyapp

## How to Run
Clone all files, and open `ui.R` in RStudio, then click "Run App" in the top right corner of RStudio.

## Folder Structure
The project has a simple and flat folder structure. The folder structure is examined below:
- `/css/` contains a small .css file which has all the styling needed for the app.
- `/data/` contains the raw Movielens dataset
- `/fucntions/` has some UI helper functions used in the shiny app shared by both systems.
- `/models/` contains the pre-trained model using all Movielens data (no train/test split). The reason why I am saving the model is because training an IBCF model takes quite a while, and the app will not start before the model training is finished. 
- `/scripts/` contains some preprocessing scripts. This includes loading the movie data, cleaning and transforming it, adding and extracting fields like `Year` and `ImageUrl`.
- `/server.R` and `/ui.R` should be self-explainatory. They are components needed for the app to start and run.

## Screenshot demo
![image](https://user-images.githubusercontent.com/10318596/145942758-8a17adee-d4dd-4d27-b9ee-6a4f752f9e1a.png)
![image](https://user-images.githubusercontent.com/10318596/145942776-67e42c18-4e22-4e67-ba4f-d3d5be0c6a98.png)
![image](https://user-images.githubusercontent.com/10318596/145942816-2b308d5e-c796-4c44-b0f5-6e6f19b94e62.png)
![image](https://user-images.githubusercontent.com/10318596/145942840-2d0fb074-797d-4cc1-9ee9-281922920173.png)
![image](https://user-images.githubusercontent.com/10318596/145942869-dd01438f-14cc-4d58-b80e-defa5ab32fca.png)
