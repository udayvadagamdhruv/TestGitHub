trigger UpdateJobsEstimateAmount on Estimate_Line_Items__c (after delete, after insert, after update) 
{
    
    //Limit the size of list by using Sets which do not contain duplicate elements
    set<Id> JobIds = new set<Id>();
    set<Id> GLCodeIds = new set<Id>();
    
    //When adding new ELI or updating existing ELIs
    if(trigger.isInsert || trigger.isUpdate)
    {
        for(Estimate_Line_Items__c p : trigger.new)
        {
            JobIds.add(p.Job__c);
            GLCodeIds.add(p.GL_Code__c);
        }
    }
    
    //When deleting ELIs
    if(trigger.isDelete)
    {
        for(Estimate_Line_Items__c p : trigger.old)
        {
            JobIds.add(p.Job__c);
            GLCodeIds.add(p.GL_Code__c);
        }
    } 
    
    //Map will contain one Job Id to one sum value
    map<Id,Double> JobMap = new map<Id,Double> ();
    
    //Produce a sum of Total_Amount__c and add them to the map
    //use group by to have a single Job Id with a single sum value
    for(AggregateResult q : [select Job__c,sum(Total_Amount__c) from Estimate_Line_Items__c where Job__c IN :JobIds and Approved__c =: True WITH SECURITY_ENFORCED group by Job__c])
    {
        //  JobMap.put((Id)q.get('Job__c'),(Double)q.get('expr0'));
        JobMap.put(String.valueOf(q.get('Job__c')),Double.valueOf((q.get('expr0') == null)? 0 : q.get('expr0')));
        
    }
    
    List<Job__c> JobToUpdate = new List<Job__c>();
    
    //Run the for loop on Job using the non-duplicate set of Jobs Ids
    //Get the sum value from the map and create a list of Jobs to update
    for(Job__c o : [Select Id, Estimate_Total__c from Job__c where Id IN :JobIds WITH SECURITY_ENFORCED])
    {
        Double PaymentSum = JobMap.get(o.Id);
        if(Schema.sObjectType.Job__c.fields.Estimate_Total__c.isUpdateable()){
            o.Estimate_Total__c = PaymentSum;
        }
        if(o.Estimate_Total__c == Null)
        {
            if(Schema.sObjectType.Job__c.fields.Estimate_Total__c.isUpdateable()){
                o.Estimate_Total__c = 0.00;
            }
        }
        JobToUpdate.add(o);
    }
    if(Schema.sObjectType.Job__c.isUpdateable()){
        update JobToUpdate;
    }
    
    //added by yogini for job timesheet hours update
    map<Id, map<id,double>> JSTSObj = new map<id, map<id,double>>();
    map<id,double> Glcodedat = new map<id,double>();
    for(AggregateResult q:[select Job__c,GL_Code__c, Sum(Quantity__c) from Estimate_Line_Items__c where Job__c In :JobIds and GL_Code__c In :GLCodeIds WITH SECURITY_ENFORCED group by Job__c,GL_Code__c ])
    {
        system.debug('estimate data to update---->'+q);
        //JSTSObj.put(string.valueof(q.get('Job__c')),new map<id,double>{string.valueof(q.get('GL_Code__c'))=>Double.valueOf((q.get('expr0') == null)? 0 : q.get('expr0'))});
        Glcodedat.put(string.valueof(q.get('GL_Code__c')),Double.valueOf((q.get('expr0') == null)? 0 : q.get('expr0')));
        JSTSObj.put(string.valueof(q.get('Job__c')),Glcodedat);
    }
    
    system.debug('map data---->'+JSTSObj);
    system.debug('map size---->'+JSTSObj.size());
    system.debug('jobs to update--->'+JobIds );
    system.debug('GL code to update--->'+GLCodeIds );
    
    List<JS_Time_Sheet__c> lstJsEst = new List<JS_Time_Sheet__c>();
    
    For(JS_Time_Sheet__c objJS:[select Id, Estimated_Hours__c,Job__c,GL_Code__c from JS_Time_Sheet__c where Job__c In :JobIds and GL_Code__c In:GLCodeIds WITH SECURITY_ENFORCED]){
        system.debug('estimate line item entry---->'+objJS);
        //system.debug('update map detail--->'+JSTSObj.get(objJS.Job__c).get(objJS.GL_Code__c));
        
        if(JSTSObj.keyset().contains(objJS.Job__c)) {
            if(JSTSObj.get(objJS.Job__c).keyset().contains(objJS.GL_Code__c)){
                Double tsEstimateHrs = JSTSObj.get(objJS.Job__c).get(objJS.GL_Code__c);
                if(Schema.sObjectType.JS_Time_Sheet__c.fields.Estimated_Hours__c.isUpdateable()){
                    objJS.Estimated_Hours__c = tsEstimateHrs;
                }
            }
        }
        if(objJS.Estimated_Hours__c == Null){
            if(Schema.sObjectType.JS_Time_Sheet__c.fields.Estimated_Hours__c.isUpdateable()){
                objJS.Estimated_Hours__c = 0.00;
            }
        }
        lstJsEst.add(objJS);
    }
    system.debug('final data to update--->'+lstJsEst);
    if(Schema.sObjectType.JS_Time_Sheet__c.isUpdateable()){
        update lstJsEst;
    }
}