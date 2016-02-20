//listens for when an existing tab becomes active or new tab opened
chrome.tabs.onActivated.addListener(function(activeInfo){
	getTabObjectForTabId(activeInfo.tabId);
});

//listens for when an existing tab's url changes
chrome.tabs.onUpdated.addListener(function(tabId){
	getTabObjectForTabId(tabId);
});

//Matches the tab id to the tab object (which contains the url)
function getTabObjectForTabId(tabId){
	chrome.tabs.getAllInWindow(null, function(tabs){
	    for (var i = 0; i < tabs.length; i++) {
	    	if(tabs[i].id == tabId){
	    		console.log(tabs[i].url);
	    	}                    
	    }
	});
}

