# Annotation-software-of-Human-Grasping-Database
_______________________________________________________________________________________________________________________________________
	DESCRIPTION:

	Annotation software is designed to annotate NU Human Grasping-Database. 
	It consists mainly of three windows:
		
		- annotate.m

		- SaveAnnotation.m

		- GraspTypes.m
	
	"annotate.m"
	This is the main window of the Annotation Software. It has following items/features:
		
		- Video Player feature has following items:
			- Axes: for displaying images of video
			- Video player: contains customized control buttons
				- stop, play, pause, fast forward/backward, 1 frame forward/backward,
				jumping to specific frame, slider for overview progress of video.
		
		- Input Specification part has following items('mp4' video file expected):
			- edit text field for file name (must include path to the video file);
			- browse button to select video file using user interface;
			- load button for loading video file;
			- status indicator;
		
		- Grasp Specifications part has following items:
			- edit texts for start and end frames;
			- buttons "Start" and "End" to write for start and end frames;
			- "Output" button to refresh grasp index;
			- "Open csv file" button to view current csv file which was specified 
			at longest edit text field;
			- edit text field to show index of grasp instance being detected;
			- static text indicator field to illustrate current grasp sequence;
			- "New Sequence" button to start new sequence;
			- "add grasp" button to add new grasp to a sequence;
			- "Close Sequence" button to finish the current sequence;
				- enable state of last three buttons changes as follows:
					initially "New sequence" button enabled, "add grasp" and "Close seq" button disabled;
					when "New sequence" starts it disables itself and enables other two: "add grasp" and "Close seq";
					at the end of the sequence "Close seq" button should be called which reverses states back to initial states.
	
	"SaveAnnotation.m"
	This is second window that user will see after calling "New Sequence" or "add grasp" button from "annotate.m". 
	Main purpose is to finalize annotation process by selecting grasp type that matches detected grasp observed from video file.
	It has following feature and items:
		- Grasp Selection feature:
			- "Grasp Type" button calls new window "Grasp type" to allow user to select one of 35 grasp type options;
			- axis that shows image of grasp type for visual confirmation;
		
		- ADL panel of radio button group:
			- three radio buttons for three possible ADL types (Cooking, Housekeeping, Laundry)
		
		- Grasp Summary panel contains list of important parameters of grasp instance such as ID, 
			ADL, Grasp, Start Frame, End Frame etc.
		
		- Preview button shows as it is all items being recorded into specifed csv file (at "annotate.m" window)
		
		- "OK" button finishes the process and closes the window;
		- "Cancel" button is to cancel this process safely and returns back to parent window;
		
	"GraspTypes.m"
	Contains large radio button group that has 35 options (33 from GRASP comprehensive taxonomy + 2 non-prehensile grasps).
	
		- "Finish" button to pass the selected grasp choice to parent window ("SaveAnnotation.m") and closes itself;
_______________________________________________________________________________________________________________________________________
	HOW TO USE:

	
	1. RUN annotate.m file (or relevand guide file "annotate.fig" )
	2. Select video file that you want to annotate.
		Two Options:
			- by directly filling edit text with file name and path to it;
			- by calling brows button select from file manager;
	3. Press "Load" button. It will show first image on axis when loaded.
	4. Specify output file to record you annotations at "Save Grasp" button group;
	5. Detect grasp range using media control buttons;
	6. When you detected new grasp stop at first frame of grasp instance and press "Start" button located at "Save Grasp"
	button group. That will fix start frame number
	7. Reach last frame of grasp instance using media control buttons and press "End" button located at "Save Grasp" button group;
	8. When you are ready to proceed press "New Sequence" button to start new sequence. That will create new "SaveAnnotation.m"
	window.
	9. At "SaveAnnotation.m" window press "Grasp Type" button located at "grasp" panel on the center; that will pop up new 
	"GraspTypes.m" window.
	10. Selec a grasp type that you think most likely matches with detected grasp invoke by human subject;
	11. Press "Finish" button that will close the window and return back to "SaveAnnotation.m" window;
	12. Specify ADL type of this particular grasp.
	13. Press "Preview" button to check your decision;
	14. When you are confident press "OK" button, that will save new grasp instance at your specified csv file.
	15. Detect another grasp again. 
	16. If subject released an object that indicates end of grasp sequence. Then you can press 
	"Close Seq" button that resets sequence parameters.
	17. If detected grasp is performed without releasing an object then you should add new grasp by calling "add grasp" button
	that will follow with the same procedure 9-14.
_______________________________________________________________________________________________________________________________________

(c) Zhanibek Rysbek
    PhD Student
    Department of Electrical and Computer Engineering 
    University of Illinois at Chicago
    email: zrysbe2@uic.edu
    
For more questions please feel free to contact.
