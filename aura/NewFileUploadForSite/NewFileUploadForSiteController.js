({
	 handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        var file = component.find("fuploader").get("v.files");
        
        if (event.getSource().get("v.files").length > 0) {
            console.log('>> Length IF >>');
            if (file[0].size > 4500000) {
               // component.set("v.enable",true);
                console.log('>> Size IF >>');
               // helper.showToastMessage(component, "File size cannot exceed 2MB", "LightningMsgToast", "error");
                component.set("v.fileName", 'Alert : File size cannot exceed 2MB.\n' + ' Selected file size: ' + file[0].size);
            }
            else
            {
               // component.set("v.enable",false);
                console.log('>> else size IF >>');
                fileName = event.getSource().get("v.files")[0]['name'];
                component.set("v.fileName", fileName);
            }
           
            if (component.find("fuploader").get("v.files").length > 0) {
                console.log('==File===',component.get("v.parentId"));
                helper.uploadHelper(component, event,component.get("v.parentId"));
               
            } else {
                alert('Please Select a Valid File');
            }
        }
        
    },
})