({
    customSettingfecth :function(component, event){
        var CSettingAction = component.get("c.showProductionEstimate");
        CSettingAction.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('========ShowPE========='+response.getReturnValue());
                component.set("v.ShowProductionEstimate",response.getReturnValue());
                
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
        
        $A.enqueueAction(CSettingAction);      
    },
    
    InvlineItemfetch :function(component, event){
         var recId = component.get("v.recordId");
         console.log("==== recId   ===="+recId);
         console.log("====helper recId   ===="+component.get("v.recordId"));
        var action = component.get("c.getInvLineItems");
        action.setParams({
            InvID : recId
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
              for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                 console.log('=====in the Vendor Invoice View==='+JSON.stringify(rows));
               
                  var ShoWPE=component.get("v.ShowProductionEstimate");
                  console.log("====ShoWPE above===="+ShoWPE);
                  
                  if(ShoWPE){
                      if(row.Production_Estimate__c){
                          row.ItemLink='/'+row.Production_Estimate__c;
                          row.EstName=row.Production_Estimate__r.Name;
                      }
                  }
                  else{
                      if(row.Estimate_Line_Item__c){
                          row.ItemLink='/'+row.Estimate_Line_Item__c;
                          row.EstName=row.Estimate_Line_Item__r.Name;
                      }
                  }

                  if(row.GL_Code__c){
                        row.GLCLink='/'+row.GL_Code__c;
                        row.GLCName=row.GL_Code__r.Name;
                    }
                 
                }
                console.log('----->data---'+JSON.stringify(rows));
                component.set("v.data",rows);
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
    
    
    
    PoLineItemsFromPoInvoiceView : function (component, event, helper) {
        var ShowPE=component.get("v.ShowProductionEstimate");
        console.log('========PoLineItemsFromPo =ShowPE======='+ShowPE);
        var PoLiAction = component.get("c.PoLineItemsFromPo");
        PoLiAction.setParams({
            poid :component.get("v.simpleRecord.Purchase_Order__c")
        });
        PoLiAction.setCallback(this, function(POLIresponse) {
            if (POLIresponse.getState() === "SUCCESS") {
                console.log('=====PoItems in the Vendor Invoice View==='+POLIresponse.getReturnValue());
                console.log('=====in the Vendor Invoice View==='+JSON.stringify(POLIresponse.getReturnValue()));
                
                var rows=POLIresponse.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    console.log('==row ='+row);
                    console.log('==Amount='+row.Calc_amnt);
                    row.Calc_Amnt=row.Calc_amnt;
                    if(ShowPE){
                        row.LineName=row.e.Production_Estimate__r.Name;
                        row.Qunatity=row.e.Quantity_production__c;    
                    }
                    else{
                        row.LineName=row.e.Estimate_Line_Item__r.Name;
                        row.Qunatity=row.e.Quantity__c; 
                     }
                }
                component.set("v.PoLidata",rows);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',POLIresponse.getError()[0].message);
                var errors = POLIresponse.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
           $A.enqueueAction(PoLiAction);  
      },
    
    saveRecordsInvfromPOInvoiceView : function(component,selectedRecords,InvoiceId,Porderid,event,helper){
         var SaveAction = component.get("c.SavePoLineItems");
        SaveAction.setParams({
            selectedRec : selectedRecords,
            InvId:InvoiceId,
            poid:Porderid
        });
        
        SaveAction.setCallback(this, function(res) {
            if(res.getState() === "SUCCESS") {
                if(res.getReturnValue()=="OK"){
                    helper.InvlineItemfetch(component, event);
                    component.set("v.isaddClick",false);
                    var ToastMsg111 = $A.get("e.force:showToast");
                    ToastMsg111.setParams({
                        "type": "success",
                        "message":'Successully PO Line Items Inserted as Invoice Line Items'
                    }); 
                    ToastMsg111.fire();
                   
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
         $A.enqueueAction(SaveAction);  
        
    },
    
    getRowActions: function (component, row, doneCallback) {
        var status= component.get("v.simpleRecord.Invoice_Status__c");
         var actions = [];
        
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_INVLI'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_INVLI'
        };
        
         if (status == 'Paid') {
            editAction['disabled']= 'true';
            deleteAction['disabled'] = 'true';
         }
        actions.push(editAction,deleteAction);
         // simulate a trip to the server
         setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
	},
 
    /*
     * This function get called when user clicks on Save button
     * user can get all modified records
     * and pass them back to server side controller
     * */
    saveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("INVLIDataTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateInvLI");
        action.setParams({
            'editedInvLIList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === 'true'){
                    helper.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": totalRecordEdited+"  Invoice Line Items Records Updated"
                    });
                    
                    helper.reloadDataTable();
                    helper.InvlineItemfetch(component, event, helper);
                    component.find("INVLIDataTable").set("v.draftValues", null);
                    
                } else{ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                   
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
    
     /*
     * Show toast with provided params
     * */
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
   
    reloadDataTable : function(){
        console.log('==========reloadData Table======');
    var refreshEvent = $A.get("e.force:refreshView");
         $A.get('e.force:refreshView').fire();
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        if(fieldName=='GLCLink'){
            data.sort(this.sortBy('GLCName', reverse))
        } else{
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
    
     CreateINVLIRecord:  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Invoice_Line_Item__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
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
    
    getGLCode: function(component, event, helper){
        var VenId=component.get("v.simpleRecord.Vendor__c");
        console.log('===Get GLCode VenId==='+VenId);
        var actionCC = component.get("c.getINVLIGLCode");
        
        actionCC.setParams({
            VendorId :VenId 
        });
        actionCC.setCallback(this, function(responseCC){
            var stateCC = responseCC.getState();
            console.log("===List of GLC values===" + responseCC.getReturnValue());
            var CC=responseCC.getReturnValue();
            var CClist=[];
            if(stateCC === "SUCCESS"){
                for (var key in CC) {
                    CClist.push({
                        key: key,
                        value: CC[key]
                    });
                }
                component.set("v.GLCRecord", CClist); 
                 console.log("===List of GLC values===" +JSON.stringify(CClist));
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',responseCC.getError()[0].message);
                var errors = responseCC.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        }); 
        $A.enqueueAction(actionCC);  
    },
    
    deleteJobINVLI: function(component, event, helper){
        var row = event.getParam('row');
        console.log('===Delete INVLI Id=='+row.Id);     
        var DeleteINVLII=component.get("c.deleteInvLI");
        DeleteINVLII.setParams({InvLIRecId :row.Id });
        DeleteINVLII.setCallback(this, function(DeleteINVLIIres){
            var delstate = DeleteINVLIIres.getState();
            if(delstate === "SUCCESS"){
                helper.InvlineItemfetch(component, event, helper);
                var ToastMsg = $A.get("e.force:showToast");
                ToastMsg.setParams({
                    "type": "success",
                    "message":'Record Deleted Successfully.'
                });
                ToastMsg.fire();
            }
            else
            {
                var ToastMsg = $A.get("e.force:showToast");
                ToastMsg.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message":DeleteINVLIIres.getReturnValue()
                });
                ToastMsg.fire();
            }
        });
        $A.enqueueAction(DeleteINVLII);  
    }

    
})