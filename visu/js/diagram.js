/*
 * Javascript to generate and navigate in a time-line diagram from a given scenario
 * @author Tom Guillermin
*/

var TIME_UNIT_SIZE = 100 ;
var gradMarks = []; // List of the marks in the X graduation (to avoid duplicates)
var currentActions,
scenarioDuration = 0 ;


/**
* Creates the diagram from a given actions list.
* (Automatically compute the TIME_UNIT_SIZE)
*/
function createDiagram(actions) {
	currentActions = actions;
	scenarioDuration = getScenarioDuration(actions) ;
	TIME_UNIT_SIZE = computeTimeUnitSize(scenarioDuration);
	createGraduations(scenarioDuration);
	loadActions(actions);
}

/**
* Resets the diagram.
*/
function resetDiagram() {

	if (LOG) console.log("Reseting diagram");
	
	$(".actionContainer").remove();
	$("#graduations").children().remove();
	
	updateTimeLinePosition(0);
	createDiagram(currentActions);
}

function finalDiagram() {

	if (LOG) console.log("Jump to the end of diagram");
	
	$(".actionContainer").remove();
	$("#graduations").children().remove();
	
	updateTimeLinePosition(scenarioDuration);
	createDiagram(currentActions);
}

/**
 * Creates the graduation in the diagram
 * duration : number of steps
 */
function createGraduations(duration){
	var graduations = $("#graduations");
	for(var i = 0 ; i <= duration ; i++){
		var x = i * TIME_UNIT_SIZE,
			grad = $("<div></div>").addClass("timeLineGrad");
			//gradLabel = $("<div></div>").addClass("timeLineGradLabel").html(i);
			grad.css({left:x});
			//gradLabel.css({left:x});
			graduations.append(grad);
			//graduations.append(gradLabel);
	}
}

/**
 * Loads the action from the JSON response from server
 */
function loadActions(actions){
	if (LOG) console.log("Loading actions : ", actions);

	for(var i in actions){
		var action = actions[i];
		if( action.id == "allocate"){
			continue;
		}
		var	start = action.start,
			end = action.end,
			actionName = actionToString(action);
		addAction(actionName, start, end);
	}
}

/**
 * Adds an action in the diagram
 * @param string Label of the action
 * @param number Starting time of the action
 * @param number Ending time of the action
 */
function addAction(label, start, end){
    var actionContainer = $("<div></div>").addClass("actionContainer"),
		actionBar = $("<div></div>").addClass("actionBar"),
		actionLine = $("<div></div>").addClass("actionLine"),
		gradMark = $("<div></div>").addClass("gradMark");
    	timeLine = $("#timeLine");

	actionBar.html(label);
	actionContainer.append(actionBar);
	actionContainer.append(actionLine);

	var actionTime = 3,
		xLeft = start * TIME_UNIT_SIZE,
		width = (end-start) * TIME_UNIT_SIZE;

	actionBar.css({
	   left: xLeft,
	   width: width
	});

	$("#actionLines").append(actionContainer);

	addTimeLineMark(start);
}

function actionToString(action){
	switch(action.id){
		case "bootVM":
			return "boot(VM"+action.vm+") to N"+action.to;
		case "shutdownVM":
			return "shutdown(VM"+action.vm+") on N"+action.on ;
		case "migrateVM":
			return "migrate(VM"+action.vm+") from N"+action.from+" to N"+action.to;
		case "shutdownNode":
			return "shutdown(N"+action.node+")";
        case "bootNode":
            return "bootNode(N"+action.node+")";
		case "allocate":
			return "allocate(VM"+action.vm+","+action.rc+"="+action.amount+") on N"+action.on;
		case "root":
			return "root(VM"+action.vm+")";
	}
}

/**
 * Marks a time graduation label with an event (text set to bold)
 * @param instant number Time with event.
 */
function addTimeLineMark(instant){
	$(".timeLineGradLabel").eq(instant).addClass("withEvent");
}

/**
 * Updates the position of the time-line to a match given time
 * @param newTime number Time to which the time-line has to be set.
 */
function updateTimeLinePosition(newTime){
	var newPos = newTime * TIME_UNIT_SIZE;
	$("#currentFrameLine").css({left:Math.round(newPos)});
}

/**
 * Performs the time-line animation from a <i>start</i> to an </i>end</i> time
 * for a given <i>duration</i>.
 * @param duration number Duration of the animation in ms.
 */
function timeLineAnimation(start, end, duration, callback){
    $({value:start}).animate({value:end},{
    	duration:duration,
    	easing:"linear",
    	step:function(){
    		updateTimeLinePosition(this.value);
    	},
    	complete:function(){
    		updateTimeLinePosition(end);
    		if (LOG) console.log("[Time-line] Animation complete !");
    		// Call the callback if any
    		if(callback){
    			callback();
    		}
    	}
    })
};

/**
 * Computes the pixel size of a time unit
 */
function computeTimeUnitSize(duration){
	return $("#diagram").width()/duration ;
}

/**
 * Calculates the duration of a given <i>scenario</i>
 * @param scenario Object The scenario object.
 * @return The duration of the scenario.
 */
function getScenarioDuration(actions){
	var maxTime = 0 , actions = actions ;
	for(var i in actions){
		var action = actions[i];
		if( action.end > maxTime ){
			maxTime = action.end ;
		}
	}
	return maxTime ;
}

/**
 * Returns a list of the actions starting at the provided time parameter.
 * @param time The time at which the returned actions starts.
 * @return The list of the action starting at this time.
 */
function getActionsStartingAt(time){
	var result = [];
	var actions = currentActions;
	for(var i in actions){
		var action = actions[i];
		if( action.start == time ){
			result.push(action);
		}
	}
	return result;
}