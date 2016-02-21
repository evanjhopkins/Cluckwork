var firebase = null;

(function() {
	initFirebase();
	createPageOpenOrChangeListeners();
})();

function initFirebase(){
	firebase = new Firebase('https://kelhophackillinois.firebaseio.com/');
}

function createPageOpenOrChangeListeners(){
	//listens for when an existing tab becomes active or new tab opened
	chrome.tabs.onActivated.addListener(function(activeInfo){
		getTabObjectForTabId(activeInfo.tabId);
	});

	//listens for when an existing tab's url changes
	chrome.tabs.onUpdated.addListener(function(tabId){
		getTabObjectForTabId(tabId);
	});

	//listens for changes to firebase
	// firebase.on('child_added', function(snapshot) {
	//   var message = snapshot.val();
	//   console.log(message);
	// });
}

//Matches the tab id to the tab object (which contains the url)
function getTabObjectForTabId(tabId){
	chrome.tabs.getAllInWindow(null, function(tabs){
	    for (var i = 0; i < tabs.length; i++) {
	    	if(tabs[i].id == tabId){
	    		//console.log(tabs[i].url);
	    		firebase.set({url:tabs[i].url});
	    	}                    
	    }
	});
}
