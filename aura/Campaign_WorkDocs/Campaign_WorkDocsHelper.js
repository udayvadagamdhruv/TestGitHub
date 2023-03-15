({
	showToast : function(params) {
        var toastEvent=$A.get("e.force:showToast");
        if(params){
            toastEvent.setParams(params);
            toastEvent.fire();
        }
        else{
            alert(params.message);
        }
		
	}
})