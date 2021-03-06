/*
 * Main functions used to draw nodes and vms
 */

var LOG = true;

var config;
var paper;
var columns = 4;
var lines = 2;
var unit_size = 18; //Size of a unit in px
var border = 20; //Space between the border of the node and the axes


function init() {

    if (LOG) console.log("Init");
    
    // Get INPUTS from config.js
	cfg = JSON.parse(cfg);
	script = script.replace(/\n/g,"<br />");
	scenario = JSON.parse(scenario);
		
    // Create the config object from JSON
	loadConfiguration();
	
    // Draw the configuration
	drawConfiguration("canvas");
	
	// Fill the editor with the script
	$("#scriptContent").html(script);

	// Create the diagram
	if( scenario.actions ) {
		createDiagram(scenario.actions);
	}
	// There are errors in the user constraints script.
	else if (scenario.errors) {
		if (LOG) console.log("There are some errors in the user input.");
	}
	else if (scenario.errors == null && scenario.solution == null) {
		if (LOG) console.log("[SOLVER] There is no solution to the problem.");
	}
}

function resetConfiguration() {
	
    loadConfiguration();
	drawConfiguration("canvas");
}

function finalConfiguration() {
	
	loadConfiguration();
	
	// Apply the scenario and generate the final configuration
	var sortedActions = scenario.actions.sort(function (a, b) {return a.start - b.start;});
	for(var i in sortedActions){
		var action = sortedActions[i];
		switch(action.id){
			case "allocate":
				break;
			case "bootVM":
				break;
			case "root":
				break;
			case "shutdownVM":
				config.getNode("N"+action.on).unhost(config.getVirtualMachine("VM"+action.vm));
				break;
			case "migrateVM":
				config.getNode("N"+action.from).unhost(config.getVirtualMachine("VM"+action.vm));
				config.getNode("N"+action.to).host(config.getVirtualMachine("VM"+action.vm));
				break;
			case "shutdownNode":
				config.getNode("N"+action.node).online = false;
				break;
		    case "bootNode":
		    	config.getNode("N"+action.node).online = true;
		    	break;
		}
	}
	
	drawConfiguration("canvas");
}

function loadConfiguration() {
	
    // Create the config object from JSON data
	config = new Configuration();
    for (var i = 0; i < cfg.length; i++) {
    	var nodeData = cfg[i];
    	var node = new Node(nodeData.id, nodeData.cpu, nodeData.mem);
    	for (var j = 0; j < nodeData.vms.length; j++) {
    		var vmData = nodeData.vms[j];
    		var vm = new VirtualMachine(vmData.id, vmData.cpu, vmData.mem);
    		// Host and add the vm to the configuration
    		node.host(vm);
    		config.vms.push(vm);
    	}
    	// Add the node in the configuration
    	config.nodes.push(node);
    }
}

function drawConfiguration(id) {
	var verbose = true;
	if (verbose) console.log("[DIAGRAM] Drawing current configuration ===================");

	if( paper != undefined ){
		paper.clear();
		if (verbose) console.log("[DIAGRAM] Cleared paper.");
	}

    //Compute the SVG size
    var width = 0;
    var height = 0;

    //Up to 4 nodes side by side
    var max_width = 800;

    var cur_width = 0; //width of the current line
    var max_height = 0; //maximum height of the node on the current line
    //How many nodes per line, how many lines

    for (var i in config.nodes) {
        var n = config.nodes[i];
        var dim = n.boundingBox();

        if (dim[1] > max_height) { max_height = dim[1];}
        n.posY = height;
        if (cur_width + dim[0] > max_width) {
            height += max_height;
            if (width < cur_width) {width = cur_width;}
            cur_width = dim[0];
            n.posX = 0;
            n.posY = height;
            if (i == config.nodes.length - 1) {
                height += max_height;
            }
        } else {
            n.posX = cur_width;
            cur_width += dim[0];
            if (i == config.nodes.length - 1) {
                if (width < cur_width) {width = cur_width;}
                height += max_height;
            }
        }
    }
    //draw it
    if (paper != undefined) {
	    paper.remove();
    }

    paper = Raphael(id, width, height);
    // emptying the paper
    paper.clear();

    for (var i in config.nodes) {
        var n = config.nodes[i];
        n.draw(paper,n.posX,n.posY);
    }

    if (verbose) console.log("[DIAGRAM] Finished drawing =====================");
}

/**
 * Applies the callback f to all the objects in the list l and its sublists.
 */
function foreachArray(l, f){
	var i = 0 ;
    while(i < l.length){
    	var element = l[i];
    	if ($.isArray(element)) {
    		l = l.concat(element);
    		i++;
    		continue;
    	}
    	// Apply the callback
    	f(element);
    	i++;
    }
}
