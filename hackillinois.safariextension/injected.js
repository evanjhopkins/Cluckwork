
//seems to be double firing for some reason
window.addEventListener("focus", function(){
	//pass url to gloabl.html
	safari.self.tab.dispatchMessage("url",window.location.href);
}, false);