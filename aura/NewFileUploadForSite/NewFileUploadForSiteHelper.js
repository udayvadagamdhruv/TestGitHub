({
	  MAX_FILE_SIZE: 4500000, //Max file size 2 MB 
    CHUNK_SIZE: 750000,    //Chunk Max size 450Kb  
    
    uploadHelper: function(component, event,recId) {
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fuploader").get("v.files");
        console.log('==fileInput==='+fileInput);
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
        
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents, recId);
        });
        
        objFileReader.readAsDataURL(file);
    },
    
    uploadProcess: function(component, file, fileContents,recId) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);//172,250      
        console.log('==uploadProcess==='+recId);
        console.log('==uploadProcess File Length==='+fileContents.length);
         console.log('---startPosition--1st-'+startPosition);
                console.log('---endPosition--1st-'+endPosition);
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, recId);
    },
    
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition,  recId, attachId) {
        // call the apex method 'SaveFile'
        console.log('>>>>>>> Upload file parent id',recId);
        console.log('>>>>>>> Upload file type',file.type);
        console.log('>>>>>>> Upload file Name',file.name);
         console.log('>>>>>>> attachId file Name',attachId);
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        action.setParams({
            parentId: recId, 
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
        
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            console.log('>>>>>>> Upload file attachId',attachId);
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('>>>>>>>SUCCESS');
                // update the start position with end postion
                startPosition = endPosition;//172
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);//172,322
                 console.log('---startPosition--2nd-'+startPosition);
                console.log('---endPosition--2nd-'+endPosition);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                //console.log('>>>>>>> Upload file Start Position',startPosition);
                //console.log('>>>>>>> Upload file End Position',endPosition);
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, recId, attachId);
                } else {
                    var pageReference = {
                        type: 'standard__component',
                        attributes: {
                            componentName: 'SiteJobForm',
                        }         
                    };
                    component.set("v.pageReference", pageReference);
                    var navService = component.find("navService");
                    var pageReference = component.get("v.pageReference");
                    event.preventDefault();
                    navService.navigate(pageReference);
                    //  alert('File has been uploaded successfully');
                 /*   var navigateEvent = $A.get("e.force:navigateToComponent");
                    navigateEvent.setParams({
                        componentDef: "c:SiteJobForm"
                        //You can pass attribute value from Component2 to Component1
                        
                    });
                    navigateEvent.fire();*/
                }
               // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },

})