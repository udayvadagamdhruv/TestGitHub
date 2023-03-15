// This trigger is used to check duplicate Job Tasks under single Job and updates the Revised Due Date after Task's Days field is changed
trigger duplicateJobTasksandUpdateTaskRevisedDate on Job_Task__c (before insert,before update,after insert, after update) 
{
    
    // Check for duplicate Job Task under one Job
    If((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate))
    {
        Set<Id> stTemp=new Set<Id>();       
        for(Job_Task__c st:Trigger.New)  
        {  
            stTemp.add(st.Job__c);           
        }
        
        for(Job_Task__c st1:Trigger.New){
            
            if(st1.Task_Order__c==1 && st1.Marked_Done__c!=True ){
                if(Schema.sObjectType.Job_Task__c.fields.Next_Task_Due__c.isCreateable() || Schema.sObjectType.Job_Task__c.fields.Next_Task_Due__c.isUpdateable()) {
                    st1.Next_Task_Due__c=True;}
                
            }
            
        }
        MAP<String,Job_Task__c>  inDb = new MAP<String,Job_Task__c>(); 
        MAP<String,Job_Task__c> inBatch = new MAP<String,Job_Task__c>();
        for(Job_Task__c st:Trigger.New)
        {   
            stTemp.add(st.Job__c);
        }
        for ( Job_Task__c t : [Select Id,Name,Job__c from Job_Task__c where Job__c IN : stTemp WITH SECURITY_ENFORCED])
            inDb.put(t.Name+t.Job__c,t);
        
        for ( Job_Task__c t : Trigger.New)
        {
            If (inDb.containsKey(t.Name+t.Job__c)) 
            {
                If(Trigger.isInsert || t.id!=inDb.get(t.Name+t.Job__c).Id) //if update then ignore itself as a dup
                    t.AddError('Task Name already Exists For this Job');
            }
            Else If (inBatch.containsKey(t.Name+t.Job__c))
            {
                t.AddError('Duplicate in batch....');
                //  inBatch.get(t.Name+t.Job__c).AddError('Dup in Batch'); //optional, allow one or fail all
            }
            Else
            {
                inBatch.put(t.Name+t.Job__c,t);
            }
        }
    }// End of Checking for Duplicates
    
    /*  Decimal taskorder;
String  sjob;
If(Trigger.IsBefore && Trigger.IsUpdate){
for(Job_Task__c objJT:Trigger.New){
sjob=objJT.Job__c;
if(objJT.Marked_Done__c==True && objJT.Next_Task_Due__c==True && !System.isFuture()){
system.debug('I am true'+objJT.Next_Task_Due__c);
objJT.Next_Task_Due__c=False;
taskorder=objJT.Task_Order__c+1;
system.debug('I am False'+objJT.Next_Task_Due__c);
UpdatenextsheduleTask.UpdatenextsheduleTaskmethod(sjob,taskorder);        
}
} 
}
*/
    
    String  sjob;
    set<string> jobids=new set<string>();
    boolean  MarkedDone=false;
    Map<Id,Job_Task__c> OldTasksMap;
    Map<Id,Job_Task__c>  NewTasksMap;
    if(Trigger.IsAfter && Trigger.IsUpdate)
    {
        OldTasksMap=new Map<Id,Job_Task__c>();
        NewTasksMap=new Map<Id,Job_Task__c>();
        for(Job_Task__c objJT:Trigger.New)
        {
            sjob=objJT.Job__c;
            If(!System.isFuture() && !system.isbatch())
            {
                if(Trigger.oldMap.get(objJT.Id).Marked_Done__c!=true && Trigger.NewMap.get(objJT.Id).Marked_Done__c==true){
                    MarkedDone=true;
                }
                jobids.add(sjob);  
            }
        }        
        /*  If(!System.isFuture() && !system.isbatch())
{
OldTasksMap=Trigger.oldMap;
NewTasksMap=Trigger.newMap;
//UpdatenextsheduleTask.TaskRemainderNotiftication(OldTasksMap,NewTasksMap,jobids);
System.debug('========trigger old jobs==='+OldTasksMap.values());
System.debug('========trigger New  jobs==='+NewTasksMap.values());        

}
*/
    }
    
    if(jobids.size()>0){
        if(!Test.isRunningTest()){
            List<Job_Task__c> CompletedTasks1=[select id,name,Next_Task_Due__c,Email__c,Task_Order__c,Marked_Done__c,Revised_Due_Date__c,Job__c,Job__r.Job_Auto_Number__c,Job__r.name from Job_Task__c where  Job__c IN :jobids AND Marked_Done__c!=True WITH SECURITY_ENFORCED order by Task_Order__c limit  1];
            //Logic below two lines added for job timing status update 
            if(CompletedTasks1.size() > 0){
                date finalduedate = CompletedTasks1[0].Revised_Due_Date__c;
                Job__c objJob =[Select id,name,Next_Tasks_Due__c,Job_Timing_Status__c,Due_Date__c from Job__c where Id=:CompletedTasks1[0].Job__c WITH SECURITY_ENFORCED limit 1];
                if(finalduedate >= system.today() &&  objJob.Due_Date__c >= system.today())
                {
                    objJob.Job_Timing_Status__c =  'On Track' ;
                }
                if(finalduedate < system.today() && objJob.Due_Date__c >= system.today()){
                    objJob.Job_Timing_Status__c =  'At Risk' ;  
                }
                if(objJob.Due_Date__c <= system.today() ){
                    objJob.Job_Timing_Status__c =  'Delayed' ;  
                }
                if(Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isCreateable() || Schema.sObjectType.Job__c.fields.Next_Tasks_Due__c.isUpdateable()) {
                    objJob.Next_Tasks_Due__c = CompletedTasks1[0].name;
                }
                if(Schema.sObjectType.Job__c.isUpdateable())
                {
                    update objJob;
                    system.debug('updated job === '+objJob.Next_Tasks_Due__c);
                }
            }
        }
        UpdatenextsheduleTask.UpdatenextsheduleTaskmethod2(jobids,MarkedDone);
        //UpdatenextsheduleTask.UpdatenextsheduleTaskmethod3(jobids,MarkedDone);
    }
    
    // Trigger code is executed after days field of Task is changed
    /*
If(Trigger.isBefore && Trigger.isUpdate)
{          
for(Job_task__c jt:Trigger.New)
{
Job_Task__c oldTask=Trigger.oldMap.get(jt.id);
If(jt.Days__c!=oldTask.Days__c)
{
SET<Date> holidays=new SET<Date>();
for(Holiday__c hc: [Select Date__c from Holiday__c where Date__c !=null])
{
holidays.add(hc.Date__c );
}

Datetime dtStartDate1=Datetime.newInstance(jt.Start_Date__c,Time.newInstance(12, 0, 0, 0));
system.debug('Start Date is : ' +dtStartDate1);
Integer jCount=0;
System.debug('jCount value '+jCount);

while(true)
{
Date d3=Date.newInstance(dtStartDate1.Year(),dtStartDate1.Month(),dtStartDate1.Day());

If((dtStartDate1.format('E')!='Sat' && dtStartDate1.format('E')!='Sun')&&(!holidays.contains(d3)))
{
jCount=jCount +1;
if(jCount>jt.Days__c)
{
break;
}
system.debug('jCount======' + jCount);
system.debug('==========' + dtStartDate1);

system.debug('===========' + dtStartDate1.format('E'));
dtStartDate1=dtStartDate1.addDays(1);
system.debug('after adding 1 day==========' + dtStartDate1);
}
Else
{
system.debug('==========' + dtStartDate1);
dtStartDate1=dtStartDate1.addDays(1);
continue;
}
}  
Date  d1 = Date.newInstance(dtStartDate1.Year(),dtStartDate1.Month(),dtStartDate1.Day());
System.debug('D1 is as follows : '+d1);

jt.Revised_Due_Date__c=d1;
}
}    
}// ENd of Trigger code which will execute after updating Days field on Job Task
*/
}// ENd of Trigger