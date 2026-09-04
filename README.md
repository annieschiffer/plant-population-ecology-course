# Plant population ecology course

This GitHub repository contains the course content and course website information for WILD 7900 at Utah State University: Plant population ecology. 

The course covers the ecological processes that influence plant populations. In this course, we link conceptual topics to their implementation in mathematical models. The models will be increasingly elaborate variations on one basic population model.

## About the website

The course website is launched through Netlify, which is connected to this GitHub repository. Edited files in the GitHub repository will automatically deploy to the website via Netlify.

We created the website by copying a [template](https://app.netlify.com/start/deploy?repository=https://github.com/weecology/forecasting-course) from the [Ecological Forecasting course website](https://course.naturecast.org/), taught by Morgan Ernest and Ethan White at the University of Florida. The course website is written in Hugo using the [Wowchemy Documentation theme](https://github.com/wowchemy/hugo-documentation-theme) and broader [Wowchemy system](https://wowchemy.com/)

## Repository structure

* Course lessons and R scripts are stored in the "content/schedule" folder, in the "_index.md" file. Everything for the course is linked from there.
* The syllabus can be found in the "_index.md" file in the "content/syllabus" folder.
* Linked discussion questions, R scripts, and problems sets are stored in the "static" folder.
* Lecture notes are stored in the "notes" folder.

All other files and folders in the repository are related to the website appearance and structure.

* "content/home" folder: the content and structure of the home page is contained in the yaml headers of "hero.md" and "index.md"
* "assets/media" folder: contains any icons and images on the course website
* "config/_default" folder: global yaml settings for the website
