({
    
    POlineItemfetch :function(component, event){
         var recId = component.get("v.recordId");
         console.log("==== recId   ===="+recId);
         console.log("====helper recId   ===="+component.get("v.recordId"));
        var action = component.get("c.getPOLineItems");
        action.setParams({
            POId : recId
        });
        action.setCallback(this, function(response) {
           var showPE=component.get("v.ShowProductionEstimate");
            
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                  console.log("===PO Line Items==" + JSON.stringify(rows));
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                   // row.ItemLink = '/'+row.Id;
                    //console.log('==Pestimate=='+row.Production_Estimate__c);
                    //console.log('==Pestimate=='+row.Production_Estimate__r.Name);
                    if(showPE){
                        row.ItemLink = '/'+row.Production_Estimate__c;
                        row.Name=row.Production_Estimate__r.Name;
                        row.Quantity=row.Quantity_production__c;
                    }
                    else{
                     row.ItemLink = '/'+row.Estimate_Line_Item__c;   
                     row.Name=row.Estimate_Line_Item__r.Name;
                     row.Quantity=row.Quantity__c;   
                    }
                    if(row.GL_Code__c){
                        row.GLDLink='/'+row.GL_Code__c;
                        row.GLDName=row.GL_Code__r.Name;
                    }
                }
                console.log('-----data----->'+JSON.stringify(rows));
                component.set("v.data",rows);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                var ToastMsg=$A.get("e.force:showToast");    
                ToastMsg.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                    
                });   
                ToastMsg.fire();                
            }
        });
        $A.enqueueAction(action);
        
    },
    ShowProductionEstimate :function(component, event){
        var showPEAction = component.get("c.showProductionEstimate");
        showPEAction.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var isShowPE=response.getReturnValue();
                component.set("v.ShowProductionEstimate",isShowPE);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(showPEAction);                          
    },
    
    getRowActions: function (component, row, doneCallback) {
        var status= component.get("v.simpleRecord.Status__c");
        var actions = [];
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'action:delete',
            'name': 'Delete_POLI'
        };
        if(status=='Sent'){
            deleteAction['disabled']=true;
        }
        actions.push(deleteAction);
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        if(fieldName=='ItemLink'){
             data.sort(this.sortBy('Name', reverse))
        }else if(fieldName=='GLDLink'){
             data.sort(this.sortBy('GLDName', reverse))
        }else{
            data.sort(this.sortBy(fieldName, reverse))
        }
        cmp.set("v.data", data);
    },
    sortBy: function (field, reverse, primer) {
        console.log('==sortBy=primer==='+primer);
        console.log('==sortBy=field==='+field);
        console.log('==sortBy=reverse==='+reverse);
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    
    deletePOLineItem :function (component, event,helper) {
       var row = event.getParam('row');
        var poliId = row.Id;
        var action = component.get("c.deletePOLI");
        action.setParams({
            strPOLI : poliId
        });
        action.setCallback(this, function(response) {
            console.log("===Delete PO Line Item====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                if(response.getReturnValue()==='OK'){
                    helper.POlineItemfetch(component, event);
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message":response.getReturnValue()
                    });
                    toastEvent.fire();
                    
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action); 
    },
    
    selectedEstLI_PELI: function(component, event, helper){
        var newPOId=component.get("v.recordId");
      var POLI=component.get('v.Selected_ESTLI');
      if((newPOId!=null || newPOId!='') && (POLI!=null || POLI!='')){
          var Est_PEAction = component.get("c.insertEstLI_PELI");
          Est_PEAction.setParams({
              PORecId : newPOId,
              selRecords : POLI });
          
          Est_PEAction.setCallback(this, function(Est_PEActionRes){
              var Est_PEActionstate = Est_PEActionRes.getState();
              console.log("===insert Est_PE state from Detail page===" + Est_PEActionRes.getReturnValue());
              if(Est_PEActionstate === "SUCCESS"){
                  console.log('=====scucesffully inserted Est and PE the records from the Detail page===');
                  var ToastMsg5=$A.get("e.force:showToast");    
                  ToastMsg5.setParams({
                      "type": "success",
                      "message": POLI.length +" line Items  added to this Purchase Order."
                      
                  });   
                  ToastMsg5.fire();
                  
                  helper.POlineItemfetch(component, event);
                  component.set("v.Selected_ESTLI",null);   
                  component.set("v.isaddClick",false);  
              } 
              else {
                console.log('>>>>>> Error >>>>>>>>>>',Est_PEActionRes.getError()[0].message);
                var errors = Est_PEActionRes.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
          }); 
          $A.enqueueAction(Est_PEAction);  
      }
  }
    
})