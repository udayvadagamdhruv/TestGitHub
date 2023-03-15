({
   
    getFieldLabels: function(component, event, helper) {
       
        var rowActions=helper.getRowActions.bind(this,component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Production_Estimate__c'
        });
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                component.set( 'v.ObjectType', JSON.parse( response.getReturnValue() ) );
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue() )));
                var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
               
                var tableHeader=component.get('v.ObjectType');
                console.log('>>>Field Name Dynamically >>>>>>>>>>>>>'+tableHeader);
                if(isMobile){
                    component.set("v.isMobile",true);
                    component.set("v.ProEstimatecolumns",[
                        {label: tableHeader.Production_Estimate__c.Name.label, fieldName: 'ProEstLink',  type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip :{ fieldName: 'Name' }} },
                        {label: tableHeader.Production_Estimate__c.Quantity__c.label, fieldName: 'Quantity__c', type: 'number', cellAttributes: {alignment: 'left' }},
                        {label: tableHeader.Production_Estimate__c.Total_Cost__c.label, fieldName: 'Total_Cost__c', type: 'currency', cellAttributes: {alignment: 'left' } }
                    ]);
                    var labels = {'Quantity':tableHeader.Production_Estimate__c.Quantity__c.label,
                                  'TotalCost':tableHeader.Production_Estimate__c.Total_Cost__c.label
                                 };
                    component.set('v.DynamicLabels',labels);
                    console.log('-----labels------'+JSON.stringify(labels));
                }
                else{
                    component.set("v.ProEstimatecolumns",[
                        {type: 'action', typeAttributes: {rowActions: rowActions}},
                        {label: tableHeader.Production_Estimate__c.Name.label, fieldName: 'ProEstLink',  type: 'url', initialWidth:200, typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip :{ fieldName: 'Name' }} },
                        {label: tableHeader.Production_Estimate__c.Vendor__c.label, fieldName: 'Vendor', type: 'text',initialWidth:200},
                        {label: tableHeader.Production_Estimate__c.GL_Code__c.label, fieldName: 'GlCode',  type: 'text',initialWidth:200},
                        {label: tableHeader.Production_Estimate__c.Calc_Unit__c.label, fieldName: 'Calc_Unit__c',type: 'text',initialWidth:150},
                        {label: tableHeader.Production_Estimate__c.Quantity__c.label, fieldName: 'Quantity__c', type: 'number',initialWidth:80, cellAttributes: {alignment: 'left' }},
                        {label: tableHeader.Production_Estimate__c.Amount__c.label, fieldName: 'Amount__c',type: 'currency',initialWidth:120, cellAttributes: {alignment: 'left' }},
                        {label: tableHeader.Production_Estimate__c.Total_Cost__c.label, fieldName: 'Total_Cost__c', type: 'currency',initialWidth:120, cellAttributes: {alignment: 'left' } },
                        {label: tableHeader.Production_Estimate__c.Approved__c.label, fieldName: 'Approved__c',  type: 'boolean',initialWidth:100},
                        {label: tableHeader.Production_Estimate__c.PO_Created__c.label, fieldName: 'PO_Created__c',  type: 'boolean',initialWidth:120},
                        {label: tableHeader.Production_Estimate__c.PO__c.label, fieldName: 'PO__c', type: 'text',initialWidth:100}
                       
                    ]);
                }
               
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Production Estimate has '+errors[0].message
                });
            }
        });
        $A.enqueueAction( Objaction );  
    },
   
    fetchJobProEstimates : function(component, event, helper) {
        var PEAction=component.get("c.getProductionEstimateRecords");
        PEAction.setParams({
            recordId:component.get("v.jobrecordId")
        });
        PEAction.setCallback(this,function(res){
            if(res.getState()==="SUCCESS"){
                var result=res.getReturnValue();
                console.log('====Production Estimate Records===='+JSON.stringify(result));
                var PEMap=[];
                for (var key in result) {
                    var rows=result[key];
                    for(var i=0;i<rows.length;i++){
                        var row=rows[i];
                        if(row.Name)row.ProEstLink='/'+row.Id;
                        if(row.Vendor__c)row.Vendor=row.Vendor__r.Name;
                        if(row.GL_Code__c)row.GlCode=row.GL_Code__r.Name;
                    }
                    PEMap.push({PETemp:key, value:rows});
                }
                console.log('====Pro Estaimate Records after the Map===='+JSON.stringify(PEMap));
                component.set("v.JobProEstRecords",PEMap);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Production Estimate has '+errors[0].message
                });
            }
           
           
           
        });
       
       
       
        var sumAction = component.get("c.getTotalAmountForSections");
        sumAction.setParams({
            ObjectName : "ProEst",
            Jobid:component.get("v.jobrecordId")
        });
        sumAction.setCallback(this, function(res) {
            if (res.getState() === "SUCCESS") {
                component.set("v.TotalAmount",res.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Production Estimate has '+errors[0].message
                });
            }
        });
       
        $A.enqueueAction(PEAction);
        $A.enqueueAction(sumAction);
    },
   
    fetchFieldsetforProEstimate:  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Production_Estimate__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field sets for the ProEstimate===="+ response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Production Estimate has '+errors[0].message
                });
            }
        });
       
        var LabelAction = component.get("c.geLabelforObject");
        LabelAction.setParams({
            sObjName : "Production_Estimate__c"
        });
        LabelAction.setCallback(this, function(response) {
            console.log("=====Label for the ProEstimate===="+response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.ProEstObjLabel", response.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Production Estimate has '+errors[0].message
                });
            }
        });
       
        $A.enqueueAction(action);
        $A.enqueueAction(LabelAction);
       
    },
   
    getMaterialItemsWidth :function(component, event, MIId){
        var miaction = component.get("c.getMatereialItemsWidth");
        miaction.setParams({
            materialid :  MIId
        });
        miaction.setCallback(this, function(res) {
            console.log("=====Materail Items rcd width ===="+res.getReturnValue());
            if(res.getState() === "SUCCESS"){
                if(res.getReturnValue() > 0){
                    	var val = res.getReturnValue()-2.5;
                        component.set("v.Materialitemwidth",res.getReturnValue());
                    	var ToastCalMsg = $A.get("e.force:showToast");
                    	ToastCalMsg.setParams({
                        "title": "Width",
                        "type": "Success!",
                        "message" : 'Please enter width less than or equal to '+val });
                    ToastCalMsg.fire();
                }
                else{
                    component.set("v.Materialitemwidth",0);
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
            }
        });
        $A.enqueueAction(miaction);  
    },
   
    getMaterialItems :function(component, event, MIVal){
        var CalUnit=component.find("CalUnitFieldId").get("v.value");
        var Equip = component.find("EquipFieldId").get("v.value");
        console.log("========CalUnit===="+CalUnit);
        console.log("========MIVal===="+MIVal);
        var miaction = component.get("c.getMatereialItems");
        miaction.setParams({
            CalUnit :CalUnit ,
            equiptype : Equip
        });
        miaction.setCallback(this, function(res) {
            console.log("=====Materail Items records===="+ res.getReturnValue());
            if(res.getState() === "SUCCESS"){
                component.set("v.MItem_Records", res.getReturnValue());
                var MIvalId=component.find("MISelectId");
                setTimeout($A.getCallback(function() {
                    MIvalId.set("v.value",MIVal);
                }), 1000);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Production Estimate Material item field has '+errors[0].message
                });
            }
        });
        $A.enqueueAction(miaction);  
    },
   
    getGLDepartment: function(component, event, helper){
        var action1 = component.get("c.getGLDepartments");
        action1.setCallback(this, function(res) {
            console.log("=====GLD List===="+ res.getReturnValue());
            if(res.getState() === "SUCCESS"){
                component.set("v.GL_DepartmentRecords", res.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Production Estimate GL Department field has '+errors[0].message
                });
            }
        });
        $A.enqueueAction(action1);
    },
   
    getGLCode: function(component, event,helper, GLCodeVal,VendorVal){
        var GLDId=component.find("GLDSelectId").get('v.value');
        console.log('===getGLCode Method GLCodeVal==='+GLCodeVal);
        console.log('===getGLCode Method VendorVal==='+VendorVal);
        console.log('===getGLCode Method GLDId==='+GLDId);      
        var actionCC = component.get("c.getGLCodes");
        actionCC.setParams({
            GLDName :GLDId
        });
        actionCC.setCallback(this, function(res){
            console.log("===List of GLC===" + JSON.stringify(res.getReturnValue()));
            if(res.getState() === "SUCCESS"){
                component.set("v.GL_CodeRecords",res.getReturnValue());  
               
                /*setTimeout($A.getCallback(function() {
                    component.find("GLCodeSelectId").set("v.value",GLCodeVal);
                   
                }), 1000);*/
                if(GLCodeVal!=null && VendorVal!=null){
                    this.getVendor(component, event,helper, GLCodeVal, VendorVal);
                }
               
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Production Estimate GL Code field has '+errors[0].message
                });
            }
        });
        $A.enqueueAction(actionCC);  
    },
   
    getVendor:  function(component, event,helper,GLCodeVal, VendorVal){
        console.log('===getVendor Method GLCodeVal==='+GLCodeVal);
        console.log('===getVendor Method VendorVal==='+VendorVal);
       
        var GLCId= GLCodeVal; //component.find("GLCodeSelectId").get('v.value');
        console.log('-getVendor Method GLDId---'+GLCId);
        var actionVen = component.get("c.getVendors");
        actionVen.setParams({
            GLCName :GLCId
        });
        actionVen.setCallback(this, function(res){
            console.log("===List of Vendors===" + JSON.stringify(res.getReturnValue()));
            if(res.getState() === "SUCCESS"){
                component.set("v.VendorRecords", res.getReturnValue());
                var glcodeId=component.find("GLCodeSelectId");
                var venId=component.find("VendorId");
                setTimeout($A.getCallback(function() {
                    glcodeId.set("v.value",GLCodeVal);
                    venId.set("v.value",VendorVal);
                }), 3000);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Production Estimate vendor field has '+errors[0].message
                });
            }
        });
        $A.enqueueAction(actionVen);  
    },
   
   
    fetchProEstimateTemplate :function(component, event, helper){
        var PETempAction=component.get("c.getProEstTempforProEst");
        PETempAction.setCallback(this,function(res){
            if(res.getState()==="SUCCESS"){
                component.set("v.ProEstTemplateList",res.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Production Estimate Template has no access'
                });
            }
        });
        $A.enqueueAction(PETempAction);
    },
   
    getRowActions: function (component, row, doneCallback) {
        var actions = [{'label': 'Duplicate','iconName': 'action:clone','name': 'Dup_ProEstimate'}];
       
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_ProEstimate',
            'disabled':row.
            Approved__c
        };
       
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_ProEstimate',
            'disabled':row.Approved__c
        };
        var approveAction = {
            'label': 'Approve',
            'iconName': 'action:approval',
            'name': 'Approve_ProEstimate',
            'disabled':row.Approved__c
        };
       
        var unApproveAction = {
            'label': 'Unapprove',
            'iconName': 'utility:close',
            'name': 'UnApprove_ProEstimate',
            'disabled':!row.Approved__c
        };
        actions.push(editAction,deleteAction,approveAction,unApproveAction);
       
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
   
    ImportPETempSpecItems: function(component, event, helper){
        var TempId=component.find("ProEstTemplateId").get("v.value");
        var ImpAction=component.get("c.ImportProEstTemp");
        ImpAction.setParams({
            ProEstTemID:TempId,
            JobId:component.get("v.jobrecordId")
        });
        ImpAction.setCallback(this,function(res){
            console.log("========Import Result=========="+res.getReturnValue());
            if(res.getState()==="SUCCESS"){
                if(res.getReturnValue()=="OK"){
                    helper.showToast({
                        "type":"success",
                        "message":"Successfully Imported the Production Estimate Template."
                    });
                    component.find("ProEstTemplateId").set("v.value",null);
                    helper.fetchJobProEstimates(component, event, helper);
                }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type":"error",
                        "message": 'Production Estimate Template has '+res.getReturnValue()
                    });  
                }
            }
            else{
                helper.showToast({
                    "title":"Error!!",
                    "type":"error",
                    "message":'Production Estimate Template has '+res.getReturnValue()
                });    
            }
        });
       
        $A.enqueueAction(ImpAction);
       
    },
   
    approveJobProEst :function(component, event, helper, selectPEstId){
       
        var Appaction=component.get("c.approveProEst");
        if(selectPEstId!=null || selectPEstId!=undefined){
            Appaction.setParams({
                ProEstID :selectPEstId
            });
        }
        else{
            var row = event.getParam('row');
            Appaction.setParams({
                ProEstID :row.Id
            });
            console.log('===Approve PEst Id=='+row.Id);
        }  
       
        Appaction.setCallback(this,function(res){
            console.log("========Approve result=========="+res.getReturnValue());
            if(res.getState()==="SUCCESS"){
                if(res.getReturnValue()=="OK"){
                    helper.showToast({
                        "type":"success",
                        "message":"Record approved Successfully."
                    });
                    helper.fetchJobProEstimates(component, event, helper);
                    helper.reloadDataTable();
                }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type":"error",
                        "message":'Production Estimate has '+res.getReturnValue()
                    });  
                }
            }
            else{
                helper.showToast({
                    "title":"Error!!",
                    "type":"error",
                    "message":'Production Estimate has '+res.getReturnValue()
                });    
            }
        });
       
        $A.enqueueAction(Appaction);
    },
   
    unapproveJobProEst :function(component, event, helper, selectPEstId){
       
        var unAppaction=component.get("c.unApproveProEst");
        if(selectPEstId!=null || selectPEstId!=undefined){
            unAppaction.setParams({
                ProEstID :selectPEstId
            });
        }
        else{
            var row = event.getParam('row');
            unAppaction.setParams({
                ProEstID :row.Id
            });
            console.log('===unapprove PEst Id=='+row.Id);
        }  
       
        unAppaction.setCallback(this,function(res){
            console.log("========Unapprove result=========="+res.getReturnValue());
            if(res.getState()==="SUCCESS"){
                if(res.getReturnValue()=="OK"){
                    helper.showToast({
                        "type":"success",
                        "message":"Record Unapproved Successfully."
                    });
                    helper.fetchJobProEstimates(component, event, helper);
                    helper.reloadDataTable();
                }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type":"error",
                        "message":'Production Estimate has '+res.getReturnValue()
                    });  
                }
            }
            else{
                helper.showToast({
                    "title":"Error!!",
                    "type":"error",
                    "message":'Production Estimate has '+res.getReturnValue()
                });    
            }
        });
        $A.enqueueAction(unAppaction);
    },
   
    duplicateJobProEst :function(component, event, helper, selectPEstId){
       
        var dupAction=component.get("c.duplicateProEst");
        if(selectPEstId!=null || selectPEstId!=undefined){
            dupAction.setParams({
                ProEstID :selectPEstId
            });
        }
        else{
            var row = event.getParam('row');
            dupAction.setParams({
                ProEstID :row.Id
            });
            console.log('===Dup PEst Id=='+row.Id);
        }  
       
        dupAction.setCallback(this,function(res){
            console.log("========duplicate result=========="+res.getReturnValue());
            if(res.getState()==="SUCCESS"){
                if(res.getReturnValue()=="OK"){
                    helper.showToast({
                        "type":"success",
                        "message":"Record Duplicated Successfully."
                    });
                    helper.fetchJobProEstimates(component, event, helper);
                }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type":"error",
                        "message":'Production Estimate has '+res.getReturnValue()
                    });  
                }
            }
            else{
                helper.showToast({
                    "title":"Error!!",
                    "type":"error",
                    "message":'Production Estimate has '+res.getReturnValue()
                });    
            }
        });
        $A.enqueueAction(dupAction);  
    },
   
    deleteJobProEst :function(component, event, helper, selectPEstId){
       
        var delAction=component.get("c.deleteProEst");
        if(selectPEstId!=null || selectPEstId!=undefined){
            delAction.setParams({
                ProEstID :selectPEstId
            });
        }
        else{
            var row = event.getParam('row');
            delAction.setParams({
                ProEstID :row.Id
            });
            console.log('===Del PEst Id=='+row.Id);
        }  
       
        delAction.setCallback(this,function(res){
            var delreslut=res.getReturnValue();
            console.log("========Delete Result=========="+JSON.stringify(delreslut));
            if(res.getState()==="SUCCESS"){
                if(delreslut[0]=="OK"){
                    helper.showToast({
                        "type":"success",
                        "message":"Record Deleted Successfully."
                    });
                    helper.fetchJobProEstimates(component, event, helper);
                }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type":"error",
                        "message":'Production Estimate has '+delreslut[1]
                    });  
                }
            }
            else{
                helper.showToast({
                    "title":"Error!!",
                    "type":"error",
                    "message":'Production Estimate has '+delreslut[1]
                });    
            }
        });
        $A.enqueueAction(delAction);
    },
   
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
        //$A.get('e.force:refreshView').fire();
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
   
   
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.data", data);
    },
    sortBy: function (field, reverse, primer) {
        //console.log('==sortBy=primer==='+primer);
        //console.log('==sortBy=field==='+field);
        //console.log('==sortBy=reverse==='+reverse);
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
})