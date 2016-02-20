var application = "com.kelhop.HackIllinois.HackIllinoisChromeExtension";
var port = null;

(function() {
	initNativeMessaging();
	createPageOpenOrChangeListeners();
})();

function initNativeMessaging(){
	port = chrome.runtime.connectNative(application);

	port.onMessage.addListener(function(msg){
		console.log(msg);
	});

	port.onDisconnect.addListener(function(e) {
	    console.log('unexpected disconnect');
	    port = null;
	});
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
}

//Matches the tab id to the tab object (which contains the url)
function getTabObjectForTabId(tabId){
	chrome.tabs.getAllInWindow(null, function(tabs){
	    for (var i = 0; i < tabs.length; i++) {
	    	if(tabs[i].id == tabId){
	    		console.log(tabs[i].url);
	    		sendUrlToApp();
	    	}                    
	    }
	});
}

function sendUrlToApp(){
	if(!port){
		console.log("No connection to app: message not sent");
		return;
	}
	chrome.runtime.sendNativeMessage(application, "test", null );

}
